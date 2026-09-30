// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'LifeKeeper';

  @override
  String get navHome => 'Start';

  @override
  String get navTasks => 'Zadania';

  @override
  String get navLists => 'Listy';

  @override
  String get navReceipts => 'Paragony';

  @override
  String get navMore => 'Więcej';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get undo => 'Cofnij';

  @override
  String get edit => 'Edytuj';

  @override
  String get add => 'Dodaj';

  @override
  String get rename => 'Zmień nazwę';

  @override
  String get close => 'Zamknij';

  @override
  String get all => 'Wszystkie';

  @override
  String get greetingMorning => 'Dzień dobry';

  @override
  String get greetingAfternoon => 'Miłego popołudnia';

  @override
  String get greetingEvening => 'Dobry wieczór';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeToday => 'Dziś';

  @override
  String homeTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spraw do zrobienia',
      many: '$count spraw do zrobienia',
      few: '$count sprawy do zrobienia',
      one: '1 sprawa do zrobienia',
      zero: 'Nic do zrobienia',
    );
    return '$_temp0';
  }

  @override
  String get homeShopping => 'Zakupy';

  @override
  String homeShoppingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produktów',
      many: '$count produktów',
      few: '$count produkty',
      one: '1 produkt',
      zero: 'Nic do kupienia',
    );
    return '$_temp0';
  }

  @override
  String get homeReceipts => 'Paragony';

  @override
  String homeReceiptsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zapisanych',
      many: '$count zapisanych',
      few: '$count zapisane',
      one: '1 zapisany',
      zero: 'Brak zapisanych',
    );
    return '$_temp0';
  }

  @override
  String get homeSpending => 'Wydatki';

  @override
  String get homeSpendingNone => 'Brak wydatków w tym miesiącu';

  @override
  String get homeHomeTasks => 'Prace domowe';

  @override
  String homeDueThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count terminów w tym tygodniu',
      many: '$count terminów w tym tygodniu',
      few: '$count terminy w tym tygodniu',
      one: '1 termin w tym tygodniu',
      zero: 'Nic w tym tygodniu',
    );
    return '$_temp0';
  }

  @override
  String get homeSubscriptions => 'Subskrypcje';

  @override
  String homeActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktywnych',
      many: '$count aktywnych',
      few: '$count aktywne',
      one: '1 aktywna',
      zero: 'Brak dodanych',
    );
    return '$_temp0';
  }

  @override
  String get homeBills => 'Rachunki i dokumenty';

  @override
  String get homeHomework => 'Zadania domowe';

  @override
  String homeOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count do zrobienia',
      zero: 'Wszystko zrobione',
    );
    return '$_temp0';
  }

  @override
  String get homeNextExam => 'Najbliższy egzamin';

  @override
  String get homeNoExam => 'Brak zaplanowanych egzaminów';

  @override
  String examCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Za $days dni',
      many: 'Za $days dni',
      few: 'Za $days dni',
      one: 'Jutro',
      zero: 'Dziś',
    );
    return '$_temp0';
  }

  @override
  String get homeMedicine => 'Leki';

  @override
  String get homeAppointments => 'Wizyty';

  @override
  String homeNext(String when) {
    return 'Następne: $when';
  }

  @override
  String get homeNothingPlanned => 'Nic zaplanowanego';

  @override
  String get homeDueToday => 'Na dziś';

  @override
  String get homeAllDone => 'Wszystko zrobione na dziś';

  @override
  String get homeSeeAll => 'Zobacz wszystko';

  @override
  String get homeEmergency => 'Kontakt alarmowy';

  @override
  String homeCall(String name) {
    return 'Zadzwoń do $name';
  }

  @override
  String get homeEmergencyNotSet => 'Dodaj kontakt alarmowy w sekcji Więcej';

  @override
  String get callFailed => 'Nie udało się zadzwonić z tego urządzenia.';

  @override
  String get tasksTitle => 'Zadania';

  @override
  String get tasksEmptyTitle => 'Jeszcze nic tu nie ma';

  @override
  String get tasksEmptyBody => 'Twoja lista czeka na swoje pierwsze zadanie.';

  @override
  String get tasksEmptyFiltered => 'Nic w tej kategorii.';

  @override
  String get sectionOverdue => 'Zaległe';

  @override
  String get sectionToday => 'Dziś';

  @override
  String get sectionTomorrow => 'Jutro';

  @override
  String get sectionThisWeek => 'W tym tygodniu';

  @override
  String get sectionLater => 'Później';

  @override
  String get sectionNoDate => 'Bez daty';

  @override
  String sectionCompleted(int count) {
    return 'Zakończone ($count)';
  }

  @override
  String get taskNew => 'Nowe zadanie';

  @override
  String get taskEdit => 'Edytuj zadanie';

  @override
  String get taskTitleLabel => 'Co musisz zrobić?';

  @override
  String get taskTitleRequired => 'Wpisz tytuł';

  @override
  String get taskNotesLabel => 'Notatki (opcjonalnie)';

  @override
  String get taskCategoryLabel => 'Typ';

  @override
  String get taskDateLabel => 'Data';

  @override
  String get taskNoDate => 'Bez daty';

  @override
  String get taskTimeLabel => 'Godzina';

  @override
  String get taskAllDay => 'Cały dzień';

  @override
  String get taskRemind => 'Przypomnij mi';

  @override
  String get taskRemindAllDayHint =>
      'Przypomnienie przyjdzie o 09:00 tego dnia.';

  @override
  String get taskRemindNeedsDate => 'Wybierz datę, aby otrzymać przypomnienie.';

  @override
  String get taskRepeatLabel => 'Powtarzanie';

  @override
  String get taskClearDate => 'Usuń datę';

  @override
  String get taskClearTime => 'Usuń godzinę';

  @override
  String get taskCompleted => 'Zadanie zakończone';

  @override
  String taskRescheduled(String date) {
    return 'Zrobione. Następny termin: $date';
  }

  @override
  String get taskDeleted => 'Zadanie usunięte';

  @override
  String get taskMarkDone => 'Oznacz jako zrobione';

  @override
  String get taskMarkNotDone => 'Oznacz jako niezrobione';

  @override
  String get taskOverdue => 'Zaległe';

  @override
  String get taskRepeats => 'Powtarza się';

  @override
  String get taskSnoozed => 'Odłożone na 10 minut';

  @override
  String get taskNotFound => 'To zadanie już nie istnieje.';

  @override
  String get confirmDeleteTitle => 'Usunąć?';

  @override
  String confirmDeleteItem(String name) {
    return 'Usunąć „$name”?';
  }

  @override
  String get reminderPermissionDenied =>
      'Powiadomienia są wyłączone, więc przypomnienia się nie pojawią. Możesz je włączyć w ustawieniach telefonu.';

  @override
  String get catGeneral => 'Ogólne';

  @override
  String get catStudy => 'Zadania domowe';

  @override
  String get catExam => 'Egzamin';

  @override
  String get catHome => 'Dom';

  @override
  String get catAppointment => 'Wizyta';

  @override
  String get catMedicine => 'Leki';

  @override
  String get catDocument => 'Dokument';

  @override
  String get catSubscription => 'Subskrypcja';

  @override
  String get catBill => 'Rachunek';

  @override
  String get repeatNone => 'Nie powtarza się';

  @override
  String get repeatDaily => 'Codziennie';

  @override
  String get repeatWeekly => 'Co tydzień';

  @override
  String get repeatMonthly => 'Co miesiąc';

  @override
  String get repeatYearly => 'Co rok';

  @override
  String get notifChannelName => 'Przypomnienia';

  @override
  String get notifChannelDescription =>
      'Przypomnienia o zadaniach, lekach i wizytach';

  @override
  String get notifSnooze => 'Odłóż 10 min';

  @override
  String get notifDone => 'Zrobione';

  @override
  String get listsTitle => 'Listy zakupów';

  @override
  String get listsEmptyTitle => 'Brak list';

  @override
  String get listsEmptyBody =>
      'Utwórz listę na zakupy, przybory szkolne lub coś innego.';

  @override
  String get listNew => 'Nowa lista';

  @override
  String get listNameLabel => 'Nazwa listy';

  @override
  String get listNameRequired => 'Wpisz nazwę';

  @override
  String listItemsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produktów do kupienia',
      many: '$count produktów do kupienia',
      few: '$count produkty do kupienia',
      one: '1 produkt do kupienia',
      zero: 'Wszystko kupione',
    );
    return '$_temp0';
  }

  @override
  String get listDeleted => 'Lista usunięta';

  @override
  String get listEmptyItems => 'Twoja lista czeka na swój pierwszy produkt.';

  @override
  String get itemAddHint => 'Dodaj produkt';

  @override
  String get itemAdd => 'Dodaj produkt';

  @override
  String get itemEdit => 'Edytuj produkt';

  @override
  String get itemNameLabel => 'Produkt';

  @override
  String get itemQuantityLabel => 'Ilość (opcjonalnie)';

  @override
  String get itemRemoved => 'Produkt usunięty';

  @override
  String get clearChecked => 'Wyczyść zaznaczone';

  @override
  String get clearedChecked => 'Zaznaczone produkty usunięte';

  @override
  String get listOptions => 'Opcje listy';

  @override
  String get receiptsTitle => 'Paragony';

  @override
  String get receiptsEmptyTitle => 'Brak paragonów';

  @override
  String get receiptsEmptyBody =>
      'Zapisuj paragony, aby śledzić wydatki i mieć dowód zakupu na wypadek gwarancji.';

  @override
  String get receiptNew => 'Nowy paragon';

  @override
  String get receiptEdit => 'Edytuj paragon';

  @override
  String get receiptMerchantLabel => 'Sklep lub firma';

  @override
  String get receiptMerchantRequired => 'Wpisz, gdzie to kupiłeś';

  @override
  String get receiptAmountLabel => 'Kwota';

  @override
  String receiptAmountInvalid(String example) {
    return 'Wpisz kwotę, na przykład $example';
  }

  @override
  String get receiptCurrencyLabel => 'Waluta';

  @override
  String get receiptDateLabel => 'Data zakupu';

  @override
  String get receiptCategoryLabel => 'Kategoria';

  @override
  String get receiptNoteLabel => 'Notatka (opcjonalnie)';

  @override
  String get receiptWarrantyLabel => 'Gwarancja do';

  @override
  String get receiptNoWarranty => 'Brak gwarancji';

  @override
  String receiptPhoto(String merchant) {
    return 'Zdjęcie paragonu z $merchant';
  }

  @override
  String get receiptDeleted => 'Paragon usunięty';

  @override
  String get receiptThisMonth => 'Ten miesiąc';

  @override
  String get receiptSearchHint => 'Szukaj paragonów';

  @override
  String get receiptNoResults => 'Nie znaleziono paragonów.';

  @override
  String receiptWarrantyUntil(String date) {
    return 'Gwarancja do $date';
  }

  @override
  String get receiptWarrantyExpired => 'Gwarancja wygasła';

  @override
  String get rcGroceries => 'Zakupy spożywcze';

  @override
  String get rcHousehold => 'Dom';

  @override
  String get rcElectronics => 'Elektronika';

  @override
  String get rcClothing => 'Ubrania';

  @override
  String get rcHealth => 'Zdrowie';

  @override
  String get rcTransport => 'Transport';

  @override
  String get rcEatingOut => 'Restauracje';

  @override
  String get rcSchool => 'Szkoła';

  @override
  String get rcOther => 'Inne';

  @override
  String get moreTitle => 'Więcej';

  @override
  String get settingsGeneral => 'Ogólne';

  @override
  String get settingsName => 'Twoje imię';

  @override
  String get settingsNameNotSet => 'Nie ustawiono';

  @override
  String get settingsMode => 'Tryb';

  @override
  String get settingsCurrency => 'Domyślna waluta';

  @override
  String get settingsAppearance => 'Wygląd';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get themeSystem => 'Jak w telefonie';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get settingsAccessibility => 'Dostępność';

  @override
  String get settingsLargeText => 'Większy tekst';

  @override
  String get settingsLargeTextDesc => 'Powiększa cały tekst i przyciski.';

  @override
  String get settingsHighContrast => 'Wysoki kontrast';

  @override
  String get settingsHighContrastDesc =>
      'Mocniejsze kolory, które łatwiej odczytać.';

  @override
  String get settingsConfirmDelete => 'Pytaj przed usunięciem';

  @override
  String get settingsConfirmDeleteDesc =>
      'Pokazuje potwierdzenie, zanim coś zostanie usunięte.';

  @override
  String get settingsSafety => 'Bezpieczeństwo';

  @override
  String get settingsEmergency => 'Kontakt alarmowy';

  @override
  String get emergencyNameLabel => 'Imię';

  @override
  String get emergencyPhoneLabel => 'Numer telefonu';

  @override
  String get settingsAbout => 'O aplikacji';

  @override
  String get aboutBody =>
      'Wszystko zostaje na tym urządzeniu. Bez konta, reklam i śledzenia.';

  @override
  String get aboutFormats =>
      'Daty mają format dzień-miesiąc-rok, a tydzień zaczyna się w poniedziałek.';

  @override
  String get modeStudent => 'Uczeń';

  @override
  String get modeStudentDesc =>
      'Zadania domowe, egzaminy, listy szkolne i proste wydatki.';

  @override
  String get modeEveryday => 'Codzienny';

  @override
  String get modeEverydayDesc =>
      'Paragony, prace domowe, rachunki, subskrypcje i zakupy.';

  @override
  String get modeSimple => 'Prosty';

  @override
  String get modeSimpleDesc =>
      'Większy tekst i przyciski, przypomnienia o lekach i wizytach, kontakt alarmowy.';

  @override
  String get onbWelcomeTitle => 'Witaj w LifeKeeper';

  @override
  String get onbWelcomeBody =>
      'Twoje codzienne sprawy, wszystkie w jednym spokojnym miejscu.';

  @override
  String get onbNext => 'Dalej';

  @override
  String get onbBack => 'Wstecz';

  @override
  String get onbStart => 'Zaczynamy';

  @override
  String get onbModeTitle => 'Jak będziesz korzystać z LifeKeeper?';

  @override
  String get onbModeBody =>
      'Możesz to zmienić w każdej chwili w sekcji Więcej.';

  @override
  String get onbNameTitle => 'Jak mamy się do ciebie zwracać?';

  @override
  String get onbNameHint => 'Twoje imię (opcjonalnie)';

  @override
  String get onbCurrencyTitle => 'Jakiej waluty używasz?';

  @override
  String onbStep(int step, int total) {
    return 'Krok $step z $total';
  }

  @override
  String get navSpending => 'Wydatki';

  @override
  String get spendingTitle => 'Wydatki';

  @override
  String get photoAdd => 'Dodaj zdjęcie';

  @override
  String get photoTake => 'Zrób zdjęcie';

  @override
  String get photoChoose => 'Wybierz z galerii';

  @override
  String get photoRemove => 'Usuń zdjęcie';

  @override
  String get photoError => 'Nie udało się dodać zdjęcia. Spróbuj ponownie.';

  @override
  String get homeDocuments => 'Dokumenty';

  @override
  String homeDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dokumentu',
      many: '$count dokumentów',
      few: '$count dokumenty',
      one: '1 dokument',
      zero: 'Brak',
    );
    return '$_temp0';
  }

  @override
  String homeDocsExpiring(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wkrótce wygasa',
      many: '$count wkrótce wygasa',
      few: '$count wkrótce wygasają',
      one: '1 wkrótce wygasa',
    );
    return '$_temp0';
  }

  @override
  String get docsTitle => 'Dokumenty';

  @override
  String get docsEmptyTitle => 'Brak dokumentów';

  @override
  String get docsEmptyBody =>
      'Miej pod kontrolą paszport, dowód osobisty, ubezpieczenie i inne dokumenty. LifeKeeper przypomni ci, zanim wygasną.';

  @override
  String get docNew => 'Nowy dokument';

  @override
  String get docEdit => 'Edytuj dokument';

  @override
  String get docTypeLabel => 'Typ';

  @override
  String get docTitleLabel => 'Nazwa';

  @override
  String get docNumberLabel => 'Numer dokumentu (opcjonalnie)';

  @override
  String get docExpiryLabel => 'Data ważności';

  @override
  String get docNoExpiry => 'Brak daty ważności';

  @override
  String get docExpired => 'Wygasł';

  @override
  String docExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Wygasa za $days dni',
      many: 'Wygasa za $days dni',
      few: 'Wygasa za $days dni',
      one: 'Wygasa jutro',
      zero: 'Wygasa dziś',
    );
    return '$_temp0';
  }

  @override
  String docValidUntil(String date) {
    return 'Ważny do $date';
  }

  @override
  String docExpiresOn(String date) {
    return 'Wygasa $date';
  }

  @override
  String get docRemindLabel => 'Przypomnienie';

  @override
  String get docRemindNone => 'Brak przypomnienia';

  @override
  String docRemindBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dni wcześniej',
      many: '$days dni wcześniej',
      few: '$days dni wcześniej',
      one: 'Dzień wcześniej',
    );
    return '$_temp0';
  }

  @override
  String get docRemindNeedsDate =>
      'Dodaj datę ważności, aby otrzymać przypomnienie.';

  @override
  String docPhoto(String title) {
    return 'Zdjęcie: $title';
  }

  @override
  String get docDeleted => 'Dokument usunięty';

  @override
  String get docTypePassport => 'Paszport';

  @override
  String get docTypeIdCard => 'Dowód osobisty';

  @override
  String get docTypeDrivingLicence => 'Prawo jazdy';

  @override
  String get docTypeInsurance => 'Ubezpieczenie';

  @override
  String get docTypeVehicle => 'Samochód / pojazd';

  @override
  String get docTypeHealth => 'Karta zdrowia';

  @override
  String get docTypeContract => 'Umowa';

  @override
  String get docTypeWarranty => 'Gwarancja';

  @override
  String get docTypeOther => 'Inne';

  @override
  String get moreOrganise => 'Organizacja';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get languageSystem => 'Jak w telefonie';

  @override
  String get listShare => 'Udostępnij listę';

  @override
  String get listCopied => 'Lista skopiowana do schowka';

  @override
  String get backupTitle => 'Kopia zapasowa';

  @override
  String get backupCreate => 'Utwórz kopię zapasową';

  @override
  String get backupCreateDesc => 'Zapisz wszystkie dane i zdjęcia do pliku.';

  @override
  String get backupRestore => 'Przywróć z kopii zapasowej';

  @override
  String get backupRestoreDesc =>
      'Zamień wszystko na dane z pliku kopii zapasowej.';

  @override
  String get backupCreated => 'Kopia zapasowa zapisana';

  @override
  String get backupFailed => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get backupInvalid => 'Ten plik nie jest kopią zapasową LifeKeeper.';

  @override
  String get backupTooNew =>
      'Ta kopia zapasowa została utworzona w nowszej wersji LifeKeeper. Najpierw zaktualizuj aplikację.';

  @override
  String get backupRestoreConfirmTitle => 'Przywrócić kopię zapasową?';

  @override
  String backupContains(int tasks, int lists, int receipts, int documents) {
    return 'Zadania: $tasks\nListy: $lists\nParagony: $receipts\nDokumenty: $documents';
  }

  @override
  String get backupRestoreWarning =>
      'Wszystko, co jest obecnie w aplikacji, zostanie zastąpione.';

  @override
  String get backupRestoreAction => 'Przywróć';

  @override
  String get backupRestored => 'Kopia zapasowa przywrócona';

  @override
  String get modeStudentShort => 'Szkoła, egzaminy i pieniądze';

  @override
  String get modeEverydayShort => 'Dom i codzienność';

  @override
  String get modeSimpleShort => 'Większy i prostszy';

  @override
  String get homeYourDay => 'Twój dzień';

  @override
  String homeYourDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spraw do załatwienia',
      many: '$count spraw do załatwienia',
      few: '$count sprawy do załatwienia',
      one: '1 sprawa do załatwienia',
      zero: 'Nic do załatwienia',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'Zobacz';

  @override
  String receiptMonthSpending(String month) {
    return 'Wydatki – $month';
  }

  @override
  String receiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paragonów',
      many: '$count paragonów',
      few: '$count paragony',
      one: '1 paragon',
      zero: 'Brak paragonów',
    );
    return '$_temp0';
  }

  @override
  String get docSoon => 'Wkrótce wygasa';

  @override
  String get tasksAllDoneBody => 'Ciesz się resztą dnia.';

  @override
  String get settingsPalette => 'Motyw kolorów';

  @override
  String get paletteDeepOcean => 'Głęboki ocean';

  @override
  String get paletteMatchaHoney => 'Matcha i miód';

  @override
  String get paletteSunsetPop => 'Zachód słońca';

  @override
  String get paletteMidnightCandy => 'Cukierek o północy';

  @override
  String get paletteSoftPastel => 'Delikatny pastel';

  @override
  String get paletteAlwaysDark => 'Zawsze ciemny';

  @override
  String get paletteCreamCocoa => 'Krem i kakao';

  @override
  String get paletteNordicSnow => 'Nordycki śnieg';

  @override
  String get paletteSkySunshine => 'Niebo i słońce';

  @override
  String get paletteLavenderNight => 'Lawendowa noc';

  @override
  String get paletteLemonCharcoal => 'Cytryna i grafit';

  @override
  String get currencySearchHint => 'Szukaj waluty lub kraju';

  @override
  String get currencyPopular => 'Popularne';

  @override
  String get currencyAll => 'Wszystkie waluty';

  @override
  String get currencyNoResults => 'Nie znaleziono waluty';

  @override
  String get currencyMore => 'Więcej walut';

  @override
  String get receiptDateFuture => 'Data zakupu nie może być w przyszłości.';

  @override
  String get homeUpcomingTasks => 'Nadchodzące zadania';

  @override
  String get taskPastDateTime => 'Data i godzina nie mogą być w przeszłości.';

  @override
  String get reminderOnTimeTitle => 'Zezwól na punktualne przypomnienia';

  @override
  String get reminderOnTimeBody =>
      'Android może wstrzymywać przypomnienia, gdy telefon jest uśpiony. Aby dostawać je dokładnie na czas, nawet gdy LifeKeeper jest zamknięta, włącz „Alarmy i przypomnienia” dla LifeKeeper na następnym ekranie.';

  @override
  String get reminderOnTimeAllow => 'Zezwól';

  @override
  String get reminderOnTimeLater => 'Nie teraz';
}
