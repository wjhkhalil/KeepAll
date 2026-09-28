// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Keepall';

  @override
  String get navHome => 'Start';

  @override
  String get navTasks => 'Aufgaben';

  @override
  String get navLists => 'Listen';

  @override
  String get navReceipts => 'Belege';

  @override
  String get navMore => 'Mehr';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get add => 'Hinzufügen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get close => 'Schließen';

  @override
  String get all => 'Alle';

  @override
  String get greetingMorning => 'Guten Morgen';

  @override
  String get greetingAfternoon => 'Guten Tag';

  @override
  String get greetingEvening => 'Guten Abend';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeToday => 'Heute';

  @override
  String homeTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sachen fällig',
      one: '1 Sache fällig',
      zero: 'Nichts fällig',
    );
    return '$_temp0';
  }

  @override
  String get homeShopping => 'Einkauf';

  @override
  String homeShoppingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
      zero: 'Nichts zu kaufen',
    );
    return '$_temp0';
  }

  @override
  String get homeReceipts => 'Belege';

  @override
  String homeReceiptsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespeichert',
      one: '1 gespeichert',
      zero: 'Keine gespeichert',
    );
    return '$_temp0';
  }

  @override
  String get homeSpending => 'Ausgaben';

  @override
  String get homeSpendingNone => 'Nichts diesen Monat';

  @override
  String get homeHomeTasks => 'Haushaltsaufgaben';

  @override
  String homeDueThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diese Woche fällig',
      one: '1 diese Woche fällig',
      zero: 'Nichts diese Woche',
    );
    return '$_temp0';
  }

  @override
  String get homeSubscriptions => 'Abos';

  @override
  String homeActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktiv',
      zero: 'Keine hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String get homeBills => 'Rechnungen & Dokumente';

  @override
  String get homeHomework => 'Hausaufgaben';

  @override
  String homeOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zu tun',
      zero: 'Alles erledigt',
    );
    return '$_temp0';
  }

  @override
  String get homeNextExam => 'Nächste Prüfung';

  @override
  String get homeNoExam => 'Keine Prüfungen geplant';

  @override
  String examCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days Tagen',
      one: 'Morgen',
      zero: 'Heute',
    );
    return '$_temp0';
  }

  @override
  String get homeMedicine => 'Medikamente';

  @override
  String get homeAppointments => 'Termine';

  @override
  String homeNext(String when) {
    return 'Nächstes: $when';
  }

  @override
  String get homeNothingPlanned => 'Nichts geplant';

  @override
  String get homeDueToday => 'Heute fällig';

  @override
  String get homeAllDone => 'Für heute alles erledigt';

  @override
  String get homeSeeAll => 'Alle anzeigen';

  @override
  String get homeEmergency => 'Notfallkontakt';

  @override
  String homeCall(String name) {
    return '$name anrufen';
  }

  @override
  String get homeEmergencyNotSet =>
      'Füge unter Mehr einen Notfallkontakt hinzu';

  @override
  String get callFailed =>
      'Auf diesem Gerät konnte kein Anruf gestartet werden.';

  @override
  String get tasksTitle => 'Aufgaben';

  @override
  String get tasksEmptyTitle => 'Noch nichts hier';

  @override
  String get tasksEmptyBody => 'Deine Liste wartet auf ihre erste Aufgabe.';

  @override
  String get tasksEmptyFiltered => 'Nichts in dieser Kategorie.';

  @override
  String get sectionOverdue => 'Überfällig';

  @override
  String get sectionToday => 'Heute';

  @override
  String get sectionTomorrow => 'Morgen';

  @override
  String get sectionThisWeek => 'Diese Woche';

  @override
  String get sectionLater => 'Später';

  @override
  String get sectionNoDate => 'Kein Datum';

  @override
  String sectionCompleted(int count) {
    return 'Erledigt ($count)';
  }

  @override
  String get taskNew => 'Neue Aufgabe';

  @override
  String get taskEdit => 'Aufgabe bearbeiten';

  @override
  String get taskTitleLabel => 'Was musst du tun?';

  @override
  String get taskTitleRequired => 'Bitte gib einen Titel ein';

  @override
  String get taskNotesLabel => 'Notizen (optional)';

  @override
  String get taskCategoryLabel => 'Art';

  @override
  String get taskDateLabel => 'Datum';

  @override
  String get taskNoDate => 'Kein Datum';

  @override
  String get taskTimeLabel => 'Uhrzeit';

  @override
  String get taskAllDay => 'Ganzer Tag';

  @override
  String get taskRemind => 'Erinnere mich';

  @override
  String get taskRemindAllDayHint =>
      'Du erhältst am jeweiligen Tag um 09:00 eine Erinnerung.';

  @override
  String get taskRemindNeedsDate =>
      'Wähle ein Datum, um eine Erinnerung zu erhalten.';

  @override
  String get taskRepeatLabel => 'Wiederholung';

  @override
  String get taskClearDate => 'Datum entfernen';

  @override
  String get taskClearTime => 'Uhrzeit entfernen';

  @override
  String get taskCompleted => 'Aufgabe erledigt';

  @override
  String taskRescheduled(String date) {
    return 'Erledigt. Nächstes Mal: $date';
  }

  @override
  String get taskDeleted => 'Aufgabe gelöscht';

  @override
  String get taskMarkDone => 'Als erledigt markieren';

  @override
  String get taskMarkNotDone => 'Als nicht erledigt markieren';

  @override
  String get taskOverdue => 'Überfällig';

  @override
  String get taskRepeats => 'Wiederholt sich';

  @override
  String get taskSnoozed => 'Für 10 Minuten aufgeschoben';

  @override
  String get taskNotFound => 'Diese Aufgabe gibt es nicht mehr.';

  @override
  String get confirmDeleteTitle => 'Löschen?';

  @override
  String confirmDeleteItem(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get reminderPermissionDenied =>
      'Benachrichtigungen sind ausgeschaltet, daher werden keine Erinnerungen angezeigt. Du kannst sie in den Einstellungen deines Telefons erlauben.';

  @override
  String get catGeneral => 'Allgemein';

  @override
  String get catStudy => 'Hausaufgaben';

  @override
  String get catExam => 'Prüfung';

  @override
  String get catHome => 'Haushalt';

  @override
  String get catAppointment => 'Termin';

  @override
  String get catMedicine => 'Medikament';

  @override
  String get catDocument => 'Dokument';

  @override
  String get catSubscription => 'Abo';

  @override
  String get catBill => 'Rechnung';

  @override
  String get repeatNone => 'Wiederholt sich nicht';

  @override
  String get repeatDaily => 'Jeden Tag';

  @override
  String get repeatWeekly => 'Jede Woche';

  @override
  String get repeatMonthly => 'Jeden Monat';

  @override
  String get repeatYearly => 'Jedes Jahr';

  @override
  String get notifChannelName => 'Erinnerungen';

  @override
  String get notifChannelDescription =>
      'Erinnerungen an Aufgaben, Medikamente und Termine';

  @override
  String get notifSnooze => '10 Min. aufschieben';

  @override
  String get notifDone => 'Erledigt';

  @override
  String get listsTitle => 'Einkaufslisten';

  @override
  String get listsEmptyTitle => 'Noch keine Listen';

  @override
  String get listsEmptyBody =>
      'Erstelle eine Liste für Lebensmittel, Schulsachen oder anderes.';

  @override
  String get listNew => 'Neue Liste';

  @override
  String get listNameLabel => 'Listenname';

  @override
  String get listNameRequired => 'Bitte gib einen Namen ein';

  @override
  String listItemsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Artikel',
      one: 'Noch 1 Artikel',
      zero: 'Alles erledigt',
    );
    return '$_temp0';
  }

  @override
  String get listDeleted => 'Liste gelöscht';

  @override
  String get listEmptyItems => 'Deine Liste wartet auf ihren ersten Artikel.';

  @override
  String get itemAddHint => 'Artikel hinzufügen';

  @override
  String get itemAdd => 'Artikel hinzufügen';

  @override
  String get itemEdit => 'Artikel bearbeiten';

  @override
  String get itemNameLabel => 'Artikel';

  @override
  String get itemQuantityLabel => 'Menge (optional)';

  @override
  String get itemRemoved => 'Artikel entfernt';

  @override
  String get clearChecked => 'Erledigte entfernen';

  @override
  String get clearedChecked => 'Erledigte Artikel entfernt';

  @override
  String get listOptions => 'Listenoptionen';

  @override
  String get receiptsTitle => 'Belege';

  @override
  String get receiptsEmptyTitle => 'Noch keine Belege';

  @override
  String get receiptsEmptyBody =>
      'Speichere Belege, um deine Ausgaben zu verfolgen und einen Kaufnachweis für Garantien zu haben.';

  @override
  String get receiptNew => 'Neuer Beleg';

  @override
  String get receiptEdit => 'Beleg bearbeiten';

  @override
  String get receiptMerchantLabel => 'Geschäft oder Anbieter';

  @override
  String get receiptMerchantRequired => 'Bitte gib an, wo du es gekauft hast';

  @override
  String get receiptAmountLabel => 'Betrag';

  @override
  String receiptAmountInvalid(String example) {
    return 'Gib einen Betrag wie $example ein';
  }

  @override
  String get receiptCurrencyLabel => 'Währung';

  @override
  String get receiptDateLabel => 'Kaufdatum';

  @override
  String get receiptCategoryLabel => 'Kategorie';

  @override
  String get receiptNoteLabel => 'Notiz (optional)';

  @override
  String get receiptWarrantyLabel => 'Garantie bis';

  @override
  String get receiptNoWarranty => 'Keine Garantie';

  @override
  String receiptPhoto(String merchant) {
    return 'Foto des Belegs von $merchant';
  }

  @override
  String get receiptDeleted => 'Beleg gelöscht';

  @override
  String get receiptThisMonth => 'Diesen Monat';

  @override
  String get receiptSearchHint => 'Belege durchsuchen';

  @override
  String get receiptNoResults => 'Keine Belege gefunden.';

  @override
  String receiptWarrantyUntil(String date) {
    return 'Garantie bis $date';
  }

  @override
  String get receiptWarrantyExpired => 'Garantie abgelaufen';

  @override
  String get rcGroceries => 'Lebensmittel';

  @override
  String get rcHousehold => 'Haushalt';

  @override
  String get rcElectronics => 'Elektronik';

  @override
  String get rcClothing => 'Kleidung';

  @override
  String get rcHealth => 'Gesundheit';

  @override
  String get rcTransport => 'Transport';

  @override
  String get rcEatingOut => 'Auswärts essen';

  @override
  String get rcSchool => 'Schule';

  @override
  String get rcOther => 'Sonstiges';

  @override
  String get moreTitle => 'Mehr';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsName => 'Dein Name';

  @override
  String get settingsNameNotSet => 'Nicht angegeben';

  @override
  String get settingsMode => 'Modus';

  @override
  String get settingsCurrency => 'Standardwährung';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsTheme => 'Design';

  @override
  String get themeSystem => 'Wie Telefon';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsAccessibility => 'Barrierefreiheit';

  @override
  String get settingsLargeText => 'Größere Schrift';

  @override
  String get settingsLargeTextDesc => 'Macht Text und Schaltflächen größer.';

  @override
  String get settingsHighContrast => 'Hoher Kontrast';

  @override
  String get settingsHighContrastDesc =>
      'Kräftigere Farben, die leichter zu lesen sind.';

  @override
  String get settingsConfirmDelete => 'Vor dem Löschen fragen';

  @override
  String get settingsConfirmDeleteDesc =>
      'Zeigt eine Bestätigung, bevor etwas gelöscht wird.';

  @override
  String get settingsSafety => 'Sicherheit';

  @override
  String get settingsEmergency => 'Notfallkontakt';

  @override
  String get emergencyNameLabel => 'Name';

  @override
  String get emergencyPhoneLabel => 'Telefonnummer';

  @override
  String get settingsAbout => 'Über die App';

  @override
  String get aboutBody =>
      'Alles bleibt auf diesem Gerät. Kein Konto, keine Werbung, kein Tracking.';

  @override
  String get aboutFormats =>
      'Daten werden im Format Tag-Monat-Jahr angezeigt, die Woche beginnt am Montag.';

  @override
  String get modeStudent => 'Schüler';

  @override
  String get modeStudentDesc =>
      'Hausaufgaben, Prüfungen, Schullisten und einfache Ausgaben.';

  @override
  String get modeEveryday => 'Alltag';

  @override
  String get modeEverydayDesc =>
      'Belege, Haushaltsaufgaben, Rechnungen, Abos und Einkäufe.';

  @override
  String get modeSimple => 'Einfach';

  @override
  String get modeSimpleDesc =>
      'Größere Schrift und Schaltflächen, Erinnerungen für Medikamente und Termine, Notfallkontakt.';

  @override
  String get onbWelcomeTitle => 'Willkommen bei Keepall';

  @override
  String get onbWelcomeBody => 'Deine Alltagsdinge, alle an einem ruhigen Ort.';

  @override
  String get onbNext => 'Weiter';

  @override
  String get onbBack => 'Zurück';

  @override
  String get onbStart => 'Los geht\'s';

  @override
  String get onbModeTitle => 'Wie möchtest du Keepall nutzen?';

  @override
  String get onbModeBody => 'Du kannst das jederzeit unter Mehr ändern.';

  @override
  String get onbNameTitle => 'Wie sollen wir dich nennen?';

  @override
  String get onbNameHint => 'Dein Vorname (optional)';

  @override
  String get onbCurrencyTitle => 'Welche Währung nutzt du?';

  @override
  String onbStep(int step, int total) {
    return 'Schritt $step von $total';
  }

  @override
  String get navSpending => 'Ausgaben';

  @override
  String get spendingTitle => 'Ausgaben';

  @override
  String get photoAdd => 'Foto hinzufügen';

  @override
  String get photoTake => 'Foto aufnehmen';

  @override
  String get photoChoose => 'Aus Galerie wählen';

  @override
  String get photoRemove => 'Foto entfernen';

  @override
  String get photoError =>
      'Foto konnte nicht hinzugefügt werden. Bitte versuche es erneut.';

  @override
  String get homeDocuments => 'Dokumente';

  @override
  String homeDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dokumente',
      one: '1 Dokument',
      zero: 'Keine gespeichert',
    );
    return '$_temp0';
  }

  @override
  String homeDocsExpiring(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laufen bald ab',
      one: '1 läuft bald ab',
    );
    return '$_temp0';
  }

  @override
  String get docsTitle => 'Dokumente';

  @override
  String get docsEmptyTitle => 'Noch keine Dokumente';

  @override
  String get docsEmptyBody =>
      'Behalte den Überblick über Reisepass, Personalausweis, Versicherung und mehr. Keepall erinnert dich, bevor sie ablaufen.';

  @override
  String get docNew => 'Neues Dokument';

  @override
  String get docEdit => 'Dokument bearbeiten';

  @override
  String get docTypeLabel => 'Art';

  @override
  String get docTitleLabel => 'Name';

  @override
  String get docNumberLabel => 'Dokumentennummer (optional)';

  @override
  String get docExpiryLabel => 'Läuft ab am';

  @override
  String get docNoExpiry => 'Kein Ablaufdatum';

  @override
  String get docExpired => 'Abgelaufen';

  @override
  String docExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Läuft in $days Tagen ab',
      one: 'Läuft morgen ab',
      zero: 'Läuft heute ab',
    );
    return '$_temp0';
  }

  @override
  String docValidUntil(String date) {
    return 'Gültig bis $date';
  }

  @override
  String docExpiresOn(String date) {
    return 'Läuft am $date ab';
  }

  @override
  String get docRemindLabel => 'Erinnerung';

  @override
  String get docRemindNone => 'Keine Erinnerung';

  @override
  String docRemindBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage vorher',
      one: '1 Tag vorher',
    );
    return '$_temp0';
  }

  @override
  String get docRemindNeedsDate =>
      'Füge ein Ablaufdatum hinzu, um eine Erinnerung zu erhalten.';

  @override
  String docPhoto(String title) {
    return 'Foto von $title';
  }

  @override
  String get docDeleted => 'Dokument gelöscht';

  @override
  String get docTypePassport => 'Reisepass';

  @override
  String get docTypeIdCard => 'Personalausweis';

  @override
  String get docTypeDrivingLicence => 'Führerschein';

  @override
  String get docTypeInsurance => 'Versicherung';

  @override
  String get docTypeVehicle => 'Auto / Fahrzeug';

  @override
  String get docTypeHealth => 'Gesundheitskarte';

  @override
  String get docTypeContract => 'Vertrag';

  @override
  String get docTypeWarranty => 'Garantie';

  @override
  String get docTypeOther => 'Sonstiges';

  @override
  String get moreOrganise => 'Organisieren';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get languageSystem => 'Wie Telefon';

  @override
  String get listShare => 'Liste teilen';

  @override
  String get listCopied => 'Liste in die Zwischenablage kopiert';

  @override
  String get backupTitle => 'Sicherung';

  @override
  String get backupCreate => 'Sicherung erstellen';

  @override
  String get backupCreateDesc =>
      'Speichert alle deine Daten und Fotos in einer Datei.';

  @override
  String get backupRestore => 'Aus Sicherung wiederherstellen';

  @override
  String get backupRestoreDesc => 'Ersetzt alles durch eine Sicherungsdatei.';

  @override
  String get backupCreated => 'Sicherung gespeichert';

  @override
  String get backupFailed =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get backupInvalid => 'Diese Datei ist keine Keepall-Sicherung.';

  @override
  String get backupTooNew =>
      'Diese Sicherung wurde mit einer neueren Version von Keepall erstellt. Bitte aktualisiere zuerst die App.';

  @override
  String get backupRestoreConfirmTitle => 'Sicherung wiederherstellen?';

  @override
  String backupContains(int tasks, int lists, int receipts, int documents) {
    return 'Aufgaben: $tasks\nListen: $lists\nBelege: $receipts\nDokumente: $documents';
  }

  @override
  String get backupRestoreWarning =>
      'Alles, was derzeit in der App ist, wird ersetzt.';

  @override
  String get backupRestoreAction => 'Wiederherstellen';

  @override
  String get backupRestored => 'Sicherung wiederhergestellt';

  @override
  String get modeStudentShort => 'Schule, Prüfungen & Geld';

  @override
  String get modeEverydayShort => 'Haushalt & Alltag';

  @override
  String get modeSimpleShort => 'Größer & einfacher';

  @override
  String get homeYourDay => 'Dein Tag';

  @override
  String homeYourDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sachen zu erledigen',
      one: '1 Sache zu erledigen',
      zero: 'Nichts zu erledigen',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'Anzeigen';

  @override
  String receiptMonthSpending(String month) {
    return 'Ausgaben im $month';
  }

  @override
  String receiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Belege',
      one: '1 Beleg',
      zero: 'Keine Belege',
    );
    return '$_temp0';
  }

  @override
  String get docSoon => 'Läuft bald ab';

  @override
  String get tasksAllDoneBody => 'Genieße den Rest des Tages.';

  @override
  String get settingsPalette => 'Farbthema';

  @override
  String get paletteDeepOcean => 'Tiefsee';

  @override
  String get paletteMatchaHoney => 'Matcha & Honig';

  @override
  String get paletteSunsetPop => 'Sonnenuntergang';

  @override
  String get paletteMidnightCandy => 'Mitternachtsbonbon';

  @override
  String get paletteSoftPastel => 'Sanftes Pastell';

  @override
  String get paletteAlwaysDark => 'Immer dunkel';

  @override
  String get paletteCreamCocoa => 'Creme & Kakao';

  @override
  String get paletteNordicSnow => 'Nordischer Schnee';

  @override
  String get paletteSkySunshine => 'Himmel & Sonne';

  @override
  String get paletteLavenderNight => 'Lavendelnacht';

  @override
  String get paletteLemonCharcoal => 'Zitrone & Anthrazit';

  @override
  String get currencySearchHint => 'Währung oder Land suchen';

  @override
  String get currencyPopular => 'Beliebt';

  @override
  String get currencyAll => 'Alle Währungen';

  @override
  String get currencyNoResults => 'Keine Währung gefunden';

  @override
  String get currencyMore => 'Weitere Währungen';

  @override
  String get receiptDateFuture =>
      'Das Kaufdatum darf nicht in der Zukunft liegen.';
}
