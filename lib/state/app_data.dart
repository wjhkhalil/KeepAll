import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import '../core/dates.dart';
import '../l10n/app_localizations.dart';
import '../data/data_store.dart';
import '../data/models.dart';
import '../services/reminder_scheduler.dart';

/// Holds all user data, persists every change and keeps OS reminders in sync.
class AppData extends ChangeNotifier {
  AppData({
    required this.store,
    required this.scheduler,
    DateTime Function()? clock,
    AppLocalizations? l10n,
  }) : _clock = clock ?? DateTime.now,
       l10n = l10n ?? lookupAppLocalizations(const Locale('en'));

  static const schemaVersion = 1;
  static const snoozeDuration = Duration(minutes: 10);
  static const taskPayloadPrefix = 'task:';
  static const documentPayloadPrefix = 'doc:';

  final DataStore store;
  final ReminderScheduler scheduler;
  final DateTime Function() _clock;

  /// Used for reminder text shown by the OS. Updated when the language changes.
  AppLocalizations l10n;
  final _uuid = const Uuid();
  final _random = Random();

  List<Task> _tasks = [];
  List<ShoppingList> _lists = [];
  List<Receipt> _receipts = [];
  List<Document> _documents = [];
  Directory? _imagesDir;
  bool _loaded = false;

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<ShoppingList> get lists => List.unmodifiable(_lists);
  List<Receipt> get receipts => List.unmodifiable(_receipts);
  List<Document> get documents => List.unmodifiable(_documents);
  bool get loaded => _loaded;
  DateTime get now => _clock();

  Future<void> load() async {
    final data = await store.load();
    if (data != null) _applyJson(data);
    _imagesDir = await store.imagesDir();
    _loaded = true;
    notifyListeners();
    await resyncReminders();
  }

  static List<T> _decodeList<T>(Object? raw, T Function(Map<String, dynamic>) fromJson) {
    if (raw is! List) return [];
    final out = <T>[];
    for (final e in raw) {
      try {
        out.add(fromJson(Map<String, dynamic>.from(e as Map)));
      } catch (e) {
        // Skip a corrupt record rather than losing everything.
        debugPrint('Skipping unreadable record: $e');
      }
    }
    return out;
  }

  void _applyJson(Map<String, dynamic> data) {
    _tasks = _decodeList(data['tasks'], Task.fromJson);
    _lists = _decodeList(data['lists'], ShoppingList.fromJson);
    _receipts = _decodeList(data['receipts'], Receipt.fromJson);
    _documents = _decodeList(data['documents'], Document.fromJson);
  }

  Map<String, dynamic> toJson() => {
    'version': schemaVersion,
    'tasks': _tasks.map((t) => t.toJson()).toList(),
    'lists': _lists.map((l) => l.toJson()).toList(),
    'receipts': _receipts.map((r) => r.toJson()).toList(),
    'documents': _documents.map((d) => d.toJson()).toList(),
  };

  /// Replaces all data (used by restore) and reschedules every reminder.
  Future<void> replaceAllData(Map<String, dynamic> data) async {
    _applyJson(data);
    await _commit();
    await resyncReminders();
  }

  /// Every photo file name referenced by receipts or documents.
  Set<String> get referencedImages => {
    for (final r in _receipts)
      if (r.imageFile != null) r.imageFile!,
    for (final d in _documents)
      if (d.imageFile != null) d.imageFile!,
  };

  Future<Directory> imagesDir() async => _imagesDir ??= await store.imagesDir();

  Future<void> _commit() async {
    notifyListeners();
    await store.save(toJson());
  }

  String newId() => _uuid.v4();

  // ---------------------------------------------------------------- Tasks

