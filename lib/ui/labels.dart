import 'package:flutter/material.dart';

import '../core/money.dart';
import '../data/models.dart';
import '../l10n/app_localizations.dart';
import '../state/settings.dart';
import 'design.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String taskCategoryLabel(AppLocalizations l, TaskCategory c) => switch (c) {
  TaskCategory.general => l.catGeneral,
  TaskCategory.study => l.catStudy,
  TaskCategory.exam => l.catExam,
  TaskCategory.home => l.catHome,
  TaskCategory.appointment => l.catAppointment,
  TaskCategory.medicine => l.catMedicine,
  TaskCategory.document => l.catDocument,
  TaskCategory.subscription => l.catSubscription,
  TaskCategory.bill => l.catBill,
};

IconData taskCategoryIcon(TaskCategory c) => switch (c) {
  TaskCategory.general => Icons.check_circle_outline,
  TaskCategory.study => Icons.menu_book_rounded,
  TaskCategory.exam => Icons.school_rounded,
  TaskCategory.home => Icons.home_repair_service_rounded,
  TaskCategory.appointment => Icons.event_rounded,
  TaskCategory.medicine => Icons.medication_rounded,
  TaskCategory.document => Icons.description_rounded,
  TaskCategory.subscription => Icons.autorenew,
  TaskCategory.bill => Icons.receipt_long_rounded,
};

/// Categories offered first for each mode; the rest follow.
List<TaskCategory> categoriesFor(UserMode mode) {
  final preferred = switch (mode) {
    UserMode.student => [TaskCategory.study, TaskCategory.exam, TaskCategory.general],
    UserMode.everyday => [TaskCategory.general, TaskCategory.home, TaskCategory.bill, TaskCategory.subscription],
    UserMode.simple => [TaskCategory.medicine, TaskCategory.appointment, TaskCategory.general],
  };
  return [...preferred, ...TaskCategory.values.where((c) => !preferred.contains(c))];
}

String repeatLabel(AppLocalizations l, Repeat r) => switch (r) {
  Repeat.none => l.repeatNone,
  Repeat.daily => l.repeatDaily,
  Repeat.weekly => l.repeatWeekly,
  Repeat.monthly => l.repeatMonthly,
  Repeat.yearly => l.repeatYearly,
};

String receiptCategoryLabel(AppLocalizations l, ReceiptCategory c) => switch (c) {
  ReceiptCategory.groceries => l.rcGroceries,
  ReceiptCategory.household => l.rcHousehold,
  ReceiptCategory.electronics => l.rcElectronics,
  ReceiptCategory.clothing => l.rcClothing,
  ReceiptCategory.health => l.rcHealth,
  ReceiptCategory.transport => l.rcTransport,
  ReceiptCategory.eatingOut => l.rcEatingOut,
  ReceiptCategory.school => l.rcSchool,
  ReceiptCategory.other => l.rcOther,
};

IconData receiptCategoryIcon(ReceiptCategory c) => switch (c) {
  ReceiptCategory.groceries => Icons.local_grocery_store_rounded,
  ReceiptCategory.household => Icons.chair_rounded,
  ReceiptCategory.electronics => Icons.devices_rounded,
  ReceiptCategory.clothing => Icons.checkroom_rounded,
  ReceiptCategory.health => Icons.local_pharmacy_rounded,
  ReceiptCategory.transport => Icons.directions_bus_rounded,
  ReceiptCategory.eatingOut => Icons.restaurant_rounded,
  ReceiptCategory.school => Icons.backpack_rounded,
  ReceiptCategory.other => Icons.receipt_rounded,
};

/// Currency name in the app's current language ("Japanese Yen").
String currencyName(AppLocalizations l, Currency c) => c.name(l.localeName.split('_').first);

String modeLabel(AppLocalizations l, UserMode m) => switch (m) {
  UserMode.student => l.modeStudent,
  UserMode.everyday => l.modeEveryday,
  UserMode.simple => l.modeSimple,
};

