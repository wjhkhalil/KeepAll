# LifeKeeper — project handover

This file tells a new AI assistant (or developer) everything needed to keep
working on this app. Read it fully before changing anything. Keep it up to
date when you make significant changes.

---

## 1. What the app is

A **personal life organiser** for Android and iOS (Flutter). Instead of ten
separate apps, one calm app holds:

- **Tasks & reminders** (homework, exams, bills, medicine, appointments, home jobs, subscriptions…)
- **Shopping lists**
- **Receipts / spending**
- **Important documents** with expiry reminders (passport, ID, insurance…)
- **Settings, backup/restore, emergency contact**

Guiding idea (from the owner): *"Don't make an app for Europe — make a useful
app that happens to support European users extremely well."* It must work for
**students, everyday adults and older people** at the same time.

Hard product rules (owner's decisions, do not break):
- **No login, no chat, no payments, no social network, no server/backend.**
  Everything is stored locally on the device.
- Friendly, calm, "cute but mature" look — suitable for a teenager *and* a
  60–70 year old.

### Name
The app is called **"LifeKeeper"** (earlier titles: "MyLife", then "Keepall").
Done everywhere: all 7 ARB files (`appTitle`, welcome text, etc.), Android
label, iOS/macOS display & product names, Linux/Windows window titles and
binary name (`lifekeeper`), web title, Dart package (`lifekeeper` — imports are
`package:lifekeeper/...`), app class `LifeKeeperApp`, app id
`com.lifekeep.app` (owner's chosen app id — `com.lifekeeper.app` was already taken on Google Play; Kotlin package in `com/lifekeep/app`).
The project **folder** is still `Documents/my_life` (harmless).
Compatibility kept on purpose (don't remove): backups are `lifekeeper.json` /
`"app":"LifeKeeper"` but old `keepall.json` (`"KeepAll"`/`"Keepall"`) and
`mylife.json` / `"MyLife"` backups still restore; data file is
`lifekeeper_data.json` and old `keepall_data.json` / `mylife_data.json` files
are read once and then removed. Tests cover all of it.

### App icon
**Done (owner's own design):** a green-roofed house holding coloured feature
cards (tick, cart, receipt, passport, bell) between two leaves, on cream
`#FEFAEA`. Master file: `assets/Icon/lifekeeper_app_icon_512x512_original_background.png`
(512 px; ask the owner for a 1024 px version for sharper iOS/macOS icons).
`python3 tool/generate_icons.py` (needs Pillow) makes **every** icon from it:
Android legacy + adaptive icon (foreground picture 74 of 108 dp so it fits
round masks, background colour in `values/ic_launcher_background.xml`),
Android ≤11 splash logo (`drawable-*/launch_logo.png`), white status-bar
notification icon (`drawable-*/ic_notification.png`, a house with a tick,
drawn by the script) + `raw/keep.xml` so release shrinking keeps it, iOS AppIcon (no
alpha) + LaunchImage, macOS rounded icons, web favicon/icons/maskable,
Windows `.ico`, and the in-app `assets/Icon/app_logo.png`. Re-run it after
replacing the master; don't edit the generated PNGs by hand.
In the app, `AppLogo` (design.dart) shows the logo on the onboarding welcome
step and in More → About; in high contrast it is grey with an outline. The
Linux window icon is set in `linux/runner/my_application.cc` from the bundled
asset.

---

## 2. Working with the owner

- The owner writes informal English (not native). Answer in simple, clear
  English. They often paste long design/feature notes and say "make it like this".
- They want **everything implemented now**, not "later versions" (they
  explicitly asked to pull all v2 ideas into the current version).
- They care a lot about **visual polish and consistency** (e.g. "all boxes must
  be the same size on every screen") and **correctness for real users**
  (e.g. the amount hint "12.50" was wrong for Pakistani rupees → fixed for every currency).
- Always **verify**: run `flutter analyze` and `flutter test`, and test the
  change for *all* cases (all currencies, all languages, all modes, large
  text), not just the example they mention.
- Report honestly what was and wasn't verified (the app has **never been run
  on a real phone** in this project's history — only Linux desktop + tests).
- Another session once added a colour-palette feature without it being
  mentioned here; if you find code you don't recognise, keep it and mention it.

---

## 3. Tech stack & commands

- **Flutter 3.35.2 / Dart 3.9** (stable). Path: `/home/samsoft-pc-23/development/flutter`.
- Dev machine: Ubuntu Linux; devices available: Linux desktop, Chrome. No
  Android emulator was used so far.
- Not a git repository (as of writing).

```bash
flutter pub get
flutter gen-l10n          # regenerate translations (also runs on build)
flutter analyze           # must be "No issues found!"
flutter test              # 108 tests, all must pass
flutter build linux --debug && ./build/linux/x64/debug/bundle/lifekeeper
flutter run               # on a phone/emulator
flutter build appbundle   # Play Store release (.aab)
```

**Release signing:** `android/app/build.gradle.kts` reads
`android/key.properties` (storePassword, keyPassword, keyAlias, storeFile →
the owner's upload `.jks`). Both are git-ignored and must never be committed.
Without key.properties the release build falls back to the debug key (Play
rejects it). Google Play App Signing holds the real app key; a lost upload
key can be reset through Play support.

Dependencies (pubspec): `provider` (state), `intl` + `flutter_localizations`,
`path_provider`, `shared_preferences` (settings), `flutter_local_notifications`
v20 (named-parameter API!) + `timezone` + `flutter_timezone`, `image_picker`,
`uuid`, `url_launcher` (emergency call), `share_plus` v12 (`SharePlus.instance.share(ShareParams(...))`),
`file_picker` v11 (**static** `FilePicker.saveFile/pickFiles`), `archive` v4 (zip backups).

**Gotcha:** never run two `flutter test` processes at once — they block each
other on a lock and look like a hang. Kill stray `flutter_tester` processes if needed.

---

## 4. Architecture & file map

Simple layered structure, `provider` + `ChangeNotifier`, no code generation
except l10n and the currency table.

```
lib/
  main.dart                 start-up: date formatting, settings, notifications, data load
  app.dart                  MaterialApp: theme per palette/mode, locale handling,
                            in-app text scaling, _applyLanguage() (formats + reminder texts)
  core/
    money.dart              Currency class (all world currencies), formatMoney, parseAmount,
                            amountToInput, exampleAmount, currencyForRegion, totalsByCurrency
    currency_data.g.dart    GENERATED (tool/generate_currencies.py) – do not edit by hand
    dates.dart              locale-aware date formats, startOfWeek (Monday), daysBetween, addMonths
  data/
    models.dart             Task, ShoppingList/ShoppingItem, Receipt, Document + enums
    data_store.dart         DataStore interface, FileDataStore (one JSON file), MemoryDataStore (tests)
  services/
    reminder_scheduler.dart ReminderScheduler interface, LocalNotificationScheduler, FakeReminderScheduler
    backup.dart             create/read/restore .zip backups
  state/
    app_data.dart           AppData: ALL user data + CRUD + reminder sync + queries
    settings.dart           Settings (SharedPreferences): mode, palette, language, currency, a11y…
    task_groups.dart        groupTasks(): overdue/today/tomorrow/this week/later/no date
  ui/
    design.dart             AppColors (ThemeExtension), 10 palettes, SoftCard, IconBubble,
                            StatusPill, SectionPill, TinyIllustration, AppLogo, FriendlyEmptyState,
                            AnimatedCheck, BounceOnTrue, SlideIn, Pressable, FloatingPillNav,
                            FixedLinesText
    theme.dart              buildTheme(brightness, highContrast, bigTargets, palette)
    labels.dart             enum → localized label/icon/tint helpers, languageName, currencyName
    widgets.dart            confirmDeleteIfNeeded, showMessage (snackbar+undo), SwipeBackground,
                            FieldButton, showTextFieldsDialog (dialog owns its controllers)
    shell.dart              HomeShell: tabs per mode, floating pill nav, notification-tap routing
    home_screen.dart        dashboard (AppTab enum lives here)
    tasks/                  tasks_screen, task_tile (+ complete/delete-with-undo helpers), task_editor_screen
    lists/                  lists_screen, list_detail_screen
    receipts/               receipts_screen, receipt_editor_screen
    documents/              documents_screen, document_editor_screen
    more_screen.dart        settings grouped in cards; palette sheet; backup actions
    onboarding_screen.dart  4 steps: welcome+language, mode, name, currency
    currency_picker.dart    searchable full-screen currency picker
    photo.dart              pickAndImportPhoto(), PhotoField
    backup_actions.dart     createBackup()/restoreBackup() UI flows
  l10n/app_{en,de,fr,es,it,nl,pl}.arb   ALL user-facing text
assets/fonts/               Nunito 400/600/700/800 (+ OFL.txt licence)
tool/generate_currencies.py currency data generator (needs `pip install babel`, internet for rates)
tool/generate_icons.py      makes all platform app icons + in-app logo from assets/Icon (needs Pillow)
test/                       see §12
```

---

## 5. Data model, storage, backup

- **Storage:** one JSON document `lifekeeper_data.json` (legacy `keepall_data.json` /
  `mylife_data.json` migrated) in the app-support
  directory, written atomically (tmp file + rename), writes serialised.
  Shape: `{version: 1, tasks: [], lists: [], receipts: [], documents: []}`.
  Corrupt individual records are skipped on load, not fatal.
- **Photos** (receipts, documents) are copied into `<support>/receipts/` and
  referenced by **file name only** (survives iOS container moves). Deleted
  items keep their photo until the undo snackbar closes; editors delete
  photos they imported but didn't save.
- **Settings** live in SharedPreferences (keys: `onboarded, mode, name, theme,
  currency, largeText, highContrast, confirmDelete, emergencyName,
  emergencyPhone, language, palette`).
- **Task:** id, notificationId (random int), title, notes, category
  (general/study/exam/home/appointment/medicine/document/subscription/bill),
  dueAt, hasTime, remind, repeat (none/daily/weekly/monthly/yearly),
  anchorDay (day-of-month for monthly/yearly so the 31st doesn't drift),
  done, completedAt, snoozedUntil, createdAt.
  Completing a repeating task **rolls it forward** to the next future
  occurrence instead of marking it done. All-day reminders fire at 09:00.
- **Receipt:** merchant, `amountCents` (= **minor units of its currency**, the
  name is historical), currency code, date, category, note, imageFile, warrantyUntil.
- **Document:** title, type (passport/idCard/drivingLicence/insurance/vehicle/
  health/contract/warranty/other), number, expiresAt, remindDaysBefore
  (0/7/14/30/60/90), notes, imageFile. Reminder at 09:00 N days before expiry.
- **Backup (.zip):** `lifekeeper.json` (marker `{"app":"LifeKeeper","format":1}`; legacy KeepAll/MyLife backups accepted),
  `data.json`, `settings.json`, `images/<name>`. Restore validates the marker
  and version, ignores unsafe image paths, shows counts, asks before
  replacing everything, then reschedules reminders.
- Money is **never** a double; different currencies are **never** summed together.

---

## 6. Screens & features (what the user sees)

**Navigation:** floating, rounded pill tab bar at the bottom (custom
`FloatingPillNav`, items keyed `nav-0`, `nav-1`, …).
- Student / Everyday: **Home · Tasks · Lists · Receipts (Student: "Spending") · More**
- Simple: **Home · Tasks · More** only; Lists/Receipts/Documents open from Home cards or More.
- Documents is never a tab — opened from Home card or More → Organise.
- Back button on a non-Home tab returns to Home first.

**Onboarding (first launch):** app logo, "Welcome to LifeKeeper", tagline
"Your everyday things, all in one peaceful place.", language dropdown,
[Get started] → choose mode (📚 Student / 🏡 Everyday / 🌿 Simple cards with
pastel fill + outline + check when selected) → name (optional) → currency
(popular list + "More currencies" picker; default guessed from phone region).

**Home:** greeting "Good morning, Sara ☀️" (☀️/🌤️/🌙 by time) + weekday + long
date + small ☁️ illustration (not in Simple). "Upcoming tasks" card
(`AppData.upcomingTasks`): the next 3 **open** tasks by **due time**
(overdue first, no-date last — owner asked for timing, not creation order),
each row with round animated check and "Today 13:00"/"Tomorrow"/"Overdue",
plus "See all →". Hidden when there are no open tasks.
Then summary cards (2-column grid, 1 column in Simple or large text):
- Student: Homework, Next exam (countdown), Shopping, Spending (this month per currency)
- Everyday: Shopping, Receipts, Documents (highlight when expiring ≤30 days), Home tasks (due this week), Subscriptions, Bills & documents
- Simple: 🆘 Emergency contact card (big red "Call <name>" button or "Add an emergency contact"), then Medicine, Appointments, Shopping, Documents — each with a big **VIEW** button.

**Tasks:** category filter chips; section **pills** (● OVERDUE red, ● TODAY,
● TOMORROW, ● THIS WEEK, ● LATER, ● NO DATE); task cards with a thin
category-colour strip on the left, animated round check, title, "Category ·
Today 18:00" line, repeat/bell icons, category icon bubble. Swipe right =
done, swipe left = delete; undo snackbar; "Completed (n)" expandable card;
☀️ "All done for today" when nothing open. Editor: title, type chips, date,
time (24h), remind switch (asks notification permission), repeat, notes;
Save in app bar and at the bottom.

**Lists:** cards with pastel basket bubble, "n items left", progress bar;
basket bounces + "All done ✨" when complete. Detail: items in one card
(checkbox, name, quantity pill, edit button, swipe to delete + undo), new
items slide in, completion banner, pill-shaped "Add an item" field that
keeps the keyboard open, menu (rename / clear ticked / delete), **share** as
plain text (☐/✓ lines) via share sheet, fallback copy to clipboard.

**Receipts / Spending:** tinted summary card "September spending · €42.50 ·
2 receipts" (per-currency totals), search, category chips, receipts grouped
by month inside cards: category bubble (+photo badge), merchant, "27/09 ·
Groceries", amount (shrinks to fit). Editor: photo (camera or gallery),
merchant, amount (hint = realistic example for the chosen currency, e.g.
3900 for PKR), currency picker, date, category, warranty date, note.

**Documents:** folder-style cards: type bubble, name, type, and a **status
pill**: green "Valid until …", orange "Expires in N days", red "Expired", grey
"No expiry date". Editor: type (pre-fills name), name, number, expiry date,
reminder (none/7/14/30/60/90 days before), photo, notes. Tapping a document
reminder opens the document.

**More:** grouped cards with pastel icon circles — Organise (Documents; plus
Lists/Receipts in Simple), General (name, mode, default currency, language),
Appearance (theme light/dark/system, **colour theme** palette sheet),
Accessibility (larger text, high contrast, ask before deleting), Safety
(emergency contact), Backup (create / restore), About (logo + text, and a
**Privacy policy** row that opens `privacyPolicyUrl` in more_screen.dart —
the owner's freeprivacypolicy.com page, also needed in the Play Console —
in the phone's browser; manifest has an `https` VIEW query for it).

**Empty states:** small emoji illustration on a pastel circle + friendly text
+ add button: 🌱 tasks, 🧺 lists, 👛 receipts, 📁 documents, 🪙 currency search.

---

## 7. Modes

`UserMode { student, everyday, simple }` chosen at onboarding, changeable in
More. Changing mode resets the accessibility overrides so the new mode's
defaults apply. **Simple mode** = same identity, less decoration, bigger
controls: large text (×1.3 on top of system), high contrast and
confirm-before-delete **on by default** (user can override), 3 tabs, 64×56
minimum targets, 72 px add button, single-column cards with VIEW buttons, no
illustrations, two-line titles. These accessibility requirements are
non-negotiable.

---

## 8. Design system

Original concept (owner-approved): **"Soft Pastel Planner + Modern Soft
Nature"** — cute enough for personality, mature enough for 50–70 year olds.
Rule: **~70% neutral, ~20% soft pastel, ~10% stronger accent.** Never make the
whole app pastel/rainbow.

- **Font:** Nunito (bundled, weights 400/600/700/800). Headings w800.
- **Shapes:** cards radius 22 (`cardRadius`), pill buttons radius 18, dialogs 28,
  very soft shadows, thin borders, rounded Material icons (`*_rounded`).
- **Colours:** always via `context.colors` (`AppColors` ThemeExtension):
  `background, card, primary, onPrimary, text, textMuted, border, lavender,
  peach, sage, butter, blue, clay, danger(+Tint), warning(+Tint), success,
  shadow, category(TaskCategory)`. Never hard-code colours in screens.
- **Palettes** (`ColorPalette`, More → Appearance → Colour theme; added by
  another session): deepOcean, matchaHoney,
  sunsetPop, midnightCandy (always dark), softPastel (the original design:
  cream `#FAF8F2`, sage/lavender/peach/butter/blue, charcoal `#303633`),
  **creamCocoa (the default — owner's choice: brown `#7A4B32` on cream `#F7F0E6`)**, nordicSnow, skySunshine, lavenderNight (always dark),
  lemonCharcoal (always dark). Each derives light/dark/category colours.
  Default palette = Cream & Cocoa (decided by the owner); don't change without asking.
- **Dark mode:** muted versions of the palette. **High contrast:** separate
  treatment that is **strictly black and white** (white on black in dark
  mode): `AppColors.contrast()` sets *every* colour, including `primary`,
  `danger`, `warning` and `success`, to the text or background colour. No
  pastels, no palette colours, no coloured accents (owner checked on a phone
  and rejected the earlier teal/red/green accents). Meaning comes from
  icons, text and outlines only; the "off" switch is an outlined empty track,
  the empty part of progress bars is a 20 % grey, and the palette dots on
  the "Colour theme" row are hidden. `widget_test.dart` enforces this for
  every palette × light/dark.
- **Colour is never the only signal** — always icon + text too.
- **Equal-size rule (owner requirement):** boxes of the same kind must have
  the same height on every screen. Use `maxLines: 1` + ellipsis or
  `FixedLinesText(lines: n)` (reserves n lines). Don't add optional lines that
  make some cards taller; show a placeholder ("No date", status pill) instead.
  `test/equal_sizes_test.dart` enforces this — keep it passing.
- **Animations:** tiny and meaningful only — check bounce (`AnimatedCheck`,
  reports completion after 280 ms), list-complete bounce, new-item slide-in,
  press scale (`Pressable`), gentle page transitions (FadeForwards/Cupertino).
  All respect "reduce motion" (`context.reduceMotion`). No confetti, no
  constant motion.

---

## 9. Languages & formats

- Languages: **en, de, fr, es, it, nl, pl** (`supportedLanguages` in settings.dart).
  Default follows the phone; user can pick in onboarding or More.
  Translations are machine-made — recommend native review before release.
  Address forms: de du, fr vous, es tú, it tu, nl je, pl ty.
- **Every user-facing string goes in the ARB files**, and a new key must be
  added to **all 7** files (English template `app_en.arb` has the `@key`
  metadata/placeholders). Run `flutter gen-l10n`; `l10n.yaml` has
  `nullable-getter: false`; generated files are in `lib/l10n/`.
  Polish plurals need `few{}`/`many{}` forms.
- Material locale uses a region (`en_GB`, `de_DE`, …) so pickers show
  day-first dates, 24 h clock and Monday-first weeks.
- `_applyLanguage()` in app.dart switches global date/money formatting,
  `AppData.l10n` (used for OS reminder text) and notification action labels.
- Dates: `27/09/2026` (en/fr/es/it), `27.09.2026` (de/pl), `27-09-2026` (nl).
- Money: `€1,234.50` (en), `1.234,50 €` (de/es/it), `1 234,50 €` (fr/pl, nbsp),
  `€ 1.234,50` (nl). Input accepts both `12,50` and `12.50` styles.

---

## 10. Currencies

- **All 154 currencies in use today** (ISO 4217 via Unicode CLDR), generated
  into `lib/core/currency_data.g.dart` by `tool/generate_currencies.py`
  (`pip install babel`; fetches exchange rates once from open.er-api.com).
- Each currency: code, English symbol, **decimals** (JPY 0, KWD 3, most 2),
  countries using it, names in all 7 languages, country names in all 7
  languages (for search), and an **example price** ≈ €12.50 converted and
  rounded (EUR 12.50, PKR 3900, JPY 2200, INR 1400, IDR 250000, KWD 4.500).
- `Currency` is a class (not an enum): `Currency.all`, `Currency.popular`
  (EUR GBP CHF SEK NOK DKK PLN CZK USD), `Currency.fromCode()` (unknown →
  EUR), `tryCode()`, `.name(lang)`, `.matches(query, lang)`.
- Use `parseAmount(text, currency)`, `amountToInput(minor, currency)`,
  `formatMoney(minor, currency)`, `exampleAmount(currency)` — never assume 2
  decimals or hard-code "12.50" anywhere.
- Currency picker: search by code, name or country in any language
  ("yen", "JPY", "Japan", "Japon").

---

## 11. Reminders / notifications

- `LocalNotificationScheduler` works on Android, iOS, macOS; on Linux/web it
  silently does nothing. Tests use `FakeReminderScheduler`.
- On every start (and after restore/language change) all pending
  notifications are replaced from stored data (`resyncReminders`).
- **Repeating tasks:** the phone repeats the reminder by itself
  (`ReminderRequest.repeat` → `matchDateTimeComponents`), so daily medicine
  keeps reminding even if nobody ticks the task or opens the app (before,
  one ignored reminder stopped all later ones). `AppData.remindersFor`
  always schedules the next occurrence after now. The phone ignores the start
  date, so it only takes over once the start is ≤1 period away; monthly on
  the 29th–31st (and yearly on 29 Feb) stay single reminders. A snooze of a
  repeating task uses a second id (`Task.snoozeNotificationId`) so the daily
  one survives. "Done" from a reminder uses `completeTask(includeToday: true)`.
- Payloads: `task:<id>` / `doc:<id>`. Task reminders have actions **Snooze 10
  min** and **Done** (open the app, handled in `HomeShell._onReminder`).
  Tapping opens the task/document editor; launch-from-notification handled too.
- Android: exact alarms if permitted, else inexact. On Android 14+ exact
  alarms are **off by default**; inexact reminders were held back while the
  phone slept and only appeared when the app was opened (owner's report).
  So turning on a reminder calls `ensureReminderPermission()` (widgets.dart):
  notification permission, then — if `canRemindOnTime()` is false — a dialog
  that opens the system "Alarms & reminders" setting and resyncs reminders
  once allowed. Some phone brands (Xiaomi, Oppo, Vivo, Samsung) may still
  delay them unless battery optimisation is off for the app. Manifest has
  POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, SCHEDULE_EXACT_ALARM, VIBRATE,
  the plugin's receivers (incl. boot receiver), core library desugaring
  (Java 17) in `android/app/build.gradle.kts`, and a `tel:` DIAL query.
- iOS Info.plist: camera + photo library usage strings, `tel` query scheme.

---

## 12. Tests (108, all passing)

- `core_test.dart` – money (all currencies, decimals, parsing, search, region), dates, models.
- `app_data_test.dart` – tasks/reminders/snooze/repeat/lists/receipts/corrupt data.
- `features_test.dart` – language formats, repeat anchor, documents, backup round-trip & rejection.
- `widget_test.dart` – onboarding, add/complete/delete tasks, lists, receipts,
  documents, modes, language switch, palettes, high contrast is strictly black/white, currency picker, amount hint, overflow at large text.
- `layout_stress_test.dart` – every tab in several modes/palettes/languages with large text and real-looking data; fails on overflow.
- `equal_sizes_test.dart` – measures that same-kind boxes have equal heights (home cards in all modes × en/de/pl × text 1.0/1.6, task/list/document cards, onboarding mode cards) + every currency's example amount.

Test tips: nav items are found by key `nav-<i>`; empty states also have an
add button, so tap `find.text('New list').first`; section pills are UPPERCASE;
global language/money state persists between tests in a file — reset with
`setMoneyLanguage('en')` / `setDateLanguage('en')` in pure unit tests.
To visually check screens without a phone: render to PNG in a temporary test
(load Nunito + MaterialIcons via `FontLoader`, wrap app in `RepaintBoundary`,
`toImage` inside `tester.runAsync`) and view the images; emoji show as boxes
there because the test renderer has no emoji font.

---

## 13. Code conventions & gotchas

- Match existing style: small widgets, doc comments explaining *why*,
  `context.l10n`, `context.colors`, `context.read/watch`.
- FloatingActionButtons use `heroTag: null` (several tabs are alive in an IndexedStack).
- Dialogs with text fields must own their controllers (`showTextFieldsDialog`)
  — disposing right after `showDialog` returns crashes during the close animation.
- Don't use `context.read` in `dispose()`; cache the object in `initState`.
- Theme text styles must include font sizes (`Typography.englishLike2021.merge(...)`)
  because component themes use them directly.
- `buildTheme` must start from `ThemeData(colorScheme: scheme, ...)` (not
  `ThemeData(brightness: ...)` + copyWith): otherwise derived colours like
  `canvasColor` (dropdown menus) keep Flutter's default purple-pink.
- Receipt purchase dates can't be in the future (picker stops at today, save
  is blocked with an error). Warranty dates may be in the future. Task and
  document dates may be in the future.
- Deleting shows an undo snackbar; if `confirmDelete` is on, ask first
  (`confirmDeleteIfNeeded`). Delete + undo must restore position/photos.
- Generated files: `lib/l10n/app_localizations*.dart`, `lib/core/currency_data.g.dart` — regenerate, don't edit.
- Keep `flutter analyze` at zero issues.

---

## 14. Status & open items

Done: everything in §6–§11, 7 languages, all currencies, backup/restore,
documents, sharing lists as text, redesign, palettes, equal-size boxes,
rename to Keepall and later to LifeKeeper, app icon on all platforms.

Open / next:
1. App icon: only a 512 px master exists; a 1024 px version would make iOS/macOS icons sharper.
   No Android 13 "themed" (monochrome) icon yet.
2. **Test on a real Android/iOS device**: reminders (incl. after reboot),
   notification actions, camera, backup save to Files/Drive, restore, emergency call.
3. App id is `com.lifekeep.app` (final — never change after the first Play upload). Play Store only; no App Store release planned.
4. Native-speaker review of translations (e.g. fr/it use the same word for Undo/Cancel; pl "Wydatki – {month}").
5. Not built (by decision/limits): home-screen widgets (need native
   Kotlin/Swift + device testing), live shared lists (needs a server —
   against the no-backend rule).