  Task? taskById(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  Task newTask({
    required String title,
    String notes = '',
    TaskCategory category = TaskCategory.general,
    DateTime? dueAt,
    bool hasTime = false,
    bool remind = false,
    Repeat repeat = Repeat.none,
  }) => Task(
    id: newId(),
    notificationId: _newNotificationId(),
    title: title,
    notes: notes,
    category: category,
    dueAt: dueAt,
    hasTime: hasTime,
    remind: remind,
    repeat: repeat,
    createdAt: now,
  );

  int _newNotificationId() {
    final used = {
      for (final t in _tasks) ...[t.notificationId, t.snoozeNotificationId],
      ..._documents.map((d) => d.notificationId),
    };
    int id;
    do {
      id = _random.nextInt(0x7FFFFFFF);
    } while (used.contains(id) || used.contains(id ^ 0x40000000));
    return id;
  }

  /// Inserts or replaces [task].
  Future<void> saveTask(Task task) async {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i >= 0) {
      _tasks[i] = task;
    } else {
      _tasks.add(task);
    }
    await _commit();
    await _syncReminder(task);
  }

  Future<void> deleteTask(String id) async {
    final task = taskById(id);
    if (task == null) return;
    _tasks.removeWhere((t) => t.id == id);
    await _commit();
    await _cancelReminders(task);
  }

  /// Marks a task done. Repeating tasks instead roll forward to their next
  /// occurrence. Returns the previous state so the UI can offer "Undo".
  ///
  /// [includeToday] is for "Done" on a reminder: the phone repeats those by
  /// itself, so today's reminder may belong to a task still dated days ago.
  /// Then today's occurrence is the one being done, not only the missed one.
  Future<Task?> completeTask(String id, {bool includeToday = false}) async {
    final task = taskById(id);
    if (task == null) return null;
    final Task updated;
    if (task.repeat != Repeat.none && task.dueAt != null) {
      var next = task.repeat.next(task.dueAt!, anchorDay: task.anchorDay);
      // Skip occurrences already in the past (e.g. a week of missed pills).
      final today = dateOnly(now);
      bool inPast(DateTime d) => task.hasTime
          ? !d.isAfter(now)
          : includeToday
          ? !dateOnly(d).isAfter(today)
          : dateOnly(d).isBefore(today);
      while (inPast(next)) {
        next = task.repeat.next(next, anchorDay: task.anchorDay);
      }
      updated = task.copyWith(dueAt: () => next, snoozedUntil: () => null);
    } else {
      updated = task.copyWith(done: true, completedAt: () => now, snoozedUntil: () => null);
    }
    await saveTask(updated);
    return task;
  }

  Future<void> reopenTask(String id) async {
    final task = taskById(id);
    if (task == null) return;
    await saveTask(task.copyWith(done: false, completedAt: () => null));
  }

  Future<void> snoozeTask(String id, {Duration duration = snoozeDuration}) async {
    final task = taskById(id);
    if (task == null) return;
    await saveTask(task.copyWith(snoozedUntil: () => now.add(duration)));
  }

