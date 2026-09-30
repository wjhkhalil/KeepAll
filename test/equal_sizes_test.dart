import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lifekeeper/app.dart';
import 'package:lifekeeper/core/money.dart';
import 'package:lifekeeper/data/data_store.dart';
import 'package:lifekeeper/data/models.dart';
import 'package:lifekeeper/services/reminder_scheduler.dart';
import 'package:lifekeeper/state/app_data.dart';
import 'package:lifekeeper/state/settings.dart';
import 'package:lifekeeper/ui/design.dart';
import 'package:lifekeeper/ui/tasks/task_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Boxes of the same kind must all have the same height, whatever their text.
Finder byTypeName(String name) => find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

void expectSameHeights(WidgetTester tester, Finder finder, String what) {
  final heights = finder.evaluate().map((e) => tester.getSize(find.byWidget(e.widget)).height).toList();
  expect(heights.length, greaterThan(1), reason: 'need several $what to compare');
  for (final h in heights) {
    expect(h, moreOrLessEquals(heights.first, epsilon: 0.5), reason: '$what heights differ: $heights');
  }
}

Future<AppData> pump(WidgetTester tester, Map<String, Object> prefs, {double textScale = 1.0}) async {
  tester.view.physicalSize = const Size(412, 2400);
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  SharedPreferences.setMockInitialValues({'onboarded': true, ...prefs});
  late Settings settings;
  late AppData data;
  await tester.runAsync(() async {
    settings = await Settings.load();
    data = AppData(store: MemoryDataStore(), scheduler: FakeReminderScheduler());
    await data.load();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Deliberately mixed: long and short titles, with and without dates.
    await data.saveTask(data.newTask(title: 'A', category: TaskCategory.general));
    await data.saveTask(data.newTask(
      title: 'Renew the car insurance and compare prices from three different companies',
      category: TaskCategory.bill,
      dueAt: today.add(const Duration(days: 2)),
      remind: true,
      repeat: Repeat.yearly,
    ));
    await data.saveTask(data.newTask(title: 'Pills', category: TaskCategory.medicine, dueAt: today.add(const Duration(hours: 20)), hasTime: true));
    await data.saveTask(data.newTask(title: 'Maths exam', category: TaskCategory.exam, dueAt: today.add(const Duration(days: 3))));
    await data.saveDocument(data.newDocument(title: 'ID'));
    await data.saveDocument(data.newDocument(title: 'Home and contents insurance policy with a very long name')
        .copyWith(type: DocumentType.insurance, expiresAt: () => today.add(const Duration(days: 10))));
    await data.saveDocument(data.newDocument(title: 'Passport').copyWith(expiresAt: () => DateTime(2031, 1, 1)));
    await data.saveDocument(data.newDocument(title: 'Old card').copyWith(expiresAt: () => DateTime(2020, 1, 1)));
    final a = await data.addList('Groceries for the big family weekend barbecue party');
    await data.addItem(a.id, 'Milk');
    await data.addList('Empty');
    final b = await data.addList('Hardware');
    await data.addItem(b.id, 'Screws');
    await data.toggleItem(b.id, data.listById(b.id)!.items.single.id);
  });
  await tester.pumpWidget(LifeKeeperApp(settings: settings, data: data));
  await tester.pumpAndSettle();
  return data;
}

Future<void> openTab(WidgetTester tester, int i) async {
  await tester.tap(find.byKey(ValueKey('nav-$i')));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting());

  for (final lang in ['en', 'de', 'pl']) {
    for (final scale in [1.0, 1.6]) {
      for (final mode in ['everyday', 'student', 'simple']) {
        testWidgets('home cards are equal in $mode / $lang / text x$scale', (tester) async {
          await pump(tester, {'mode': mode, 'language': lang}, textScale: scale);
          final cards = byTypeName(mode == 'simple' ? '_SimpleCard' : '_SummaryCard');
          expectSameHeights(tester, cards, 'home cards');
        });
      }
    }
  }

  for (final scale in [1.0, 1.6]) {
    testWidgets('task, list and document cards are equal (text x$scale)', (tester) async {
      await pump(tester, {'mode': 'everyday'}, textScale: scale);
      await openTab(tester, 1);
      expectSameHeights(tester, find.byType(TaskTile), 'task cards');

      await openTab(tester, 2);
      expectSameHeights(tester, find.descendant(of: find.byType(ListView), matching: find.byType(SoftCard)), 'list cards');

      await openTab(tester, 4);
      await tester.tap(find.text('Documents').first);
      await tester.pumpAndSettle();
      expectSameHeights(tester, find.descendant(of: find.byType(ListView), matching: find.byType(SoftCard)), 'document cards');
    });
  }

  testWidgets('onboarding mode cards are equal', (tester) async {
    await pump(tester, {'onboarded': false, 'language': 'de'});
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expectSameHeights(tester, byTypeName('_ModeCard'), 'mode cards');
  });

  test('every currency has a realistic, valid example amount', () {
    setMoneyLanguage('en');
    for (final c in Currency.all) {
      final text = exampleAmount(c);
      expect(parseAmount(text, c), c.exampleMinor, reason: '${c.code}: "$text"');
      expect(c.exampleMinor, greaterThan(0), reason: c.code);
    }
    expect(exampleAmount(Currency.eur), '12.50');
    // A small purchase in rupees or yen is thousands, not "12.50".
    final pkr = parseAmount(exampleAmount(Currency.fromCode('PKR')), Currency.fromCode('PKR'))! ~/ 100;
    expect(pkr, inInclusiveRange(1000, 20000));
    expect(parseAmount(exampleAmount(Currency.fromCode('JPY')), Currency.fromCode('JPY')), inInclusiveRange(500, 10000));
  });
}
