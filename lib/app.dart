import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/dates.dart';
import 'core/money.dart';
import 'l10n/app_localizations.dart';
import 'services/reminder_scheduler.dart';
import 'state/app_data.dart';
import 'state/settings.dart';
import 'ui/design.dart';
import 'ui/onboarding_screen.dart';
import 'ui/shell.dart';
import 'ui/theme.dart';

class KeepallApp extends StatelessWidget {
  const KeepallApp({super.key, required this.settings, required this.data});

  final Settings settings;
  final AppData data;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: data),
      ],
      child: Consumer<Settings>(
        builder: (context, s, _) {
          ThemeData theme(Brightness b) =>
              buildTheme(brightness: b, highContrast: s.highContrast, bigTargets: s.bigTargets, palette: s.palette);
          return MaterialApp(
            onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
            debugShowCheckedModeBanner: false,
            theme: theme(Brightness.light),
            darkTheme: theme(Brightness.dark),
            highContrastTheme: buildTheme(
              brightness: Brightness.light,
              highContrast: true,
              bigTargets: s.bigTargets,
              palette: s.palette,
            ),
            highContrastDarkTheme: buildTheme(
              brightness: Brightness.dark,
              highContrast: true,
              bigTargets: s.bigTargets,
              palette: s.palette,
            ),
            themeMode: s.themeMode,
            // null = follow the phone. Regional locales give day-first dates,
            // a 24-hour clock and Monday-first calendars in the pickers
            // (en_GB rather than en_US for English).
            locale: s.language == null ? null : _regionalLocale(s.language!),
            supportedLocales: [for (final code in supportedLanguages) _regionalLocale(code)],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              _applyLanguage(Localizations.localeOf(context).languageCode, data);
              final media = MediaQuery.of(context);
              // Apply the in-app "Larger text" option on top of the system setting.
              final scale = (media.textScaler.scale(1) * s.textScale).clamp(1.0, 3.0);
              // Status/navigation bars follow the active palette even on
              // screens without an app bar.
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: systemOverlayStyleFor(Theme.of(context).extension<AppColors>()!),
                child: MediaQuery(
                  data: media.copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                ),
              );
            },
            home: s.onboarded ? const HomeShell() : const OnboardingScreen(),
          );
        },
      ),
    );
  }
}

const _regions = {'en': 'GB', 'de': 'DE', 'fr': 'FR', 'es': 'ES', 'it': 'IT', 'nl': 'NL', 'pl': 'PL'};

Locale _regionalLocale(String code) => Locale(code, _regions[code]);

String? _appliedLanguage;
AppData? _appliedData;

/// Points date/number formatting and OS reminder texts at [code]. Runs
/// before the screens build, and only does work when the language changes.
void _applyLanguage(String code, AppData data) {
  if (code == _appliedLanguage && identical(data, _appliedData)) return;
  _appliedLanguage = code;
  _appliedData = data;
  setDateLanguage(code);
  setMoneyLanguage(code);
  final l = lookupAppLocalizations(Locale(code));
  data.l10n = l;
  data.scheduler.updateTexts(reminderTextsFor(l));
  // Pending reminders were written in the old language.
  WidgetsBinding.instance.addPostFrameCallback((_) => data.resyncReminders());
}

ReminderTexts reminderTextsFor(AppLocalizations l) => ReminderTexts(
  channelName: l.notifChannelName,
  channelDescription: l.notifChannelDescription,
  snooze: l.notifSnooze,
  done: l.notifDone,
);