  /// The OS reminders for [task]: none, one, or for a repeating task that
  /// was snoozed, the repeating one plus the snoozed one.
  List<ReminderRequest> remindersFor(Task task) {
    final first = task.reminderAt;
    if (first == null) return const [];
    ReminderRequest request(int id, DateTime when, String body, [Repeat repeat = Repeat.none]) =>
        ReminderRequest(
          id: id,
          title: task.title,
          body: task.notes.isNotEmpty ? task.notes : body,
          when: when,
          payload: '$taskPayloadPrefix${task.id}',
          repeat: repeat,
        );
    String dated(DateTime d) => task.hasTime ? formatDateTime(d) : formatDate(d);

    if (task.repeat == Repeat.none) {
      if (!first.isAfter(now)) return const [];
      return [request(task.notificationId, first, dated(task.dueAt!))];
    }

    // Repeating: the next occurrence, even if earlier ones were never ticked
    // off — the medicine is still needed tomorrow.
    var next = task.hasTime
        ? task.dueAt!
        : DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day, Task.allDayReminderHour);
    while (!next.isAfter(now)) {
      next = task.repeat.next(next, anchorDay: task.anchorDay);
    }
    final phoneRepeat = _phoneRepeat(task, next);
    final body = phoneRepeat == Repeat.none
        ? dated(next)
        : task.hasTime
        ? '${_repeatText(task.repeat)} · ${formatTime(next)}'
        : _repeatText(task.repeat);
    final snooze = task.snoozedUntil;
    return [
      request(task.notificationId, next, body, phoneRepeat),
      if (snooze != null && snooze.isAfter(now)) request(task.snoozeNotificationId, snooze, dated(task.dueAt!)),
    ];
  }

  /// Whether the phone can repeat [task]'s reminder by itself, starting at
  /// [next]. It only matches the time (and weekday / day of month) and
  /// ignores the start date, so it may only take over once the start is at
  /// most one period away; until then the first one is a single reminder.
  /// It would also skip months without a 29th–31st, so those stay single
  /// reminders, rescheduled whenever the app opens or the task is ticked.
  Repeat _phoneRepeat(Task task, DateTime next) {
    final r = task.repeat;
    if (next.isAfter(r.next(now))) return Repeat.none;
    final day = task.anchorDay ?? task.dueAt!.day;
    if (r == Repeat.monthly && day > 28) return Repeat.none;
    if (r == Repeat.yearly && task.dueAt!.month == 2 && day > 28) return Repeat.none;
    return r;
  }

  String _repeatText(Repeat r) => switch (r) {
    Repeat.none => '',
    Repeat.daily => l10n.repeatDaily,
    Repeat.weekly => l10n.repeatWeekly,
    Repeat.monthly => l10n.repeatMonthly,
    Repeat.yearly => l10n.repeatYearly,
  };

  Future<void> _cancelReminders(Task task) async {
    await scheduler.cancel(task.notificationId);
    await scheduler.cancel(task.snoozeNotificationId);
  }

  Future<void> _syncReminder(Task task) async {
    await _cancelReminders(task);
    for (final r in remindersFor(task)) {
      await scheduler.schedule(r);
    }
  }

  Future<void> resyncReminders() async {
    final requests = [
      ..._tasks.expand(remindersFor),
      ..._documents.map(reminderForDocument).whereType<ReminderRequest>(),
    ];
    try {
      await scheduler.replaceAll(requests);
    } catch (e) {
      debugPrint('Could not schedule reminders: $e');
    }
  }

  /// Handles a notification tap or action. Returns what to open, if anything.
  Future<ReminderTarget?> handleReminderResponse(ReminderResponse response) async {
    final payload = response.payload;
    if (payload.startsWith(documentPayloadPrefix)) {
      final id = payload.substring(documentPayloadPrefix.length);
      // Document reminders have no actions; a tap simply opens it.
      return documentById(id) == null ? null : ReminderTarget.document(id);
    }
    if (!payload.startsWith(taskPayloadPrefix)) return null;
    final id = payload.substring(taskPayloadPrefix.length);
    if (taskById(id) == null) return null;
    switch (response.action) {
      case ReminderScheduler.actionSnooze:
        await snoozeTask(id);
        return null;
      case ReminderScheduler.actionDone:
        await completeTask(id, includeToday: true);
        return null;
      default:
        return ReminderTarget.task(id);
    }
  }

  // --------------------------------------------------------- Task queries

  List<Task> get openTasks => _tasks.where((t) => !t.done).toList();

  /// The next 3 open tasks by due time for the Home card: overdue first,
  /// then the soonest, tasks without a date last. Not by creation time — a
  /// task added last but due tonight must not push out this afternoon's.
  List<Task> get upcomingTasks => (openTasks..sort(_byDue)).take(3).toList();

  /// Open tasks due today or earlier.
  List<Task> get dueTodayOrOverdue {
    final end = dateOnly(now).add(const Duration(days: 1));
    return openTasks.where((t) => t.dueAt != null && t.dueAt!.isBefore(end)).toList()
      ..sort(_byDue);
  }

  List<Task> openInCategory(TaskCategory c) =>
      openTasks.where((t) => t.category == c).toList()..sort(_byDue);

  /// Open tasks in [c] due before the end of the current (Monday-based) week.
  int dueThisWeek(TaskCategory c) {
    final end = startOfWeek(now).add(const Duration(days: 7));
    return openTasks.where((t) => t.category == c && t.dueAt != null && t.dueAt!.isBefore(end)).length;
  }

  /// The soonest upcoming exam, if any.
  Task? get nextExam {
    final today = dateOnly(now);
    final exams = openInCategory(TaskCategory.exam)
        .where((t) => t.dueAt != null && !dateOnly(t.dueAt!).isBefore(today))
        .toList();
    return exams.isEmpty ? null : exams.first;
  }

  static int _byDue(Task a, Task b) {
    if (a.dueAt == null && b.dueAt == null) return a.createdAt.compareTo(b.createdAt);
    if (a.dueAt == null) return 1;
    if (b.dueAt == null) return -1;
    return a.dueAt!.compareTo(b.dueAt!);
  }

  static int compareByDue(Task a, Task b) => _byDue(a, b);

  // ------------------------------------------------------ Shopping lists

  ShoppingList? listById(String id) {
    for (final l in _lists) {
      if (l.id == id) return l;
    }
    return null;
  }

  int get shoppingItemsRemaining => _lists.fold(0, (sum, l) => sum + l.remaining);

  Future<ShoppingList> addList(String name) async {
    final list = ShoppingList(id: newId(), name: name, createdAt: now);
    _lists.add(list);
    await _commit();
    return list;
  }

  Future<void> saveList(ShoppingList list) async {
    final i = _lists.indexWhere((l) => l.id == list.id);
    if (i >= 0) {
      _lists[i] = list;
    } else {
      _lists.add(list);
    }
    await _commit();
  }

  /// Removes a list and returns it (with its position) for undo.
  Future<(ShoppingList, int)?> deleteList(String id) async {
    final i = _lists.indexWhere((l) => l.id == id);
    if (i < 0) return null;
    final removed = _lists.removeAt(i);
    await _commit();
    return (removed, i);
  }

  Future<void> restoreList(ShoppingList list, int index) async {
    _lists.insert(index.clamp(0, _lists.length), list);
    await _commit();
  }

  Future<void> addItem(String listId, String name, {String quantity = ''}) async {
    final list = listById(listId);
    if (list == null) return;
    final item = ShoppingItem(id: newId(), name: name, quantity: quantity);
    await saveList(list.copyWith(items: [...list.items, item]));
  }

  Future<void> toggleItem(String listId, String itemId) async {
    final list = listById(listId);
    if (list == null) return;
    await saveList(list.copyWith(
      items: [for (final i in list.items) i.id == itemId ? i.copyWith(checked: !i.checked) : i],
    ));
  }

  Future<void> updateItem(String listId, ShoppingItem item) async {
    final list = listById(listId);
    if (list == null) return;
    await saveList(list.copyWith(items: [for (final i in list.items) i.id == item.id ? item : i]));
  }

  Future<(ShoppingItem, int)?> removeItem(String listId, String itemId) async {
    final list = listById(listId);
    if (list == null) return null;
    final index = list.items.indexWhere((i) => i.id == itemId);
    if (index < 0) return null;
    final items = [...list.items];
    final removed = items.removeAt(index);
    await saveList(list.copyWith(items: items));
    return (removed, index);
  }

  Future<void> restoreItem(String listId, ShoppingItem item, int index) async {
    final list = listById(listId);
    if (list == null) return;
    final items = [...list.items]..insert(index.clamp(0, list.items.length), item);
    await saveList(list.copyWith(items: items));
  }

  /// Removes all ticked items and returns the previous list for undo.
  Future<ShoppingList?> clearChecked(String listId) async {
    final list = listById(listId);
    if (list == null) return null;
    await saveList(list.copyWith(items: list.items.where((i) => !i.checked).toList()));
    return list;
  }

  // ----------------------------------------------------------- Documents

  Document? documentById(String id) {
    for (final d in _documents) {
      if (d.id == id) return d;
    }
    return null;
  }

  Document newDocument({required String title}) =>
      Document(id: newId(), notificationId: _newNotificationId(), title: title, createdAt: now);

  /// Documents sorted by expiry (soonest first); undated ones last.
  List<Document> get documentsByExpiry => [..._documents]..sort((a, b) {
    if (a.expiresAt == null && b.expiresAt == null) return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    if (a.expiresAt == null) return 1;
    if (b.expiresAt == null) return -1;
    return a.expiresAt!.compareTo(b.expiresAt!);
  });

  /// Documents expired or expiring within [days].
  List<Document> expiringWithin(int days) => documentsByExpiry.where((d) {
    final left = d.daysLeft(now);
    return left != null && left <= days;
  }).toList();

  ReminderRequest? reminderForDocument(Document d) {
    final when = d.reminderAt;
    if (when == null || !when.isAfter(now)) return null;
    return ReminderRequest(
      id: d.notificationId,
      title: d.title,
      body: l10n.docExpiresOn(formatDate(d.expiresAt!)),
      when: when,
      payload: '$documentPayloadPrefix${d.id}',
    );
  }

  Future<void> saveDocument(Document doc) async {
    final i = _documents.indexWhere((d) => d.id == doc.id);
    if (i >= 0) {
      final old = _documents[i];
      _documents[i] = doc;
      if (old.imageFile != null && old.imageFile != doc.imageFile) await deleteImageIfUnused(old.imageFile!);
    } else {
      _documents.add(doc);
    }
    await _commit();
    final request = reminderForDocument(doc);
    if (request == null) {
      await scheduler.cancel(doc.notificationId);
    } else {
      await scheduler.schedule(request);
    }
  }

  /// Removes a document but keeps its photo so undo can restore it.
  Future<Document?> deleteDocument(String id) async {
    final i = _documents.indexWhere((d) => d.id == id);
    if (i < 0) return null;
    final removed = _documents.removeAt(i);
    await _commit();
    await scheduler.cancel(removed.notificationId);
    return removed;
  }

  // ------------------------------------------------------------ Receipts

  File? imageFor(Receipt r) => imageNamed(r.imageFile);

  File? imageNamed(String? name) =>
      name == null || _imagesDir == null ? null : File('${_imagesDir!.path}/$name');

  /// Copies a picked photo into app storage and returns its file name.
  Future<String> importImage(String sourcePath) async {
    final dir = await imagesDir();
    final dot = sourcePath.lastIndexOf('.');
    final ext = dot >= 0 && sourcePath.length - dot <= 5 ? sourcePath.substring(dot) : '.jpg';
    final name = '${newId()}$ext';
    await File(sourcePath).copy('${dir.path}/$name');
    return name;
  }

  Future<void> saveReceipt(Receipt receipt) async {
    final i = _receipts.indexWhere((r) => r.id == receipt.id);
    if (i >= 0) {
      final old = _receipts[i];
      _receipts[i] = receipt;
      if (old.imageFile != null && old.imageFile != receipt.imageFile) {
        await _deleteImage(old.imageFile!);
      }
    } else {
      _receipts.add(receipt);
    }
    await _commit();
  }

  /// Removes a receipt but keeps its photo until [purgeReceiptImage] so undo
  /// can restore it.
  Future<Receipt?> deleteReceipt(String id) async {
    final i = _receipts.indexWhere((r) => r.id == id);
    if (i < 0) return null;
    final removed = _receipts.removeAt(i);
    await _commit();
    return removed;
  }

  Future<void> restoreReceipt(Receipt receipt) async {
    _receipts.add(receipt);
    await _commit();
  }

  Future<void> purgeReceiptImage(Receipt receipt) async {
    if (receipt.imageFile != null) await deleteImageIfUnused(receipt.imageFile!);
  }

  /// Deletes a photo unless a saved receipt or document still refers to it.
  Future<void> deleteImageIfUnused(String name) async {
    if (referencedImages.contains(name)) return;
    await _deleteImage(name);
  }

  Future<void> _deleteImage(String name) async {
    final dir = _imagesDir;
    if (dir == null) return;
    final f = File('${dir.path}/$name');
    if (await f.exists()) await f.delete();
  }

  /// Receipts newest first.
  List<Receipt> get receiptsByDate =>
      [..._receipts]..sort((a, b) => b.date.compareTo(a.date) != 0
          ? b.date.compareTo(a.date)
          : b.createdAt.compareTo(a.createdAt));

  List<Receipt> receiptsInMonth(DateTime month) =>
      _receipts.where((r) => r.date.year == month.year && r.date.month == month.month).toList();
}

/// Something a notification tap should open.
class ReminderTarget {
  const ReminderTarget.task(this.id) : isDocument = false;
  const ReminderTarget.document(this.id) : isDocument = true;

  final String id;
  final bool isDocument;
}
