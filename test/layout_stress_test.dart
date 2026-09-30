import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lifekeeper/app.dart';
import 'package:lifekeeper/data/data_store.dart';
import 'package:lifekeeper/data/models.dart';
import 'package:lifekeeper/core/money.dart';
import 'package:lifekeeper/services/reminder_scheduler.dart';
import 'package:lifekeeper/state/app_data.dart';
import 'package:lifekeeper/state/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Every tab, in several modes, themes and long-word languages, with large
/// text on a small phone and realistic data. Fails on any layout overflow.
void main() {
  setUpAll(() => initializeDateFormatting());
  for (final cfg in [
    {'mode': 'simple', 'language': 'pl', 'theme': 'dark'},
    {'mode': 'everyday', 'language': 'de', 'highContrast': true},
    {'mode': 'student', 'language': 'fr', 'theme': 'dark', 'highContrast': true},
    {'mode': 'everyday', 'language': 'nl'},
    {'mode': 'student', 'language': 'es', 'palette': 'midnightCandy'},
    {'mode': 'everyday', 'language': 'it', 'theme': 'dark', 'palette': 'sunsetPop'},
    {'mode': 'simple', 'language': 'en', 'palette': 'softPastel'},
    {'mode': 'everyday', 'language': 'de', 'palette': 'lavenderNight'},
    {'mode': 'student', 'language': 'pl', 'theme': 'dark', 'palette': 'nordicSnow'},
  ]) {
    testWidgets('no overflow with real-looking data: $cfg', (tester) async {
      tester.view.physicalSize = const Size(360, 720);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      SharedPreferences.setMockInitialValues({'onboarded': true, 'largeText': true, 'name': 'Małgorzata', ...cfg});
      late Settings settings; late AppData data;
      await tester.runAsync(() async {
        settings = await Settings.load();
        data = AppData(store: MemoryDataStore(), scheduler: FakeReminderScheduler());
        await data.load();
        final now = DateTime.now();
        await data.saveTask(data.newTask(title: 'Zapłacić rachunek za prąd i gaz', category: TaskCategory.bill, dueAt: now.subtract(const Duration(days: 1)), remind: true, repeat: Repeat.monthly));
        await data.saveTask(data.newTask(title: 'Tabletki', category: TaskCategory.medicine, dueAt: DateTime(now.year, now.month, now.day, 20), hasTime: true, remind: true));
        await data.saveTask(data.newTask(title: 'Egzamin z matematyki', category: TaskCategory.exam, dueAt: now.add(const Duration(days: 5))));
        await data.saveDocument(data.newDocument(title: 'Prawo jazdy kategorii B').copyWith(type: DocumentType.drivingLicence, expiresAt: () => now.add(const Duration(days: 10))));
        await data.saveReceipt(Receipt(id: 'r', merchant: 'Biedronka Supermarket', amountCents: 1234567, currency: Currency.pln, date: now, category: ReceiptCategory.groceries, createdAt: now));
        final list = await data.addList('Zakupy na weekend');
        await data.addItem(list.id, 'Mleko');
      });

      await tester.pumpWidget(LifeKeeperApp(settings: settings, data: data));
      await tester.pumpAndSettle();
      final navs = find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key as ValueKey<String>).value.startsWith('nav-'));
      final n = navs.evaluate().length;
      for (var i = 0; i < n; i++) {
        await tester.tap(find.byKey(ValueKey('nav-$i')));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });
  }
}
