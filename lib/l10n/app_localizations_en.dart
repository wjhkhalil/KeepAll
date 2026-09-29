// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KeepAll';

  @override
  String get navHome => 'Home';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navLists => 'Lists';

  @override
  String get navReceipts => 'Receipts';

  @override
  String get navMore => 'More';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get rename => 'Rename';

  @override
  String get close => 'Close';

  @override
  String get all => 'All';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeToday => 'Today';

  @override
  String homeTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things due',
      one: '1 thing due',
      zero: 'Nothing due',
    );
    return '$_temp0';
  }

  @override
  String get homeShopping => 'Shopping';

  @override
  String homeShoppingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'Nothing to buy',
    );
    return '$_temp0';
  }

  @override
  String get homeReceipts => 'Receipts';

  @override
  String homeReceiptsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved',
      one: '1 saved',
      zero: 'None saved',
    );
    return '$_temp0';
  }

  @override
  String get homeSpending => 'Spending';

  @override
  String get homeSpendingNone => 'Nothing this month';

  @override
  String get homeHomeTasks => 'Home tasks';

  @override
  String homeDueThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count due this week',
      one: '1 due this week',
      zero: 'Nothing this week',
    );
    return '$_temp0';
  }

  @override
  String get homeSubscriptions => 'Subscriptions';

  @override
  String homeActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      zero: 'None added',
    );
    return '$_temp0';
  }

  @override
  String get homeBills => 'Bills & documents';

  @override
  String get homeHomework => 'Homework';

  @override
  String homeOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count to do',
      zero: 'All done',
    );
    return '$_temp0';
  }

  @override
  String get homeNextExam => 'Next exam';

  @override
  String get homeNoExam => 'No exams planned';

  @override
  String examCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String get homeMedicine => 'Medicine';

  @override
  String get homeAppointments => 'Appointments';

  @override
  String homeNext(String when) {
    return 'Next: $when';
  }

  @override
  String get homeNothingPlanned => 'Nothing planned';

  @override
  String get homeDueToday => 'Due today';

  @override
  String get homeAllDone => 'All done for today';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeEmergency => 'Emergency contact';

  @override
  String homeCall(String name) {
    return 'Call $name';
  }

  @override
  String get homeEmergencyNotSet => 'Add an emergency contact in More';

  @override
  String get callFailed => 'Couldn\'t start a call on this device.';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get tasksEmptyTitle => 'Nothing here yet';

  @override
  String get tasksEmptyBody => 'Your list is waiting for its first task.';

  @override
  String get tasksEmptyFiltered => 'Nothing in this category.';

  @override
  String get sectionOverdue => 'Overdue';

  @override
  String get sectionToday => 'Today';

  @override
  String get sectionTomorrow => 'Tomorrow';

  @override
  String get sectionThisWeek => 'This week';

  @override
  String get sectionLater => 'Later';

  @override
  String get sectionNoDate => 'No date';

  @override
  String sectionCompleted(int count) {
    return 'Completed ($count)';
  }

  @override
  String get taskNew => 'New task';

  @override
  String get taskEdit => 'Edit task';

  @override
  String get taskTitleLabel => 'What do you need to do?';

  @override
  String get taskTitleRequired => 'Please enter a title';

  @override
  String get taskNotesLabel => 'Notes (optional)';

  @override
  String get taskCategoryLabel => 'Type';

  @override
  String get taskDateLabel => 'Date';

  @override
  String get taskNoDate => 'No date';

  @override
  String get taskTimeLabel => 'Time';

  @override
  String get taskAllDay => 'All day';

  @override
  String get taskRemind => 'Remind me';

  @override
  String get taskRemindAllDayHint =>
      'You\'ll get a reminder at 09:00 on the day.';

  @override
  String get taskRemindNeedsDate => 'Pick a date to get a reminder.';

  @override
  String get taskRepeatLabel => 'Repeat';

  @override
  String get taskClearDate => 'Remove date';

  @override
  String get taskClearTime => 'Remove time';

  @override
  String get taskCompleted => 'Task completed';

  @override
  String taskRescheduled(String date) {
    return 'Done. Next time: $date';
  }

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get taskMarkDone => 'Mark as done';

  @override
  String get taskMarkNotDone => 'Mark as not done';

  @override
  String get taskOverdue => 'Overdue';

  @override
  String get taskRepeats => 'Repeats';

  @override
  String get taskSnoozed => 'Snoozed for 10 minutes';

  @override
  String get taskNotFound => 'This task no longer exists.';

  @override
  String get confirmDeleteTitle => 'Delete?';

  @override
  String confirmDeleteItem(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get reminderPermissionDenied =>
      'Notifications are off, so reminders won\'t appear. You can allow them in your phone\'s settings.';

  @override
  String get catGeneral => 'General';

  @override
  String get catStudy => 'Homework';

  @override
  String get catExam => 'Exam';

  @override
  String get catHome => 'Home';

  @override
  String get catAppointment => 'Appointment';

  @override
  String get catMedicine => 'Medicine';

  @override
  String get catDocument => 'Document';

  @override
  String get catSubscription => 'Subscription';

  @override
  String get catBill => 'Bill';

  @override
  String get repeatNone => 'Does not repeat';

  @override
  String get repeatDaily => 'Every day';

  @override
  String get repeatWeekly => 'Every week';

  @override
  String get repeatMonthly => 'Every month';

  @override
  String get repeatYearly => 'Every year';

  @override
  String get notifChannelName => 'Reminders';

  @override
  String get notifChannelDescription =>
      'Task, medicine and appointment reminders';

  @override
  String get notifSnooze => 'Snooze 10 min';

  @override
  String get notifDone => 'Done';

  @override
  String get listsTitle => 'Shopping lists';

  @override
  String get listsEmptyTitle => 'No lists yet';

  @override
  String get listsEmptyBody =>
      'Create a list for groceries, school supplies or anything else.';

  @override
  String get listNew => 'New list';

  @override
  String get listNameLabel => 'List name';

  @override
  String get listNameRequired => 'Please enter a name';

  @override
  String listItemsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items left',
      one: '1 item left',
      zero: 'All done',
    );
    return '$_temp0';
  }

  @override
  String get listDeleted => 'List deleted';

  @override
  String get listEmptyItems => 'Your list is waiting for its first item.';

  @override
  String get itemAddHint => 'Add an item';

  @override
  String get itemAdd => 'Add item';

  @override
  String get itemEdit => 'Edit item';

  @override
  String get itemNameLabel => 'Item';

  @override
  String get itemQuantityLabel => 'Quantity (optional)';

  @override
  String get itemRemoved => 'Item removed';

  @override
  String get clearChecked => 'Clear ticked items';

  @override
  String get clearedChecked => 'Ticked items cleared';

  @override
  String get listOptions => 'List options';

  @override
  String get receiptsTitle => 'Receipts';

  @override
  String get receiptsEmptyTitle => 'No receipts yet';

  @override
  String get receiptsEmptyBody =>
      'Save receipts to track spending and keep proof of purchase for warranties.';

  @override
  String get receiptNew => 'New receipt';

  @override
  String get receiptEdit => 'Edit receipt';

  @override
  String get receiptMerchantLabel => 'Shop or merchant';

  @override
  String get receiptMerchantRequired => 'Please enter where you bought it';

  @override
  String get receiptAmountLabel => 'Amount';

  @override
  String receiptAmountInvalid(String example) {
    return 'Enter an amount like $example';
  }

  @override
  String get receiptCurrencyLabel => 'Currency';

  @override
  String get receiptDateLabel => 'Date of purchase';

  @override
  String get receiptCategoryLabel => 'Category';

  @override
  String get receiptNoteLabel => 'Note (optional)';

  @override
  String get receiptWarrantyLabel => 'Warranty until';

  @override
  String get receiptNoWarranty => 'No warranty';

  @override
  String receiptPhoto(String merchant) {
    return 'Photo of receipt from $merchant';
  }

  @override
  String get receiptDeleted => 'Receipt deleted';

  @override
  String get receiptThisMonth => 'This month';

  @override
  String get receiptSearchHint => 'Search receipts';

  @override
  String get receiptNoResults => 'No receipts match your search.';

  @override
  String receiptWarrantyUntil(String date) {
    return 'Warranty until $date';
  }

  @override
  String get receiptWarrantyExpired => 'Warranty expired';

  @override
  String get rcGroceries => 'Groceries';

  @override
  String get rcHousehold => 'Household';

  @override
  String get rcElectronics => 'Electronics';

  @override
  String get rcClothing => 'Clothing';

  @override
  String get rcHealth => 'Health';

  @override
  String get rcTransport => 'Transport';

  @override
  String get rcEatingOut => 'Eating out';

  @override
  String get rcSchool => 'School';

  @override
  String get rcOther => 'Other';

  @override
  String get moreTitle => 'More';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsName => 'Your name';

  @override
  String get settingsNameNotSet => 'Not set';

  @override
  String get settingsMode => 'Mode';

  @override
  String get settingsCurrency => 'Default currency';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'Match phone';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsAccessibility => 'Accessibility';

  @override
  String get settingsLargeText => 'Larger text';

  @override
  String get settingsLargeTextDesc => 'Makes all text and buttons bigger.';

  @override
  String get settingsHighContrast => 'High contrast';

  @override
  String get settingsHighContrastDesc =>
      'Stronger colours that are easier to read.';

  @override
  String get settingsConfirmDelete => 'Ask before deleting';

  @override
  String get settingsConfirmDeleteDesc =>
      'Show a confirmation before anything is deleted.';

  @override
  String get settingsSafety => 'Safety';

  @override
  String get settingsEmergency => 'Emergency contact';

  @override
  String get emergencyNameLabel => 'Name';

  @override
  String get emergencyPhoneLabel => 'Phone number';

  @override
  String get settingsAbout => 'About';

  @override
  String get aboutBody =>
      'Everything stays on this device. No account, no ads, no tracking.';

  @override
  String get aboutFormats =>
      'Dates use day-month-year order and weeks start on Monday.';

  @override
  String get modeStudent => 'Student';

  @override
  String get modeStudentDesc =>
      'Homework, exams, school lists and simple spending.';

  @override
  String get modeEveryday => 'Everyday';

  @override
  String get modeEverydayDesc =>
      'Receipts, home tasks, bills, subscriptions and shopping.';

  @override
  String get modeSimple => 'Simple';

  @override
  String get modeSimpleDesc =>
      'Bigger text and buttons, medicine and appointment reminders, emergency contact.';

  @override
  String get onbWelcomeTitle => 'Welcome to KeepAll';

  @override
  String get onbWelcomeBody =>
      'Your everyday things, all in one peaceful place.';

  @override
  String get onbNext => 'Next';

  @override
  String get onbBack => 'Back';

  @override
  String get onbStart => 'Get started';

  @override
  String get onbModeTitle => 'How will you use KeepAll?';

  @override
  String get onbModeBody => 'You can change this any time in More.';

  @override
  String get onbNameTitle => 'What should we call you?';

  @override
  String get onbNameHint => 'Your first name (optional)';

  @override
  String get onbCurrencyTitle => 'Which currency do you use?';

  @override
  String onbStep(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get navSpending => 'Spending';

  @override
  String get spendingTitle => 'Spending';

  @override
  String get photoAdd => 'Add photo';

  @override
  String get photoTake => 'Take photo';

  @override
  String get photoChoose => 'Choose from gallery';

  @override
  String get photoRemove => 'Remove photo';

  @override
  String get photoError => 'Couldn\'t add the photo. Please try again.';

  @override
  String get homeDocuments => 'Documents';

  @override
  String homeDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
      zero: 'None saved',
    );
    return '$_temp0';
  }

  @override
  String homeDocsExpiring(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expiring soon',
      one: '1 expiring soon',
    );
    return '$_temp0';
  }

  @override
  String get docsTitle => 'Documents';

  @override
  String get docsEmptyTitle => 'No documents yet';

  @override
  String get docsEmptyBody =>
      'Keep track of your passport, ID card, insurance and more. KeepAll reminds you before they expire.';

  @override
  String get docNew => 'New document';

  @override
  String get docEdit => 'Edit document';

  @override
  String get docTypeLabel => 'Type';

  @override
  String get docTitleLabel => 'Name';

  @override
  String get docNumberLabel => 'Document number (optional)';

  @override
  String get docExpiryLabel => 'Expires on';

  @override
  String get docNoExpiry => 'No expiry date';

  @override
  String get docExpired => 'Expired';

  @override
  String docExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Expires in $days days',
      one: 'Expires tomorrow',
      zero: 'Expires today',
    );
    return '$_temp0';
  }

  @override
  String docValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String docExpiresOn(String date) {
    return 'Expires on $date';
  }

  @override
  String get docRemindLabel => 'Reminder';

  @override
  String get docRemindNone => 'No reminder';

  @override
  String docRemindBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String get docRemindNeedsDate => 'Add an expiry date to get a reminder.';

  @override
  String docPhoto(String title) {
    return 'Photo of $title';
  }

  @override
  String get docDeleted => 'Document deleted';

  @override
  String get docTypePassport => 'Passport';

  @override
  String get docTypeIdCard => 'ID card';

  @override
  String get docTypeDrivingLicence => 'Driving licence';

  @override
  String get docTypeInsurance => 'Insurance';

  @override
  String get docTypeVehicle => 'Car / vehicle';

  @override
  String get docTypeHealth => 'Health card';

  @override
  String get docTypeContract => 'Contract';

  @override
  String get docTypeWarranty => 'Warranty';

  @override
  String get docTypeOther => 'Other';

  @override
  String get moreOrganise => 'Organise';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'Match phone';

  @override
  String get listShare => 'Share list';

  @override
  String get listCopied => 'List copied to clipboard';

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupCreate => 'Create backup';

  @override
  String get backupCreateDesc => 'Save all your data and photos to a file.';

  @override
  String get backupRestore => 'Restore from backup';

  @override
  String get backupRestoreDesc => 'Replace everything with a backup file.';

  @override
  String get backupCreated => 'Backup saved';

  @override
  String get backupFailed => 'Something went wrong. Please try again.';

  @override
  String get backupInvalid => 'This file isn\'t a KeepAll backup.';

  @override
  String get backupTooNew =>
      'This backup was made with a newer version of KeepAll. Please update the app first.';

  @override
  String get backupRestoreConfirmTitle => 'Restore backup?';

  @override
  String backupContains(int tasks, int lists, int receipts, int documents) {
    return 'Tasks: $tasks\nLists: $lists\nReceipts: $receipts\nDocuments: $documents';
  }

  @override
  String get backupRestoreWarning =>
      'Everything currently in the app will be replaced.';

  @override
  String get backupRestoreAction => 'Restore';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get modeStudentShort => 'School, exams & money';

  @override
  String get modeEverydayShort => 'Home & everyday life';

  @override
  String get modeSimpleShort => 'Bigger & easier';

  @override
  String get homeYourDay => 'Your day';

  @override
  String homeYourDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things to take care of',
      one: '1 thing to take care of',
      zero: 'Nothing to take care of',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'View';

  @override
  String receiptMonthSpending(String month) {
    return '$month spending';
  }

  @override
  String receiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receipts',
      one: '1 receipt',
      zero: 'No receipts',
    );
    return '$_temp0';
  }

  @override
  String get docSoon => 'Expires soon';

  @override
  String get tasksAllDoneBody => 'Enjoy the rest of your day.';

  @override
  String get settingsPalette => 'Color theme';

  @override
  String get paletteDeepOcean => 'Deep Ocean';

  @override
  String get paletteMatchaHoney => 'Matcha & Honey';

  @override
  String get paletteSunsetPop => 'Sunset Pop';

  @override
  String get paletteMidnightCandy => 'Midnight Candy';

  @override
  String get paletteSoftPastel => 'Soft Pastel';

  @override
  String get paletteAlwaysDark => 'Always dark';

  @override
  String get paletteCreamCocoa => 'Cream & Cocoa';

  @override
  String get paletteNordicSnow => 'Nordic Snow';

  @override
  String get paletteSkySunshine => 'Sky & Sunshine';

  @override
  String get paletteLavenderNight => 'Lavender Night';

  @override
  String get paletteLemonCharcoal => 'Lemon & Charcoal';

  @override
  String get currencySearchHint => 'Search currency or country';

  @override
  String get currencyPopular => 'Popular';

  @override
  String get currencyAll => 'All currencies';

  @override
  String get currencyNoResults => 'No currency found';

  @override
  String get currencyMore => 'More currencies';

  @override
  String get receiptDateFuture => 'The purchase date can\'t be in the future.';

  @override
  String get homeUpcomingTasks => 'Upcoming tasks';

  @override
  String get taskPastDateTime => 'The date and time cannot be in the past.';

  @override
  String get reminderOnTimeTitle => 'Allow reminders on time';

  @override
  String get reminderOnTimeBody =>
      'Android may hold reminders back while your phone is asleep. To get them exactly on time, even when KeepAll is closed, turn on “Alarms & reminders” for KeepAll on the next screen.';

  @override
  String get reminderOnTimeAllow => 'Allow';

  @override
  String get reminderOnTimeLater => 'Not now';
}