String modeDescription(AppLocalizations l, UserMode m) => switch (m) {
  UserMode.student => l.modeStudentDesc,
  UserMode.everyday => l.modeEverydayDesc,
  UserMode.simple => l.modeSimpleDesc,
};

String modeShort(AppLocalizations l, UserMode m) => switch (m) {
  UserMode.student => l.modeStudentShort,
  UserMode.everyday => l.modeEverydayShort,
  UserMode.simple => l.modeSimpleShort,
};

IconData modeIcon(UserMode m) => switch (m) {
  UserMode.student => Icons.backpack_rounded,
  UserMode.everyday => Icons.home_rounded,
  UserMode.simple => Icons.accessibility_new,
};

String documentTypeLabel(AppLocalizations l, DocumentType t) => switch (t) {
  DocumentType.passport => l.docTypePassport,
  DocumentType.idCard => l.docTypeIdCard,
  DocumentType.drivingLicence => l.docTypeDrivingLicence,
  DocumentType.insurance => l.docTypeInsurance,
  DocumentType.vehicle => l.docTypeVehicle,
  DocumentType.health => l.docTypeHealth,
  DocumentType.contract => l.docTypeContract,
  DocumentType.warranty => l.docTypeWarranty,
  DocumentType.other => l.docTypeOther,
};

IconData documentTypeIcon(DocumentType t) => switch (t) {
  DocumentType.passport => Icons.travel_explore,
  DocumentType.idCard => Icons.badge_rounded,
  DocumentType.drivingLicence => Icons.directions_car_rounded,
  DocumentType.insurance => Icons.shield_rounded,
  DocumentType.vehicle => Icons.car_repair_rounded,
  DocumentType.health => Icons.health_and_safety_rounded,
  DocumentType.contract => Icons.handshake_rounded,
  DocumentType.warranty => Icons.verified_rounded,
  DocumentType.other => Icons.description_rounded,
};

/// Each language is shown in its own name so people can always find theirs.
String languageName(String code) => switch (code) {
  'en' => 'English',
  'de' => 'Deutsch',
  'fr' => 'Français',
  'es' => 'Español',
  'it' => 'Italiano',
  'nl' => 'Nederlands',
  'pl' => 'Polski',
  _ => code,
};

Color receiptCategoryTint(AppColors c, ReceiptCategory r) => switch (r) {
  ReceiptCategory.groceries => c.sage,
  ReceiptCategory.household => c.butter,
  ReceiptCategory.electronics => c.blue,
  ReceiptCategory.clothing => c.lavender,
  ReceiptCategory.health => c.peach,
  ReceiptCategory.transport => c.blue,
  ReceiptCategory.eatingOut => c.peach,
  ReceiptCategory.school => c.lavender,
  ReceiptCategory.other => c.category(TaskCategory.general),
};

Color documentTypeTint(AppColors c, DocumentType t) => switch (t) {
  DocumentType.passport || DocumentType.idCard => c.blue,
  DocumentType.drivingLicence || DocumentType.vehicle => c.sage,
  DocumentType.insurance || DocumentType.health => c.peach,
  DocumentType.contract || DocumentType.warranty => c.butter,
  DocumentType.other => c.category(TaskCategory.document),
};

String paletteLabel(AppLocalizations l, ColorPalette p) => switch (p) {
  ColorPalette.deepOcean => l.paletteDeepOcean,
  ColorPalette.matchaHoney => l.paletteMatchaHoney,
  ColorPalette.sunsetPop => l.paletteSunsetPop,
  ColorPalette.midnightCandy => l.paletteMidnightCandy,
  ColorPalette.softPastel => l.paletteSoftPastel,
  ColorPalette.creamCocoa => l.paletteCreamCocoa,
  ColorPalette.nordicSnow => l.paletteNordicSnow,
  ColorPalette.skySunshine => l.paletteSkySunshine,
  ColorPalette.lavenderNight => l.paletteLavenderNight,
  ColorPalette.lemonCharcoal => l.paletteLemonCharcoal,
};
