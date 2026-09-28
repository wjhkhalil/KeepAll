import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:keepall/core/dates.dart';
import 'package:keepall/core/money.dart';
import 'package:keepall/data/data_store.dart';
import 'package:keepall/data/models.dart';
import 'package:keepall/services/reminder_scheduler.dart';
import 'package:keepall/state/app_data.dart';
import 'package:keepall/state/task_groups.dart';

void main() {
  setUpAll(() => initializeDateFormatting(appDateLocale));

  late MemoryDataStore store;
  late FakeReminderScheduler scheduler;
  late DateTime now;
  late AppData data;

  setUp(() async {
    store = MemoryDataStore();
    scheduler = FakeReminderScheduler();
    // Far enough in the future that the fake scheduler treats it as upcoming.
    now = DateTime(2100, 9, 23, 10); // a Thursday
    data = AppData(store: store, scheduler: scheduler, clock: () => now);
    await data.load();
  });

  test('saving a task persists it and schedules its reminder', () async {
    final t = data.newTask(title: 'Dentist', dueAt: DateTime(2100, 9, 24, 15), hasTime: true, remind: true);
    await data.saveTask(t);

    expect(store.data!['tasks'], hasLength(1));
    expect(scheduler.scheduled[t.notificationId]!.when, DateTime(2100, 9, 24, 15));
    expect(scheduler.scheduled[t.notificationId]!.payload, 'task:${t.id}');

    final reloaded = AppData(store: store, scheduler: FakeReminderScheduler(), clock: () => now);
    await reloaded.load();
    expect(reloaded.tasks.single.title, 'Dentist');
  });

  test('reminders are rescheduled on load (e.g. after restart)', () async {
    await data.saveTask(data.newTask(title: 'A', dueAt: DateTime(2100, 9, 25), remind: true));
    final freshScheduler = FakeReminderScheduler();
    final reloaded = AppData(store: store, scheduler: freshScheduler, clock: () => now);
    await reloaded.load();
    expect(freshScheduler.scheduled, hasLength(1));
  });

  test('completing a one-off task cancels its reminder and undo restores it', () async {
    final t = data.newTask(title: 'Call bank', dueAt: DateTime(2100, 9, 24), remind: true);
    await data.saveTask(t);
    final previous = await data.completeTask(t.id);
    expect(data.taskById(t.id)!.done, isTrue);
    expect(scheduler.scheduled, isEmpty);

    await data.saveTask(previous!);
    expect(data.taskById(t.id)!.done, isFalse);
    expect(scheduler.scheduled, hasLength(1));
  });

  test('completing a repeating task rolls it forward instead', () async {
    final t = data.newTask(
      title: 'Pills',
      dueAt: DateTime(2100, 9, 23, 8),
      hasTime: true,
      remind: true,
      repeat: Repeat.daily,
    );
    await data.saveTask(t);
    await data.completeTask(t.id);
    final updated = data.taskById(t.id)!;
    expect(updated.done, isFalse);
    expect(updated.dueAt, DateTime(2100, 9, 24, 8));
  });

  test('missed repeats skip to the next future occurrence', () async {
    final t = data.newTask(title: 'Water plants', dueAt: DateTime(2100, 9, 1), repeat: Repeat.weekly);
    await data.saveTask(t);
    await data.completeTask(t.id);
    // 01/09 + weeks → 22/09 is past, 29/09 is the first not before today (23/09).
    expect(data.taskById(t.id)!.dueAt, DateTime(2100, 9, 29));
  });

  test('snooze delays the reminder by 10 minutes', () async {
    final t = data.newTask(title: 'Pills', dueAt: DateTime(2100, 9, 23, 9, 55), hasTime: true, remind: true);
    await data.saveTask(t);
    await data.handleReminderResponse(
      ReminderResponse(payload: 'task:${t.id}', action: ReminderScheduler.actionSnooze),
    );
    expect(scheduler.scheduled[t.notificationId]!.when, now.add(const Duration(minutes: 10)));
  });

  test('tapping a notification returns the task to open; Done completes it', () async {
    final t = data.newTask(title: 'X', dueAt: DateTime(2100, 9, 24), remind: true);
    await data.saveTask(t);
    expect((await data.handleReminderResponse(ReminderResponse(payload: 'task:${t.id}')))!.id, t.id);
    expect(await data.handleReminderResponse(const ReminderResponse(payload: 'task:missing')), isNull);
    await data.handleReminderResponse(ReminderResponse(payload: 'task:${t.id}', action: ReminderScheduler.actionDone));
    expect(data.taskById(t.id)!.done, isTrue);
  });

  test('deleting a task cancels its reminder', () async {
    final t = data.newTask(title: 'X', dueAt: DateTime(2100, 9, 24), remind: true);
    await data.saveTask(t);
    await data.deleteTask(t.id);
    expect(data.tasks, isEmpty);
    expect(scheduler.scheduled, isEmpty);
  });

  test('groupTasks buckets by due date with Monday-start weeks', () {
    Task t(String title, DateTime? due) => data.newTask(title: title, dueAt: due);
    final groups = groupTasks([
      t('overdue', DateTime(2100, 9, 22)),
      t('today', DateTime(2100, 9, 23)),
      t('tomorrow', DateTime(2100, 9, 24)),
      t('sunday', DateTime(2100, 9, 26)),
      t('next monday', DateTime(2100, 9, 27)),
      t('none', null),
    ], now);
    List<String> titles(TaskGroup g) => groups[g]!.map((e) => e.title).toList();
    expect(titles(TaskGroup.overdue), ['overdue']);
    expect(titles(TaskGroup.today), ['today']);
    expect(titles(TaskGroup.tomorrow), ['tomorrow']);
    expect(titles(TaskGroup.thisWeek), ['sunday']);
    expect(titles(TaskGroup.later), ['next monday']);
    expect(titles(TaskGroup.noDate), ['none']);
  });

  test('shopping list items: add, toggle, remove + restore, clear ticked', () async {
    final list = await data.addList('Groceries');
    await data.addItem(list.id, 'Milk');
    await data.addItem(list.id, 'Bread');
    expect(data.shoppingItemsRemaining, 2);

    final milk = data.listById(list.id)!.items.first;
    await data.toggleItem(list.id, milk.id);
    expect(data.shoppingItemsRemaining, 1);

    final removed = await data.removeItem(list.id, milk.id);
    expect(data.listById(list.id)!.items.map((i) => i.name), ['Bread']);
    await data.restoreItem(list.id, removed!.$1, removed.$2);
    expect(data.listById(list.id)!.items.map((i) => i.name), ['Milk', 'Bread']);

    await data.clearChecked(list.id);
    expect(data.listById(list.id)!.items.map((i) => i.name), ['Bread']);
  });

  test('receipts: monthly filter and per-currency totals', () async {
    Receipt r(int cents, Currency c, DateTime date) => Receipt(
      id: data.newId(), merchant: 'Shop', amountCents: cents, currency: c, date: date, createdAt: now,
    );
    await data.saveReceipt(r(1000, Currency.eur, DateTime(2100, 9, 2)));
    await data.saveReceipt(r(250, Currency.eur, DateTime(2100, 9, 20)));
    await data.saveReceipt(r(4000, Currency.chf, DateTime(2100, 9, 21)));
    await data.saveReceipt(r(9999, Currency.eur, DateTime(2100, 8, 31)));

    final totals = totalsByCurrency(data.receiptsInMonth(now).map((x) => (x.amountCents, x.currency)));
    expect(totals, {Currency.eur: 1250, Currency.chf: 4000});
    expect(data.receiptsByDate.first.amountCents, 4000);
  });

  test('corrupt records are skipped instead of losing all data', () async {
    final s = MemoryDataStore({
      'tasks': [
        {'id': 'ok', 'notificationId': 1, 'title': 'fine'},
        {'broken': true},
      ],
    });
    final d = AppData(store: s, scheduler: FakeReminderScheduler(), clock: () => now);
    await d.load();
    expect(d.tasks.map((t) => t.id), ['ok']);
  });
}
