// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'LifeKeeper';

  @override
  String get navHome => 'Start';

  @override
  String get navTasks => 'Taken';

  @override
  String get navLists => 'Lijsten';

  @override
  String get navReceipts => 'Bonnetjes';

  @override
  String get navMore => 'Meer';

  @override
  String get save => 'Opslaan';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get edit => 'Bewerken';

  @override
  String get add => 'Toevoegen';

  @override
  String get rename => 'Hernoemen';

  @override
  String get close => 'Sluiten';

  @override
  String get all => 'Alle';

  @override
  String get greetingMorning => 'Goedemorgen';

  @override
  String get greetingAfternoon => 'Goedemiddag';

  @override
  String get greetingEvening => 'Goedenavond';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeToday => 'Vandaag';

  @override
  String homeTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taken',
      one: '1 taak',
      zero: 'Niets te doen',
    );
    return '$_temp0';
  }

  @override
  String get homeShopping => 'Boodschappen';

  @override
  String homeShoppingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'Niets te kopen',
    );
    return '$_temp0';
  }

  @override
  String get homeReceipts => 'Bonnetjes';

  @override
  String homeReceiptsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opgeslagen',
      one: '1 opgeslagen',
      zero: 'Geen opgeslagen',
    );
    return '$_temp0';
  }

  @override
  String get homeSpending => 'Uitgaven';

  @override
  String get homeSpendingNone => 'Niets deze maand';

  @override
  String get homeHomeTasks => 'Huishoudelijke taken';

  @override
  String homeDueThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deze week',
      one: '1 deze week',
      zero: 'Niets deze week',
    );
    return '$_temp0';
  }

  @override
  String get homeSubscriptions => 'Abonnementen';

  @override
  String homeActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actief',
      zero: 'Geen toegevoegd',
    );
    return '$_temp0';
  }

  @override
  String get homeBills => 'Rekeningen & documenten';

  @override
  String get homeHomework => 'Huiswerk';

  @override
  String homeOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count te doen',
      zero: 'Helemaal klaar',
    );
    return '$_temp0';
  }

  @override
  String get homeNextExam => 'Volgend examen';

  @override
  String get homeNoExam => 'Geen examens gepland';

  @override
  String examCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Over $days dagen',
      one: 'Morgen',
      zero: 'Vandaag',
    );
    return '$_temp0';
  }

  @override
  String get homeMedicine => 'Medicijnen';

  @override
  String get homeAppointments => 'Afspraken';

  @override
  String homeNext(String when) {
    return 'Volgende: $when';
  }

  @override
  String get homeNothingPlanned => 'Niets gepland';

  @override
  String get homeDueToday => 'Vandaag te doen';

  @override
  String get homeAllDone => 'Alles klaar voor vandaag';

  @override
  String get homeSeeAll => 'Alles bekijken';

  @override
  String get homeEmergency => 'Noodcontact';

  @override
  String homeCall(String name) {
    return 'Bel $name';
  }

  @override
  String get homeEmergencyNotSet => 'Voeg een noodcontact toe bij Meer';

  @override
  String get callFailed => 'Kon geen gesprek starten op dit apparaat.';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get privacyPolicyDesc => 'Opent in je webbrowser';

  @override
  String get linkFailed =>
      'Kon de link niet openen. Controleer je internetverbinding.';

  @override
  String get tasksTitle => 'Taken';

  @override
  String get tasksEmptyTitle => 'Nog niets hier';

  @override
  String get tasksEmptyBody => 'Je lijst wacht op de eerste taak.';

  @override
  String get tasksEmptyFiltered => 'Niets in deze categorie.';

  @override
  String get sectionOverdue => 'Te laat';

  @override
  String get sectionToday => 'Vandaag';

  @override
  String get sectionTomorrow => 'Morgen';

  @override
  String get sectionThisWeek => 'Deze week';

  @override
  String get sectionLater => 'Later';

  @override
  String get sectionNoDate => 'Geen datum';

  @override
  String sectionCompleted(int count) {
    return 'Afgerond ($count)';
  }

  @override
  String get taskNew => 'Nieuwe taak';

  @override
  String get taskEdit => 'Taak bewerken';

  @override
  String get taskTitleLabel => 'Wat moet je doen?';

  @override
  String get taskTitleRequired => 'Vul een titel in';

  @override
  String get taskNotesLabel => 'Notities (optioneel)';

  @override
  String get taskCategoryLabel => 'Type';

  @override
  String get taskDateLabel => 'Datum';

  @override
  String get taskNoDate => 'Geen datum';

  @override
  String get taskTimeLabel => 'Tijd';

  @override
  String get taskAllDay => 'Hele dag';

  @override
  String get taskRemind => 'Herinner me';

  @override
  String get taskRemindAllDayHint =>
      'Je krijgt een herinnering om 09:00 op die dag.';

  @override
  String get taskRemindNeedsDate =>
      'Kies een datum om een herinnering te krijgen.';

  @override
  String get taskRepeatLabel => 'Herhalen';

  @override
  String get taskClearDate => 'Datum verwijderen';

  @override
  String get taskClearTime => 'Tijd verwijderen';

  @override
  String get taskCompleted => 'Taak afgerond';

  @override
  String taskRescheduled(String date) {
    return 'Klaar. Volgende keer: $date';
  }

  @override
  String get taskDeleted => 'Taak verwijderd';

  @override
  String get taskMarkDone => 'Markeer als klaar';

  @override
  String get taskMarkNotDone => 'Markeer als niet klaar';

  @override
  String get taskOverdue => 'Te laat';

  @override
  String get taskRepeats => 'Herhaalt';

  @override
  String get taskSnoozed => 'Uitgesteld voor 10 minuten';

  @override
  String get taskNotFound => 'Deze taak bestaat niet meer.';

  @override
  String get confirmDeleteTitle => 'Verwijderen?';

  @override
  String confirmDeleteItem(String name) {
    return '\"$name\" verwijderen?';
  }

  @override
  String get reminderPermissionDenied =>
      'Meldingen staan uit, dus herinneringen worden niet getoond. Je kunt dit aanzetten in de instellingen van je telefoon.';

  @override
  String get catGeneral => 'Algemeen';

  @override
  String get catStudy => 'Huiswerk';

  @override
  String get catExam => 'Examen';

  @override
  String get catHome => 'Huis';

  @override
  String get catAppointment => 'Afspraak';

  @override
  String get catMedicine => 'Medicijnen';

  @override
  String get catDocument => 'Document';

  @override
  String get catSubscription => 'Abonnement';

  @override
  String get catBill => 'Rekening';

  @override
  String get repeatNone => 'Herhaalt niet';

  @override
  String get repeatDaily => 'Elke dag';

  @override
  String get repeatWeekly => 'Elke week';

  @override
  String get repeatMonthly => 'Elke maand';

  @override
  String get repeatYearly => 'Elk jaar';

  @override
  String get notifChannelName => 'Herinneringen';

  @override
  String get notifChannelDescription =>
      'Herinneringen voor taken, medicijnen en afspraken';

  @override
  String get notifSnooze => '10 min uitstellen';

  @override
  String get notifDone => 'Klaar';

  @override
  String get listsTitle => 'Boodschappenlijstjes';

  @override
  String get listsEmptyTitle => 'Nog geen lijstjes';

  @override
  String get listsEmptyBody =>
      'Maak een lijst voor boodschappen, schoolspullen of iets anders.';

  @override
  String get listNew => 'Nieuwe lijst';

  @override
  String get listNameLabel => 'Naam van de lijst';

  @override
  String get listNameRequired => 'Vul een naam in';

  @override
  String listItemsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items over',
      one: '1 item over',
      zero: 'Helemaal klaar',
    );
    return '$_temp0';
  }

  @override
  String get listDeleted => 'Lijst verwijderd';

  @override
  String get listEmptyItems => 'Je lijst wacht op het eerste item.';

  @override
  String get itemAddHint => 'Voeg een item toe';

  @override
  String get itemAdd => 'Item toevoegen';

  @override
  String get itemEdit => 'Item bewerken';

  @override
  String get itemNameLabel => 'Item';

  @override
  String get itemQuantityLabel => 'Aantal (optioneel)';

  @override
  String get itemRemoved => 'Item verwijderd';

  @override
  String get clearChecked => 'Aangevinkte items wissen';

  @override
  String get clearedChecked => 'Aangevinkte items gewist';

  @override
  String get listOptions => 'Lijstopties';

  @override
  String get receiptsTitle => 'Bonnetjes';

  @override
  String get receiptsEmptyTitle => 'Nog geen bonnetjes';

  @override
  String get receiptsEmptyBody =>
      'Bewaar bonnetjes om je uitgaven bij te houden en als bewijs van aankoop voor garantie.';

  @override
  String get receiptNew => 'Nieuw bonnetje';

  @override
  String get receiptEdit => 'Bonnetje bewerken';

  @override
  String get receiptMerchantLabel => 'Winkel of verkoper';

  @override
  String get receiptMerchantRequired => 'Vul in waar je het hebt gekocht';

  @override
  String get receiptAmountLabel => 'Bedrag';

  @override
  String receiptAmountInvalid(String example) {
    return 'Vul een bedrag in zoals $example';
  }

  @override
  String get receiptCurrencyLabel => 'Valuta';

  @override
  String get receiptDateLabel => 'Aankoopdatum';

  @override
  String get receiptCategoryLabel => 'Categorie';

  @override
  String get receiptNoteLabel => 'Notitie (optioneel)';

  @override
  String get receiptWarrantyLabel => 'Garantie tot';

  @override
  String get receiptNoWarranty => 'Geen garantie';

  @override
  String receiptPhoto(String merchant) {
    return 'Foto van bonnetje van $merchant';
  }

  @override
  String get receiptDeleted => 'Bonnetje verwijderd';

  @override
  String get receiptThisMonth => 'Deze maand';

  @override
  String get receiptSearchHint => 'Zoek bonnetjes';

  @override
  String get receiptNoResults =>
      'Geen bonnetjes gevonden voor je zoekopdracht.';

  @override
  String receiptWarrantyUntil(String date) {
    return 'Garantie tot $date';
  }

  @override
  String get receiptWarrantyExpired => 'Garantie verlopen';

  @override
  String get rcGroceries => 'Boodschappen';

  @override
  String get rcHousehold => 'Huishouden';

  @override
  String get rcElectronics => 'Elektronica';

  @override
  String get rcClothing => 'Kleding';

  @override
  String get rcHealth => 'Gezondheid';

  @override
  String get rcTransport => 'Vervoer';

  @override
  String get rcEatingOut => 'Uit eten';

  @override
  String get rcSchool => 'School';

  @override
  String get rcOther => 'Overig';

  @override
  String get moreTitle => 'Meer';

  @override
  String get settingsGeneral => 'Algemeen';

  @override
  String get settingsName => 'Je naam';

  @override
  String get settingsNameNotSet => 'Niet ingesteld';

  @override
  String get settingsMode => 'Modus';

  @override
  String get settingsCurrency => 'Standaardvaluta';

  @override
  String get settingsAppearance => 'Weergave';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get themeSystem => 'Zelfde als telefoon';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get settingsAccessibility => 'Toegankelijkheid';

  @override
  String get settingsLargeText => 'Grotere tekst';

  @override
  String get settingsLargeTextDesc => 'Maakt alle tekst en knoppen groter.';

  @override
  String get settingsHighContrast => 'Hoog contrast';

  @override
  String get settingsHighContrastDesc =>
      'Sterkere kleuren die makkelijker te lezen zijn.';

  @override
  String get settingsConfirmDelete => 'Vraag voor het verwijderen';

  @override
  String get settingsConfirmDeleteDesc =>
      'Toon een bevestiging voordat iets wordt verwijderd.';

  @override
  String get settingsSafety => 'Veiligheid';

  @override
  String get settingsEmergency => 'Noodcontact';

  @override
  String get emergencyNameLabel => 'Naam';

  @override
  String get emergencyPhoneLabel => 'Telefoonnummer';

  @override
  String get settingsAbout => 'Over';

  @override
  String get aboutBody =>
      'Alles blijft op dit apparaat. Geen account, geen advertenties, geen tracking.';

  @override
  String get aboutFormats =>
      'Datums gebruiken de volgorde dag-maand-jaar en weken beginnen op maandag.';

  @override
  String get modeStudent => 'Student';

  @override
  String get modeStudentDesc =>
      'Huiswerk, examens, schoollijstjes en eenvoudige uitgaven.';

  @override
  String get modeEveryday => 'Dagelijks';

  @override
  String get modeEverydayDesc =>
      'Bonnetjes, huishoudelijke taken, rekeningen, abonnementen en boodschappen.';

  @override
  String get modeSimple => 'Eenvoudig';

  @override
  String get modeSimpleDesc =>
      'Grotere tekst en knoppen, herinneringen voor medicijnen en afspraken, noodcontact.';

  @override
  String get onbWelcomeTitle => 'Welkom bij LifeKeeper';

  @override
  String get onbWelcomeBody =>
      'Al je dagelijkse dingen, samen op één rustige plek.';

  @override
  String get onbNext => 'Volgende';

  @override
  String get onbBack => 'Terug';

  @override
  String get onbStart => 'Aan de slag';

  @override
  String get onbModeTitle => 'Hoe gebruik je LifeKeeper?';

  @override
  String get onbModeBody => 'Je kunt dit altijd wijzigen bij Meer.';

  @override
  String get onbNameTitle => 'Hoe mogen we je noemen?';

  @override
  String get onbNameHint => 'Je voornaam (optioneel)';

  @override
  String get onbCurrencyTitle => 'Welke valuta gebruik je?';

  @override
  String onbStep(int step, int total) {
    return 'Stap $step van $total';
  }

  @override
  String get navSpending => 'Uitgaven';

  @override
  String get spendingTitle => 'Uitgaven';

  @override
  String get photoAdd => 'Foto toevoegen';

  @override
  String get photoTake => 'Foto maken';

  @override
  String get photoChoose => 'Kies uit galerij';

  @override
  String get photoRemove => 'Foto verwijderen';

  @override
  String get photoError => 'Kon de foto niet toevoegen. Probeer het opnieuw.';

  @override
  String get homeDocuments => 'Documenten';

  @override
  String homeDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documenten',
      one: '1 document',
      zero: 'Geen opgeslagen',
    );
    return '$_temp0';
  }

  @override
  String homeDocsExpiring(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verlopen binnenkort',
      one: '1 verloopt binnenkort',
    );
    return '$_temp0';
  }

  @override
  String get docsTitle => 'Documenten';

  @override
  String get docsEmptyTitle => 'Nog geen documenten';

  @override
  String get docsEmptyBody =>
      'Houd je paspoort, ID-kaart, verzekering en meer bij. LifeKeeper herinnert je voordat ze verlopen.';

  @override
  String get docNew => 'Nieuw document';

  @override
  String get docEdit => 'Document bewerken';

  @override
  String get docTypeLabel => 'Type';

  @override
  String get docTitleLabel => 'Naam';

  @override
  String get docNumberLabel => 'Documentnummer (optioneel)';

  @override
  String get docExpiryLabel => 'Verloopt op';

  @override
  String get docNoExpiry => 'Geen vervaldatum';

  @override
  String get docExpired => 'Verlopen';

  @override
  String docExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Verloopt over $days dagen',
      one: 'Verloopt morgen',
      zero: 'Verloopt vandaag',
    );
    return '$_temp0';
  }

  @override
  String docValidUntil(String date) {
    return 'Geldig tot $date';
  }

  @override
  String docExpiresOn(String date) {
    return 'Verloopt op $date';
  }

  @override
  String get docRemindLabel => 'Herinnering';

  @override
  String get docRemindNone => 'Geen herinnering';

  @override
  String docRemindBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagen ervoor',
      one: '1 dag ervoor',
    );
    return '$_temp0';
  }

  @override
  String get docRemindNeedsDate =>
      'Voeg een vervaldatum toe om een herinnering te krijgen.';

  @override
  String docPhoto(String title) {
    return 'Foto van $title';
  }

  @override
  String get docDeleted => 'Document verwijderd';

  @override
  String get docTypePassport => 'Paspoort';

  @override
  String get docTypeIdCard => 'ID-kaart';

  @override
  String get docTypeDrivingLicence => 'Rijbewijs';

  @override
  String get docTypeInsurance => 'Verzekering';

  @override
  String get docTypeVehicle => 'Auto / voertuig';

  @override
  String get docTypeHealth => 'Zorgpas';

  @override
  String get docTypeContract => 'Contract';

  @override
  String get docTypeWarranty => 'Garantie';

  @override
  String get docTypeOther => 'Overig';

  @override
  String get moreOrganise => 'Organiseren';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get languageSystem => 'Zelfde als telefoon';

  @override
  String get listShare => 'Lijst delen';

  @override
  String get listCopied => 'Lijst gekopieerd naar klembord';

  @override
  String get backupTitle => 'Back-up';

  @override
  String get backupCreate => 'Back-up maken';

  @override
  String get backupCreateDesc =>
      'Bewaar al je gegevens en foto\'s in een bestand.';

  @override
  String get backupRestore => 'Herstellen vanaf back-up';

  @override
  String get backupRestoreDesc => 'Vervang alles met een back-upbestand.';

  @override
  String get backupCreated => 'Back-up opgeslagen';

  @override
  String get backupFailed => 'Er ging iets mis. Probeer het opnieuw.';

  @override
  String get backupInvalid => 'Dit bestand is geen back-up van LifeKeeper.';

  @override
  String get backupTooNew =>
      'Deze back-up is gemaakt met een nieuwere versie van LifeKeeper. Werk de app eerst bij.';

  @override
  String get backupRestoreConfirmTitle => 'Back-up herstellen?';

  @override
  String backupContains(int tasks, int lists, int receipts, int documents) {
    return 'Taken: $tasks\nLijsten: $lists\nBonnetjes: $receipts\nDocumenten: $documents';
  }

  @override
  String get backupRestoreWarning =>
      'Alles wat nu in de app staat, wordt vervangen.';

  @override
  String get backupRestoreAction => 'Herstellen';

  @override
  String get backupRestored => 'Back-up hersteld';

  @override
  String get modeStudentShort => 'School, examens & geld';

  @override
  String get modeEverydayShort => 'Huis & dagelijks leven';

  @override
  String get modeSimpleShort => 'Groter & makkelijker';

  @override
  String get homeYourDay => 'Je dag';

  @override
  String homeYourDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dingen om te regelen',
      one: '1 ding om te regelen',
      zero: 'Niets te regelen',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'Bekijken';

  @override
  String receiptMonthSpending(String month) {
    return 'Uitgaven in $month';
  }

  @override
  String receiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bonnetjes',
      one: '1 bonnetje',
      zero: 'Geen bonnetjes',
    );
    return '$_temp0';
  }

  @override
  String get docSoon => 'Verloopt binnenkort';

  @override
  String get tasksAllDoneBody => 'Geniet van de rest van je dag.';

  @override
  String get settingsPalette => 'Kleurthema';

  @override
  String get paletteDeepOcean => 'Diepe oceaan';

  @override
  String get paletteMatchaHoney => 'Matcha & honing';

  @override
  String get paletteSunsetPop => 'Zonsondergang';

  @override
  String get paletteMidnightCandy => 'Middernachtsnoepje';

  @override
  String get paletteSoftPastel => 'Zacht pastel';

  @override
  String get paletteAlwaysDark => 'Altijd donker';

  @override
  String get paletteCreamCocoa => 'Room & cacao';

  @override
  String get paletteNordicSnow => 'Noordse sneeuw';

  @override
  String get paletteSkySunshine => 'Lucht & zon';

  @override
  String get paletteLavenderNight => 'Lavendelnacht';

  @override
  String get paletteLemonCharcoal => 'Citroen & antraciet';

  @override
  String get currencySearchHint => 'Zoek valuta of land';

  @override
  String get currencyPopular => 'Populair';

  @override
  String get currencyAll => 'Alle valuta';

  @override
  String get currencyNoResults => 'Geen valuta gevonden';

  @override
  String get currencyMore => 'Meer valuta';

  @override
  String get receiptDateFuture =>
      'De aankoopdatum kan niet in de toekomst liggen.';

  @override
  String get homeUpcomingTasks => 'Komende taken';

  @override
  String get taskPastDateTime =>
      'Datum en tijd mogen niet in het verleden liggen.';

  @override
  String get reminderOnTimeTitle => 'Herinneringen op tijd toestaan';

  @override
  String get reminderOnTimeBody =>
      'Android kan herinneringen uitstellen terwijl je telefoon slaapt. Zet op het volgende scherm ‘Wekkers en herinneringen’ aan voor LifeKeeper om ze precies op tijd te krijgen, ook als LifeKeeper gesloten is.';

  @override
  String get reminderOnTimeAllow => 'Toestaan';

  @override
  String get reminderOnTimeLater => 'Niet nu';
}
