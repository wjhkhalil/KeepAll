import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nl'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KeepAll'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navLists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get navLists;

  /// No description provided for @navReceipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get navReceipts;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingWithName(String greeting, String name);

  /// No description provided for @homeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeToday;

  /// No description provided for @homeTodayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing due} =1{1 thing due} other{{count} things due}}'**
  String homeTodayCount(int count);

  /// No description provided for @homeShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get homeShopping;

  /// No description provided for @homeShoppingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to buy} =1{1 item} other{{count} items}}'**
  String homeShoppingCount(int count);

  /// No description provided for @homeReceipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get homeReceipts;

  /// No description provided for @homeReceiptsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None saved} =1{1 saved} other{{count} saved}}'**
  String homeReceiptsCount(int count);

  /// No description provided for @homeSpending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get homeSpending;

  /// No description provided for @homeSpendingNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing this month'**
  String get homeSpendingNone;

  /// No description provided for @homeHomeTasks.
  ///
  /// In en, this message translates to:
  /// **'Home tasks'**
  String get homeHomeTasks;

  /// No description provided for @homeDueThisWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing this week} =1{1 due this week} other{{count} due this week}}'**
  String homeDueThisWeek(int count);

  /// No description provided for @homeSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get homeSubscriptions;

  /// No description provided for @homeActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None added} other{{count} active}}'**
  String homeActive(int count);

  /// No description provided for @homeBills.
  ///
  /// In en, this message translates to:
  /// **'Bills & documents'**
  String get homeBills;

  /// No description provided for @homeHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homeHomework;

  /// No description provided for @homeOpen.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All done} other{{count} to do}}'**
  String homeOpen(int count);

  /// No description provided for @homeNextExam.
  ///
  /// In en, this message translates to:
  /// **'Next exam'**
  String get homeNextExam;

  /// No description provided for @homeNoExam.
  ///
  /// In en, this message translates to:
  /// **'No exams planned'**
  String get homeNoExam;

  /// No description provided for @examCountdown.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Today} =1{Tomorrow} other{In {days} days}}'**
  String examCountdown(int days);

  /// No description provided for @homeMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get homeMedicine;

  /// No description provided for @homeAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get homeAppointments;

  /// No description provided for @homeNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {when}'**
  String homeNext(String when);

  /// No description provided for @homeNothingPlanned.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned'**
  String get homeNothingPlanned;

  /// No description provided for @homeDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get homeDueToday;

  /// No description provided for @homeAllDone.
  ///
  /// In en, this message translates to:
  /// **'All done for today'**
  String get homeAllDone;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get homeEmergency;

  /// No description provided for @homeCall.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String homeCall(String name);

  /// No description provided for @homeEmergencyNotSet.
  ///
  /// In en, this message translates to:
  /// **'Add an emergency contact in More'**
  String get homeEmergencyNotSet;

  /// No description provided for @callFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start a call on this device.'**
  String get callFailed;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your list is waiting for its first task.'**
  String get tasksEmptyBody;

  /// No description provided for @tasksEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this category.'**
  String get tasksEmptyFiltered;

  /// No description provided for @sectionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get sectionOverdue;

  /// No description provided for @sectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get sectionToday;

  /// No description provided for @sectionTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get sectionTomorrow;

  /// No description provided for @sectionThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get sectionThisWeek;

  /// No description provided for @sectionLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get sectionLater;

  /// No description provided for @sectionNoDate.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get sectionNoDate;

  /// No description provided for @sectionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed ({count})'**
  String sectionCompleted(int count);

  /// No description provided for @taskNew.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskNew;

  /// No description provided for @taskEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskEdit;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you need to do?'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get taskTitleRequired;

  /// No description provided for @taskNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get taskNotesLabel;

  /// No description provided for @taskCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get taskCategoryLabel;

  /// No description provided for @taskDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get taskDateLabel;

  /// No description provided for @taskNoDate.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get taskNoDate;

  /// No description provided for @taskTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get taskTimeLabel;

  /// No description provided for @taskAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get taskAllDay;

  /// No description provided for @taskRemind.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get taskRemind;

  /// No description provided for @taskRemindAllDayHint.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a reminder at 09:00 on the day.'**
  String get taskRemindAllDayHint;

  /// No description provided for @taskRemindNeedsDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date to get a reminder.'**
  String get taskRemindNeedsDate;

  /// No description provided for @taskRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get taskRepeatLabel;

  /// No description provided for @taskClearDate.
  ///
  /// In en, this message translates to:
  /// **'Remove date'**
  String get taskClearDate;

  /// No description provided for @taskClearTime.
  ///
  /// In en, this message translates to:
  /// **'Remove time'**
  String get taskClearTime;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get taskCompleted;

  /// No description provided for @taskRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Done. Next time: {date}'**
  String taskRescheduled(String date);

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// No description provided for @taskMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get taskMarkDone;

  /// No description provided for @taskMarkNotDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done'**
  String get taskMarkNotDone;

  /// No description provided for @taskOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get taskOverdue;

  /// No description provided for @taskRepeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get taskRepeats;

  /// No description provided for @taskSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed for 10 minutes'**
  String get taskSnoozed;

  /// No description provided for @taskNotFound.
  ///
  /// In en, this message translates to:
  /// **'This task no longer exists.'**
  String get taskNotFound;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String confirmDeleteItem(String name);

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off, so reminders won\'t appear. You can allow them in your phone\'s settings.'**
  String get reminderPermissionDenied;

  /// No description provided for @catGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get catGeneral;

  /// No description provided for @catStudy.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get catStudy;

  /// No description provided for @catExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get catExam;

  /// No description provided for @catHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get catHome;

  /// No description provided for @catAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get catAppointment;

  /// No description provided for @catMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get catMedicine;

  /// No description provided for @catDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get catDocument;

  /// No description provided for @catSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get catSubscription;

  /// No description provided for @catBill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get catBill;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get repeatNone;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get repeatMonthly;

  /// No description provided for @repeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get repeatYearly;

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notifChannelName;

  /// No description provided for @notifChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Task, medicine and appointment reminders'**
  String get notifChannelDescription;

  /// No description provided for @notifSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze 10 min'**
  String get notifSnooze;

  /// No description provided for @notifDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get notifDone;

  /// No description provided for @listsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping lists'**
  String get listsTitle;

  /// No description provided for @listsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No lists yet'**
  String get listsEmptyTitle;

  /// No description provided for @listsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a list for groceries, school supplies or anything else.'**
  String get listsEmptyBody;

  /// No description provided for @listNew.
  ///
  /// In en, this message translates to:
  /// **'New list'**
  String get listNew;

  /// No description provided for @listNameLabel.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get listNameLabel;

  /// No description provided for @listNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get listNameRequired;

  /// No description provided for @listItemsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All done} =1{1 item left} other{{count} items left}}'**
  String listItemsLeft(int count);

  /// No description provided for @listDeleted.
  ///
  /// In en, this message translates to:
  /// **'List deleted'**
  String get listDeleted;

  /// No description provided for @listEmptyItems.
  ///
  /// In en, this message translates to:
  /// **'Your list is waiting for its first item.'**
  String get listEmptyItems;

  /// No description provided for @itemAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add an item'**
  String get itemAddHint;

  /// No description provided for @itemAdd.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get itemAdd;

  /// No description provided for @itemEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get itemEdit;

  /// No description provided for @itemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get itemNameLabel;

  /// No description provided for @itemQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity (optional)'**
  String get itemQuantityLabel;

  /// No description provided for @itemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed'**
  String get itemRemoved;

  /// No description provided for @clearChecked.
  ///
  /// In en, this message translates to:
  /// **'Clear ticked items'**
  String get clearChecked;

  /// No description provided for @clearedChecked.
  ///
  /// In en, this message translates to:
  /// **'Ticked items cleared'**
  String get clearedChecked;

  /// No description provided for @listOptions.
  ///
  /// In en, this message translates to:
  /// **'List options'**
  String get listOptions;

  /// No description provided for @receiptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get receiptsTitle;

  /// No description provided for @receiptsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No receipts yet'**
  String get receiptsEmptyTitle;

  /// No description provided for @receiptsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save receipts to track spending and keep proof of purchase for warranties.'**
  String get receiptsEmptyBody;

  /// No description provided for @receiptNew.
  ///
  /// In en, this message translates to:
  /// **'New receipt'**
  String get receiptNew;

  /// No description provided for @receiptEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit receipt'**
  String get receiptEdit;

  /// No description provided for @receiptMerchantLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop or merchant'**
  String get receiptMerchantLabel;

  /// No description provided for @receiptMerchantRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter where you bought it'**
  String get receiptMerchantRequired;

  /// No description provided for @receiptAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get receiptAmountLabel;

  /// No description provided for @receiptAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount like {example}'**
  String receiptAmountInvalid(String example);

  /// No description provided for @receiptCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get receiptCurrencyLabel;

  /// No description provided for @receiptDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of purchase'**
  String get receiptDateLabel;

  /// No description provided for @receiptCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get receiptCategoryLabel;

  /// No description provided for @receiptNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get receiptNoteLabel;

  /// No description provided for @receiptWarrantyLabel.
  ///
  /// In en, this message translates to:
  /// **'Warranty until'**
  String get receiptWarrantyLabel;

  /// No description provided for @receiptNoWarranty.
  ///
  /// In en, this message translates to:
  /// **'No warranty'**
  String get receiptNoWarranty;

  /// No description provided for @receiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo of receipt from {merchant}'**
  String receiptPhoto(String merchant);

  /// No description provided for @receiptDeleted.
  ///
  /// In en, this message translates to:
  /// **'Receipt deleted'**
  String get receiptDeleted;

  /// No description provided for @receiptThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get receiptThisMonth;

  /// No description provided for @receiptSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search receipts'**
  String get receiptSearchHint;

  /// No description provided for @receiptNoResults.
  ///
  /// In en, this message translates to:
  /// **'No receipts match your search.'**
  String get receiptNoResults;

  /// No description provided for @receiptWarrantyUntil.
  ///
  /// In en, this message translates to:
  /// **'Warranty until {date}'**
  String receiptWarrantyUntil(String date);

  /// No description provided for @receiptWarrantyExpired.
  ///
  /// In en, this message translates to:
  /// **'Warranty expired'**
  String get receiptWarrantyExpired;

  /// No description provided for @rcGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get rcGroceries;

  /// No description provided for @rcHousehold.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get rcHousehold;

  /// No description provided for @rcElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get rcElectronics;

  /// No description provided for @rcClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get rcClothing;

  /// No description provided for @rcHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get rcHealth;

  /// No description provided for @rcTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get rcTransport;

  /// No description provided for @rcEatingOut.
  ///
  /// In en, this message translates to:
  /// **'Eating out'**
  String get rcEatingOut;

  /// No description provided for @rcSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get rcSchool;

  /// No description provided for @rcOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get rcOther;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get settingsName;

  /// No description provided for @settingsNameNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsNameNotSet;

  /// No description provided for @settingsMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get settingsMode;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default currency'**
  String get settingsCurrency;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match phone'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibility;

  /// No description provided for @settingsLargeText.
  ///
  /// In en, this message translates to:
  /// **'Larger text'**
  String get settingsLargeText;

  /// No description provided for @settingsLargeTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Makes all text and buttons bigger.'**
  String get settingsLargeTextDesc;

  /// No description provided for @settingsHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get settingsHighContrast;

  /// No description provided for @settingsHighContrastDesc.
  ///
  /// In en, this message translates to:
  /// **'Stronger colours that are easier to read.'**
  String get settingsHighContrastDesc;

  /// No description provided for @settingsConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Ask before deleting'**
  String get settingsConfirmDelete;

  /// No description provided for @settingsConfirmDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Show a confirmation before anything is deleted.'**
  String get settingsConfirmDeleteDesc;

  /// No description provided for @settingsSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get settingsSafety;

  /// No description provided for @settingsEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get settingsEmergency;

  /// No description provided for @emergencyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get emergencyNameLabel;

  /// No description provided for @emergencyPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get emergencyPhoneLabel;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this device. No account, no ads, no tracking.'**
  String get aboutBody;

  /// No description provided for @aboutFormats.
  ///
  /// In en, this message translates to:
  /// **'Dates use day-month-year order and weeks start on Monday.'**
  String get aboutFormats;

  /// No description provided for @modeStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get modeStudent;

  /// No description provided for @modeStudentDesc.
  ///
  /// In en, this message translates to:
  /// **'Homework, exams, school lists and simple spending.'**
  String get modeStudentDesc;

  /// No description provided for @modeEveryday.
  ///
  /// In en, this message translates to:
  /// **'Everyday'**
  String get modeEveryday;

  /// No description provided for @modeEverydayDesc.
  ///
  /// In en, this message translates to:
  /// **'Receipts, home tasks, bills, subscriptions and shopping.'**
  String get modeEverydayDesc;

  /// No description provided for @modeSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get modeSimple;

  /// No description provided for @modeSimpleDesc.
  ///
  /// In en, this message translates to:
  /// **'Bigger text and buttons, medicine and appointment reminders, emergency contact.'**
  String get modeSimpleDesc;

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to KeepAll'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your everyday things, all in one peaceful place.'**
  String get onbWelcomeBody;

  /// No description provided for @onbNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onbNext;

  /// No description provided for @onbBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onbBack;

  /// No description provided for @onbStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onbStart;

  /// No description provided for @onbModeTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use KeepAll?'**
  String get onbModeTitle;

  /// No description provided for @onbModeBody.
  ///
  /// In en, this message translates to:
  /// **'You can change this any time in More.'**
  String get onbModeBody;

  /// No description provided for @onbNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onbNameTitle;

  /// No description provided for @onbNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your first name (optional)'**
  String get onbNameHint;

  /// No description provided for @onbCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Which currency do you use?'**
  String get onbCurrencyTitle;

  /// No description provided for @onbStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onbStep(int step, int total);

  /// No description provided for @navSpending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get navSpending;

  /// No description provided for @spendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get spendingTitle;

  /// No description provided for @photoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get photoAdd;

  /// No description provided for @photoTake.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get photoTake;

  /// No description provided for @photoChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoChoose;

  /// No description provided for @photoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get photoRemove;

  /// No description provided for @photoError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add the photo. Please try again.'**
  String get photoError;

  /// No description provided for @homeDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get homeDocuments;

  /// No description provided for @homeDocsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None saved} =1{1 document} other{{count} documents}}'**
  String homeDocsCount(int count);

  /// No description provided for @homeDocsExpiring.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 expiring soon} other{{count} expiring soon}}'**
  String homeDocsExpiring(int count);

  /// No description provided for @docsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get docsTitle;

  /// No description provided for @docsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get docsEmptyTitle;

  /// No description provided for @docsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your passport, ID card, insurance and more. KeepAll reminds you before they expire.'**
  String get docsEmptyBody;

  /// No description provided for @docNew.
  ///
  /// In en, this message translates to:
  /// **'New document'**
  String get docNew;

  /// No description provided for @docEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get docEdit;

  /// No description provided for @docTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get docTypeLabel;

  /// No description provided for @docTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get docTitleLabel;

  /// No description provided for @docNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Document number (optional)'**
  String get docNumberLabel;

  /// No description provided for @docExpiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expires on'**
  String get docExpiryLabel;

  /// No description provided for @docNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry date'**
  String get docNoExpiry;

  /// No description provided for @docExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get docExpired;

  /// No description provided for @docExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Expires today} =1{Expires tomorrow} other{Expires in {days} days}}'**
  String docExpiresIn(int days);

  /// No description provided for @docValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String docValidUntil(String date);

  /// No description provided for @docExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires on {date}'**
  String docExpiresOn(String date);

  /// No description provided for @docRemindLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get docRemindLabel;

  /// No description provided for @docRemindNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get docRemindNone;

  /// No description provided for @docRemindBefore.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day before} other{{days} days before}}'**
  String docRemindBefore(int days);

  /// No description provided for @docRemindNeedsDate.
  ///
  /// In en, this message translates to:
  /// **'Add an expiry date to get a reminder.'**
  String get docRemindNeedsDate;

  /// No description provided for @docPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo of {title}'**
  String docPhoto(String title);

  /// No description provided for @docDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get docDeleted;

  /// No description provided for @docTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get docTypePassport;

  /// No description provided for @docTypeIdCard.
  ///
  /// In en, this message translates to:
  /// **'ID card'**
  String get docTypeIdCard;

  /// No description provided for @docTypeDrivingLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving licence'**
  String get docTypeDrivingLicence;

  /// No description provided for @docTypeInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get docTypeInsurance;

  /// No description provided for @docTypeVehicle.
  ///
  /// In en, this message translates to:
  /// **'Car / vehicle'**
  String get docTypeVehicle;

  /// No description provided for @docTypeHealth.
  ///
  /// In en, this message translates to:
  /// **'Health card'**
  String get docTypeHealth;

  /// No description provided for @docTypeContract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get docTypeContract;

  /// No description provided for @docTypeWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get docTypeWarranty;

  /// No description provided for @docTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docTypeOther;

  /// No description provided for @moreOrganise.
  ///
  /// In en, this message translates to:
  /// **'Organise'**
  String get moreOrganise;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Match phone'**
  String get languageSystem;

  /// No description provided for @listShare.
  ///
  /// In en, this message translates to:
  /// **'Share list'**
  String get listShare;

  /// No description provided for @listCopied.
  ///
  /// In en, this message translates to:
  /// **'List copied to clipboard'**
  String get listCopied;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupTitle;

  /// No description provided for @backupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get backupCreate;

  /// No description provided for @backupCreateDesc.
  ///
  /// In en, this message translates to:
  /// **'Save all your data and photos to a file.'**
  String get backupCreateDesc;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Replace everything with a backup file.'**
  String get backupRestoreDesc;

  /// No description provided for @backupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get backupCreated;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get backupFailed;

  /// No description provided for @backupInvalid.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a KeepAll backup.'**
  String get backupInvalid;

  /// No description provided for @backupTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup was made with a newer version of KeepAll. Please update the app first.'**
  String get backupTooNew;

  /// No description provided for @backupRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get backupRestoreConfirmTitle;

  /// No description provided for @backupContains.
  ///
  /// In en, this message translates to:
  /// **'Tasks: {tasks}\nLists: {lists}\nReceipts: {receipts}\nDocuments: {documents}'**
  String backupContains(int tasks, int lists, int receipts, int documents);

  /// No description provided for @backupRestoreWarning.
  ///
  /// In en, this message translates to:
  /// **'Everything currently in the app will be replaced.'**
  String get backupRestoreWarning;

  /// No description provided for @backupRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestoreAction;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @modeStudentShort.
  ///
  /// In en, this message translates to:
  /// **'School, exams & money'**
  String get modeStudentShort;

  /// No description provided for @modeEverydayShort.
  ///
  /// In en, this message translates to:
  /// **'Home & everyday life'**
  String get modeEverydayShort;

  /// No description provided for @modeSimpleShort.
  ///
  /// In en, this message translates to:
  /// **'Bigger & easier'**
  String get modeSimpleShort;

  /// No description provided for @homeYourDay.
  ///
  /// In en, this message translates to:
  /// **'Your day'**
  String get homeYourDay;

  /// No description provided for @homeYourDayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to take care of} =1{1 thing to take care of} other{{count} things to take care of}}'**
  String homeYourDayCount(int count);

  /// No description provided for @homeView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get homeView;

  /// No description provided for @receiptMonthSpending.
  ///
  /// In en, this message translates to:
  /// **'{month} spending'**
  String receiptMonthSpending(String month);

  /// No description provided for @receiptCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No receipts} =1{1 receipt} other{{count} receipts}}'**
  String receiptCount(int count);

  /// No description provided for @docSoon.
  ///
  /// In en, this message translates to:
  /// **'Expires soon'**
  String get docSoon;

  /// No description provided for @tasksAllDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Enjoy the rest of your day.'**
  String get tasksAllDoneBody;

  /// No description provided for @settingsPalette.
  ///
  /// In en, this message translates to:
  /// **'Color theme'**
  String get settingsPalette;

  /// No description provided for @paletteDeepOcean.
  ///
  /// In en, this message translates to:
  /// **'Deep Ocean'**
  String get paletteDeepOcean;

  /// No description provided for @paletteMatchaHoney.
  ///
  /// In en, this message translates to:
  /// **'Matcha & Honey'**
  String get paletteMatchaHoney;

  /// No description provided for @paletteSunsetPop.
  ///
  /// In en, this message translates to:
  /// **'Sunset Pop'**
  String get paletteSunsetPop;

  /// No description provided for @paletteMidnightCandy.
  ///
  /// In en, this message translates to:
  /// **'Midnight Candy'**
  String get paletteMidnightCandy;

  /// No description provided for @paletteSoftPastel.
  ///
  /// In en, this message translates to:
  /// **'Soft Pastel'**
  String get paletteSoftPastel;

  /// No description provided for @paletteAlwaysDark.
  ///
  /// In en, this message translates to:
  /// **'Always dark'**
  String get paletteAlwaysDark;

  /// No description provided for @paletteCreamCocoa.
  ///
  /// In en, this message translates to:
  /// **'Cream & Cocoa'**
  String get paletteCreamCocoa;

  /// No description provided for @paletteNordicSnow.
  ///
  /// In en, this message translates to:
  /// **'Nordic Snow'**
  String get paletteNordicSnow;

  /// No description provided for @paletteSkySunshine.
  ///
  /// In en, this message translates to:
  /// **'Sky & Sunshine'**
  String get paletteSkySunshine;

  /// No description provided for @paletteLavenderNight.
  ///
  /// In en, this message translates to:
  /// **'Lavender Night'**
  String get paletteLavenderNight;

  /// No description provided for @paletteLemonCharcoal.
  ///
  /// In en, this message translates to:
  /// **'Lemon & Charcoal'**
  String get paletteLemonCharcoal;

  /// No description provided for @currencySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search currency or country'**
  String get currencySearchHint;

  /// No description provided for @currencyPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get currencyPopular;

  /// No description provided for @currencyAll.
  ///
  /// In en, this message translates to:
  /// **'All currencies'**
  String get currencyAll;

  /// No description provided for @currencyNoResults.
  ///
  /// In en, this message translates to:
  /// **'No currency found'**
  String get currencyNoResults;

  /// No description provided for @currencyMore.
  ///
  /// In en, this message translates to:
  /// **'More currencies'**
  String get currencyMore;

  /// No description provided for @receiptDateFuture.
  ///
  /// In en, this message translates to:
  /// **'The purchase date can\'t be in the future.'**
  String get receiptDateFuture;

  /// No description provided for @homeUpcomingTasks.
  ///
  /// In en, this message translates to:
  /// **'Upcoming tasks'**
  String get homeUpcomingTasks;

  /// No description provided for @taskPastDateTime.
  ///
  /// In en, this message translates to:
  /// **'The date and time cannot be in the past.'**
  String get taskPastDateTime;

  /// No description provided for @reminderOnTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow reminders on time'**
  String get reminderOnTimeTitle;

  /// No description provided for @reminderOnTimeBody.
  ///
  /// In en, this message translates to:
  /// **'Android may hold reminders back while your phone is asleep. To get them exactly on time, even when KeepAll is closed, turn on “Alarms & reminders” for KeepAll on the next screen.'**
  String get reminderOnTimeBody;

  /// No description provided for @reminderOnTimeAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get reminderOnTimeAllow;

  /// No description provided for @reminderOnTimeLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get reminderOnTimeLater;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'nl',
    'pl',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
