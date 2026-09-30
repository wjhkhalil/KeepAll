import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lifekeeper/app.dart';
import 'package:lifekeeper/core/dates.dart';
import 'package:lifekeeper/core/money.dart';
import 'package:lifekeeper/data/data_store.dart';
import 'package:lifekeeper/data/models.dart';
import 'package:lifekeeper/services/reminder_scheduler.dart';
import 'package:lifekeeper/state/app_data.dart';
import 'package:lifekeeper/state/settings.dart';
import 'package:lifekeeper/ui/design.dart';
import 'package:lifekeeper/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<(Settings, AppData)> _setUp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  ReminderScheduler? scheduler,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  late Settings settings;
  late AppData data;
  await tester.runAsync(() async {
    settings = await Settings.load();
    data = AppData(store: MemoryDataStore(), scheduler: scheduler ?? FakeReminderScheduler());
    await data.load();
  });
  await tester.pumpWidget(LifeKeeperApp(settings: settings, data: data));
  await tester.pumpAndSettle();
  return (settings, data);
}

void main() {
  setUpAll(() => initializeDateFormatting(appDateLocale));

  testWidgets('onboarding in Simple mode enables accessibility defaults', (tester) async {
    final (settings, _) = await _setUp(tester);

    expect(find.text('Welcome to LifeKeeper'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simple'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Maria');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Swiss Franc'));
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(settings.onboarded, isTrue);
    expect(settings.mode, UserMode.simple);
    expect(settings.largeText, isTrue);
    expect(settings.confirmDelete, isTrue);
    expect(settings.currency.code, 'CHF');
    expect(find.textContaining('Maria'), findsOneWidget);
    expect(find.text('Medicine'), findsOneWidget);
    expect(find.text('Emergency contact'), findsOneWidget);
  });

  testWidgets('turning on a reminder asks for on-time reminders when the phone blocks them', (tester) async {
    final scheduler = FakeReminderScheduler()..onTimeAllowed = false;
    await _setUp(tester, prefs: {'onboarded': true, 'mode': 'everyday'}, scheduler: scheduler);

    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('New task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remind me'));
    await tester.pumpAndSettle();

    expect(find.text('Allow reminders on time'), findsOneWidget);
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();
    expect(scheduler.onTimeRequests, 1);
    expect(scheduler.onTimeAllowed, isTrue);

    // Already allowed: no second question.
    await tester.tap(find.text('Remind me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remind me'));
    await tester.pumpAndSettle();
    expect(find.text('Allow reminders on time'), findsNothing);
    expect(scheduler.onTimeRequests, 1);
  });

  testWidgets('add a task from the Tasks tab', (tester) async {
    final (_, data) = await _setUp(tester, prefs: {'onboarded': true, 'mode': 'everyday'});

    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();
    expect(find.text('Nothing here yet'), findsOneWidget);

    await tester.tap(find.byTooltip('New task'));
    await tester.pumpAndSettle();
    // Saving with no title shows a validation message.
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();
    expect(find.text('Please enter a title'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Change boiler filter');
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();

    expect(data.tasks.single.title, 'Change boiler filter');
    expect(find.text('Change boiler filter'), findsOneWidget);
    expect(find.text('NO DATE'), findsOneWidget); // section pill
  });

  testWidgets('complete a task with the checkbox and undo', (tester) async {
    final (_, data) = await _setUp(tester, prefs: {'onboarded': true});
    await tester.runAsync(() => data.saveTask(data.newTask(title: 'Buy stamps')));
    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AnimatedCheck));
    await tester.pumpAndSettle();
    expect(data.tasks.single.done, isTrue);
    expect(find.text('Task completed'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(data.tasks.single.done, isFalse);
  });

  testWidgets('shopping list: create list and add items', (tester) async {
    final (_, data) = await _setUp(tester, prefs: {'onboarded': true});

    await tester.tap(find.text('Lists'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New list').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Weekend');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Apples');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();

    expect(data.lists.single.name, 'Weekend');
    expect(data.lists.single.items.single.name, 'Apples');

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(data.lists.single.items.single.checked, isTrue);
  });

  testWidgets('receipt: European amount input is stored as cents', (tester) async {
    final (_, data) = await _setUp(tester, prefs: {'onboarded': true, 'currency': 'EUR'});

    await tester.tap(find.text('Receipts').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('New receipt').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Shop or merchant'), 'Carrefour');
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '1.234,56');
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();

    final r = data.receipts.single;
    expect(r.amountCents, 123456);
    expect(r.currency.code, 'EUR');
    expect(find.text('€1,234.56'), findsWidgets);
  });

  testWidgets('delete asks for confirmation when enabled', (tester) async {
    final (_, data) = await _setUp(tester, prefs: {'onboarded': true, 'confirmDelete': true});
    await tester.runAsync(() => data.saveTask(data.newTask(title: 'Old task', category: TaskCategory.home)));
    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();

    await tester.drag(find.text('Old task'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Delete?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(data.tasks, hasLength(1));

    await tester.drag(find.text('Old task'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(data.tasks, isEmpty);
    expect(find.text('Task deleted'), findsOneWidget);
  });

  testWidgets('Simple mode with very large system text has no layout overflow on a small phone', (tester) async {
    tester.view.physicalSize = const Size(360, 720);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = 1.6; // x1.3 in-app = ~2.1
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final (_, data) = await _setUp(tester, prefs: {
      'onboarded': true,
      'mode': 'simple',
      'name': 'Margaret',
      'emergencyName': 'Daughter',
      'emergencyPhone': '+44 7700 900123',
    });
    await tester.runAsync(() async {
      await data.saveTask(data.newTask(
        title: 'Blood pressure tablet with breakfast',
        category: TaskCategory.medicine,
        dueAt: DateTime.now(),
        remind: true,
        repeat: Repeat.daily,
      ));
      final list = await data.addList('Weekly groceries');
      await data.addItem(list.id, 'Semi-skimmed milk', quantity: '2 litres');
    });
    await tester.pumpAndSettle();

    // Simple mode has three tabs; lists, receipts and documents open from More.
    expect(find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key as ValueKey<String>).value.startsWith('nav-')), findsNWidgets(3));
    for (final tab in ['Tasks', 'More', 'Home']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    for (final page in ['Documents', 'Shopping lists', 'Receipts']) {
      await tester.ensureVisible(find.text(page).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(page).first);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    // Open the editors too.
    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('New task'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Student mode calls receipts "Spending"; Everyday has five tabs', (tester) async {
    await _setUp(tester, prefs: {'onboarded': true, 'mode': 'student'});
    expect(find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key as ValueKey<String>).value.startsWith('nav-')), findsNWidgets(5));
    expect(find.text('Spending'), findsWidgets);
    expect(find.text('Receipts'), findsNothing);
  });

  testWidgets('add a document with an expiry date from More', (tester) async {
    final (_, data) = await _setUp(tester, prefs: {'onboarded': true});
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Documents').first);
    await tester.pumpAndSettle();
    expect(find.text('No documents yet'), findsOneWidget);

    await tester.tap(find.text('New document').first);
    await tester.pumpAndSettle();
    // The type suggests a name.
    expect(find.widgetWithText(TextFormField, 'Passport'), findsOneWidget);
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();

    final doc = data.documents.single;
    expect(doc.title, 'Passport');
    expect(doc.type, DocumentType.passport);
    expect(find.textContaining('No expiry date'), findsOneWidget);
  });

  testWidgets('switching language to German translates the app and its formats', (tester) async {
    final (settings, data) = await _setUp(tester, prefs: {'onboarded': true});
    await tester.runAsync(() => data.saveReceipt(Receipt(
      id: 'r', merchant: 'Aldi', amountCents: 123456, currency: Currency.eur,
      date: DateTime(2026, 9, 27), createdAt: DateTime(2026, 9, 27),
    )));

    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Language'), 200);
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(settings.language, 'de');
    expect(find.text('Aufgaben'), findsOneWidget);
    expect(find.text('Mehr'), findsWidgets); // tab + page title
    expect(data.l10n.localeName, 'de');

    await tester.tap(find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key as ValueKey<String>).value.startsWith('nav-')).at(3));
    await tester.pumpAndSettle();
    expect(find.textContaining('1.234,56'), findsWidgets);
    expect(find.textContaining('27.09'), findsOneWidget);
  });

  testWidgets('picking a colour theme in More repaints the app', (tester) async {
    final (settings, _) = await _setUp(tester, prefs: {'onboarded': true});
    // New users start with Cream & Cocoa.
    expect(settings.palette, ColorPalette.creamCocoa);

    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Color theme'), 200);
    await tester.tap(find.text('Color theme'));
    await tester.pumpAndSettle();
    // Rows are all the same height now, so the list may need a scroll.
    await tester.ensureVisible(find.text('Sky & Sunshine'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sky & Sunshine'));
    await tester.pumpAndSettle();

    expect(settings.palette, ColorPalette.skySunshine);
    final context = tester.element(find.text('Color theme'));
    expect(Theme.of(context).colorScheme.primary, const Color(0xFF1E88E5));
    expect(find.text('Sky & Sunshine'), findsOneWidget); // row subtitle
  });

  testWidgets('every colour theme builds a light and a dark look', (tester) async {
    for (final p in ColorPalette.values) {
      for (final b in Brightness.values) {
        final theme = buildTheme(brightness: b, highContrast: false, bigTargets: false, palette: p);
        expect(theme.extension<AppColors>(), isNotNull, reason: '$p $b');
      }
    }
    expect(buildTheme(brightness: Brightness.light, highContrast: false, bigTargets: false, palette: ColorPalette.lemonCharcoal).brightness,
        Brightness.dark);
  });

  test('high contrast uses only black and white, in every palette', () {
    final allowed = {Colors.black, Colors.white, Colors.transparent};
    for (final p in ColorPalette.values) {
      for (final b in Brightness.values) {
        final theme = buildTheme(brightness: b, highContrast: true, bigTargets: false, palette: p);
        final c = theme.extension<AppColors>()!;
        final colours = <String, Color>{
          'background': c.background,
          'card': c.card,
          'primary': c.primary,
          'onPrimary': c.onPrimary,
          'text': c.text,
          'textMuted': c.textMuted,
          'border': c.border,
          'lavender': c.lavender,
          'peach': c.peach,
          'sage': c.sage,
          'butter': c.butter,
          'blue': c.blue,
          'clay': c.clay,
          'danger': c.danger,
          'dangerTint': c.dangerTint,
          'warning': c.warning,
          'warningTint': c.warningTint,
          'success': c.success,
          'shadow': c.shadow,
          for (final e in c.categories.entries) 'category ${e.key.name}': e.value,
        };
        for (final e in colours.entries) {
          expect(allowed.contains(e.value), isTrue, reason: '$p $b: ${e.key} is ${e.value}');
        }
        expect(c.inks, isEmpty, reason: '$p $b');
        // The Material colours widgets pick up on their own follow suit.
        final scheme = theme.colorScheme;
        for (final e in {
          'primary': scheme.primary,
          'onPrimary': scheme.onPrimary,
          'secondary': scheme.secondary,
          'tertiary': scheme.tertiary,
          'error': scheme.error,
          'onError': scheme.onError,
          'surface': scheme.surface,
          'onSurface': scheme.onSurface,
          'primaryContainer': scheme.primaryContainer,
          'errorContainer': scheme.errorContainer,
          'outline': scheme.outline,
        }.entries) {
          expect(allowed.contains(e.value), isTrue, reason: '$p $b: scheme.${e.key} is ${e.value}');
        }
      }
    }
  });

  testWidgets('Midnight Candy is dark even when the phone is light', (tester) async {
    await _setUp(tester, prefs: {'onboarded': true, 'palette': 'midnightCandy'});
    final context = tester.element(find.text('More').last);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(tester.takeException(), isNull);
  });

  for (final lang in ['de', 'pl', 'fr']) {
    testWidgets('no layout overflow in "$lang" with large text on a small phone', (tester) async {
      tester.view.physicalSize = const Size(360, 720);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _setUp(tester, prefs: {'onboarded': true, 'mode': 'everyday', 'language': lang, 'largeText': true});
      final tabs = find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key as ValueKey<String>).value.startsWith('nav-'));
      expect(tabs, findsNWidgets(5));
      for (var i = 0; i < 5; i++) {
        await tester.tap(tabs.at(i));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('pick any world currency by searching for a country', (tester) async {
    final (settings, _) = await _setUp(tester, prefs: {'onboarded': true});
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Default currency'));
    await tester.pumpAndSettle();
    expect(find.text('Popular'.toUpperCase()), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'japan');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Japanese Yen'));
    await tester.pumpAndSettle();

    expect(settings.currency.code, 'JPY');
    expect(find.textContaining('JPY'), findsOneWidget);
  });

  testWidgets('receipt amount example follows the chosen currency', (tester) async {
    await _setUp(tester, prefs: {'onboarded': true, 'currency': 'PKR'});
    await tester.tap(find.text('Receipts').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('New receipt').first);
    await tester.pumpAndSettle();
    // Rupees: thousands, not "12.50".
    final pkrHint = exampleAmount(Currency.fromCode('PKR'));
    expect(pkrHint, isNot('12.50'));
    expect(find.text(pkrHint), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Shop or merchant'), 'Imtiaz');
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), 'abc');
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();
    expect(find.text('Enter an amount like $pkrHint'), findsOneWidget);
  });

  testWidgets('receipts cannot be saved with a future purchase date', (tester) async {
    final (_, data) = await _setUp(tester, prefs: {'onboarded': true});
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final future = Receipt(
      id: 'f', merchant: 'Shop', amountCents: 500, currency: Currency.eur,
      date: DateTime(tomorrow.year, tomorrow.month, tomorrow.day), createdAt: DateTime.now(),
    );
    await tester.runAsync(() => data.saveReceipt(future));
    await tester.tap(find.text('Receipts').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();
    expect(find.text("The purchase date can't be in the future."), findsOneWidget);
    expect(find.text('Edit receipt'), findsOneWidget); // still in the editor

    // The calendar opens (clamped to today) instead of crashing, and only
    // allows dates up to today.
    await tester.tap(find.text('Date of purchase'));
    await tester.pumpAndSettle();
    final picker = tester.widget<DatePickerDialog>(find.byType(DatePickerDialog));
    final today = DateTime.now();
    expect(picker.lastDate, DateTime(today.year, today.month, today.day));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();
    expect(data.receipts.single.date.isAfter(DateTime.now()), isFalse);
  });

  testWidgets('dropdown menus use the palette colours, never default pink', (tester) async {
    const flutterDefaultPink = Color(0xFFFEF7FF);
    for (final p in ColorPalette.values) {
      for (final b in Brightness.values) {
        final theme = buildTheme(brightness: b, highContrast: false, bigTargets: false, palette: p);
        final colors = theme.extension<AppColors>()!;
        expect(theme.canvasColor, colors.card, reason: '$p $b canvas');
        expect(theme.canvasColor, isNot(flutterDefaultPink));
        expect(theme.colorScheme.primary, colors.primary, reason: '$p $b');
      }
    }

    // And in the real app: open the receipt category dropdown.
    await _setUp(tester, prefs: {'onboarded': true, 'palette': 'matchaHoney'});
    await tester.tap(find.text('Receipts').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('New receipt').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Groceries'));
    await tester.tap(find.text('Groceries'));
    await tester.pumpAndSettle();
    final context = tester.element(find.text('Electronics').last);
    final colors = Theme.of(context).extension<AppColors>()!;
    final menuMaterial = tester.widget<Material>(
      find.ancestor(of: find.text('Electronics').last, matching: find.byType(Material)).first,
    );
    expect(menuMaterial.color ?? Theme.of(context).canvasColor, colors.card);
  });
}
