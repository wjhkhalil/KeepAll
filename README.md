# LifeKeeper

A simple personal life organizer: tasks and reminders, shopping lists and
receipts in one app. Everything stays on the device. There is no login, no
server, no ads and no tracking.

## Run it

```bash
flutter pub get
flutter run            # on a connected Android/iOS device or emulator
flutter test           # unit + widget tests
flutter analyze
```

Reminders need Android, iOS or macOS. On Linux desktop and web the app works
but reminders are skipped.

## Design

LifeKeeper is designed to feel like a calm, friendly planner rather than a
productivity tool. It combines two styles, "Soft Pastel Planner" and
"Modern Soft Nature".

- **Font:** Nunito, bundled in `assets/fonts` (OFL licence) so it works offline.
- **Colours:** about 70% warm neutral (cream `#FAF8F2` background, white cards,
  charcoal `#303633` text), 20% soft pastels (sage, lavender, peach, butter,
  powder blue, clay) and 10% stronger accents. Each task category has its own
  pastel, but an icon and a label always carry the meaning too.
- **Shapes:** cards with 20–24 px corners, very soft shadows, rounded icons and
  a floating pill-shaped tab bar.
- **Dark mode:** muted versions of the same palette.
- **High contrast:** a separate treatment with pure black and white and strong
  outlines, and no pastels.
- **Simple mode:** the same look with less decoration. It has bigger cards
  with a clear "View" button, no illustrations, 64×56 px targets and a
  72 px add button.
- **Animations:** small and only where they help. A tick bounces when a task
  is done, new list items slide in, a finished list gets a little celebration,
  and cards shrink slightly when pressed. All animations are skipped when the
  phone's "reduce motion" setting is on.

All colours are defined in `lib/ui/design.dart` (`AppColors`) and the theme is
in `lib/ui/theme.dart`.

## Features

| Screen | Features |
|---|---|
| **Home** | Greeting, summary cards that change with the chosen mode, today's tasks |
| **Tasks** | Categories (homework, exam, home, appointment, medicine, document, subscription, bill), date + optional time, reminders, repeat (daily/weekly/monthly/yearly), swipe right = done, swipe left = delete, undo |
| **Lists** | Multiple shopping lists, quick add, tick off, quantities, clear ticked, **share as text** (WhatsApp, SMS, email), undo |
| **Receipts** | Photo, amount, currency, category, warranty date, search, per-currency monthly totals ("Spending" in Student mode) |
| **Documents** | Passport, ID, driving licence, insurance, car, health card, contracts... with number, photo, expiry date and a reminder 7–90 days before expiry |
| **More** | Language, mode, name, currency, theme, larger text, high contrast, confirm-before-delete, emergency contact, **backup & restore** |

**Modes** (chosen at first launch, changeable in More):
- **Student**: homework, exam countdown, shopping, spending
- **Everyday**: receipts, documents, home tasks, subscriptions, bills (5 tabs)
- **Simple**: only 3 tabs (Home, Tasks, More), bigger text and buttons, high
  contrast, confirm before deleting, medicine/appointment/documents cards,
  one-tap emergency call

**Languages**: English, Deutsch, Français, Español, Italiano, Nederlands and
Polski. By default the app follows the phone's language, and you can pick one in
More or on the first set-up screen. Dates and amounts follow the language:
`27/09/2026` and `€1,234.50` in English, `27.09.2026` and `1.234,50 €` in
German, `27-09-2026` and `€ 1.234,50` in Dutch. Weeks always start on Monday
and the clock is always 24-hour. The translations are machine-made, so have
a native speaker review them before release.

**Currencies**: every currency in use in the world today, about 150 of them
from Unicode CLDR, with correct symbols and decimals (¥1,500, KWD 1.250,
€12.50). Search by code, name or country in any app language, e.g. "yen",
"JPY", "Japan" or "Japon". The European currencies and the US dollar are
listed first, and during setup the app suggests the currency of the phone's
region. Amounts are stored as whole minor units (cents, fils…) and different
currencies are never added together. To refresh the list, run
`pip install babel && python3 tool/generate_currencies.py`.

**Reminders**: They are rescheduled on every app start and after a language
change or restore, and Android restores them after a reboot. Tapping a
reminder opens the task or document. Task reminders have **Snooze 10 min** and
**Done** buttons. Monthly repeats keep their day, so the 31st goes to
28 Feb, then back to 31 Mar.

**Backup**: More → Create backup saves one `.zip` file with all data, settings
and photos. You can save it to Files, Google Drive or iCloud, or send it to
yourself. More → Restore from backup shows what the file contains and asks
before replacing anything.

## Project layout

```
lib/
  main.dart                 start-up: notifications, settings, data
  app.dart                  MaterialApp, theme, locale, text scaling
  core/                     money (cents, parsing) and date helpers
  data/                     models + JSON file storage
  services/                 reminders (flutter_local_notifications), backup (.zip)
  state/                    AppData (all user data), Settings, task grouping
  ui/                       screens: home, tasks, lists, receipts, documents, more, onboarding
  l10n/app_*.arb            ALL user-facing text, one file per language
```

## Adding a language

1. Copy `lib/l10n/app_en.arb` to e.g. `app_pt.arb`, set `"@@locale": "pt"` and translate the values.
2. Add the code to `supportedLanguages` in `lib/state/settings.dart`, and add its
   region to `_regions` in `lib/app.dart` and its name to `languageName` in `lib/ui/labels.dart`.
3. Optionally add its date separator (`lib/core/dates.dart`) and number style (`lib/core/money.dart`).

## Not included

- **Home-screen widgets**: these need native Android (Kotlin) and iOS (Swift
  widget extension) code, which should be built and tested on real devices.
- **Live shared lists**: real-time sharing between phones needs a server.
  Lists can be shared as text instead.

## Before publishing

The app ID is `com.lifekeep.app` (Android `build.gradle.kts`, iOS/macOS bundle
identifier, Linux `APPLICATION_ID`). Never change it after the first Play upload.
