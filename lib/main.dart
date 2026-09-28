import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'data/data_store.dart';
import 'l10n/app_localizations.dart';
import 'services/reminder_scheduler.dart';
import 'state/app_data.dart';
import 'state/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  final settings = await Settings.load();
  final language = settings.effectiveLanguage(WidgetsBinding.instance.platformDispatcher.locale);
  final l = lookupAppLocalizations(Locale(language));
  final scheduler = LocalNotificationScheduler();
  try {
    await scheduler.init(reminderTextsFor(l));
  } catch (e) {
    // Reminders are optional; the rest of the app must still work.
    debugPrint('Notifications unavailable: $e');
  }

  final data = AppData(store: FileDataStore(), scheduler: scheduler, l10n: l);
  await data.load();

  runApp(KeepallApp(settings: settings, data: data));
}
