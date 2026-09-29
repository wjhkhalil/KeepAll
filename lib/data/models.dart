import '../core/dates.dart';
import '../core/money.dart';

/// Categories let one "task" model cover every age group: homework and exams
/// for students, bills and home maintenance for adults, medicine and
/// appointments for older users.
enum TaskCategory {
  general,
  study,
  exam,
  home,
  appointment,
  medicine,
  document,
  subscription,
  bill;

  static TaskCategory fromName(String? name) => TaskCategory.values.firstWhere(
    (c) => c.name == name,
    orElse: () => TaskCategory.general,
  );
}

enum Repeat {
  none,
  daily,
  weekly,
  monthly,
  yearly;

  static Repeat fromName(String? name) =>
      Repeat.values.firstWhere((r) => r.name == name, orElse: () => Repeat.none);

  /// The next occurrence after [from]. [anchorDay] is the day of month the
  /// user originally picked, so "every month on the 31st" never drifts.
  DateTime next(DateTime from, {int? anchorDay}) => switch (this) {
    Repeat.none => from,
    Repeat.daily => DateTime(from.year, from.month, from.day + 1, from.hour, from.minute),
    Repeat.weekly => DateTime(from.year, from.month, from.day + 7, from.hour, from.minute),
    Repeat.monthly => addMonths(from, 1, day: anchorDay),
    Repeat.yearly => addMonths(from, 12, day: anchorDay),
  };
}

class Task {
  Task({
    required this.id,
    required this.notificationId,
    required this.title,
    this.notes = '',
    this.category = TaskCategory.general,
    this.dueAt,
    this.hasTime = false,
    this.remind = false,
    this.repeat = Repeat.none,
    this.anchorDay,
    this.done = false,
    this.completedAt,
    this.snoozedUntil,
    required this.createdAt,
  });

  final String id;

  /// Stable integer id for the OS notification scheduler.
  final int notificationId;

  /// Id of a snoozed reminder of a repeating task. It is separate so the
  /// snooze doesn't replace the everyday reminder the phone repeats itself.
  int get snoozeNotificationId => notificationId ^ 0x40000000;
  final String title;
  final String notes;
  final TaskCategory category;

  /// Due date. When [hasTime] is false only the date part is meaningful.
  final DateTime? dueAt;
  final bool hasTime;
  final bool remind;
  final Repeat repeat;

  /// Day of month the repeat was set up on (see [Repeat.next]).
  final int? anchorDay;
  final bool done;
  final DateTime? completedAt;
  final DateTime? snoozedUntil;
  final DateTime createdAt;

  /// Default reminder time for all-day tasks.
  static const allDayReminderHour = 9;

  /// When the reminder should fire, or null if there is none.
  DateTime? get reminderAt {
    if (!remind || done || dueAt == null) return null;
    final due = hasTime
        ? dueAt!
        : DateTime(dueAt!.year, dueAt!.month, dueAt!.day, allDayReminderHour);
    final snooze = snoozedUntil;
    return snooze != null && snooze.isAfter(due) ? snooze : due;
  }

  bool isOverdue(DateTime now) {
    if (done || dueAt == null) return false;
    return hasTime ? dueAt!.isBefore(now) : dateOnly(dueAt!).isBefore(dateOnly(now));
  }

  Task copyWith({
    String? title,
    String? notes,
    TaskCategory? category,
    DateTime? Function()? dueAt,
    bool? hasTime,
    bool? remind,
    Repeat? repeat,
    int? Function()? anchorDay,
    bool? done,
    DateTime? Function()? completedAt,
    DateTime? Function()? snoozedUntil,
  }) => Task(
    id: id,
    notificationId: notificationId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    category: category ?? this.category,
    dueAt: dueAt != null ? dueAt() : this.dueAt,
    hasTime: hasTime ?? this.hasTime,
    remind: remind ?? this.remind,
    repeat: repeat ?? this.repeat,
    anchorDay: anchorDay != null ? anchorDay() : this.anchorDay,
    done: done ?? this.done,
    completedAt: completedAt != null ? completedAt() : this.completedAt,
    snoozedUntil: snoozedUntil != null ? snoozedUntil() : this.snoozedUntil,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'notificationId': notificationId,
    'title': title,
    'notes': notes,
    'category': category.name,
    'dueAt': dueAt?.toIso8601String(),
    'hasTime': hasTime,
    'remind': remind,
    'repeat': repeat.name,
    'anchorDay': anchorDay,
    'done': done,
    'completedAt': completedAt?.toIso8601String(),
    'snoozedUntil': snoozedUntil?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> j) => Task(
    id: j['id'] as String,
    notificationId: j['notificationId'] as int,
    title: j['title'] as String? ?? '',
    notes: j['notes'] as String? ?? '',
    category: TaskCategory.fromName(j['category'] as String?),
    dueAt: _date(j['dueAt']),
    hasTime: j['hasTime'] as bool? ?? false,
    remind: j['remind'] as bool? ?? false,
    repeat: Repeat.fromName(j['repeat'] as String?),
    anchorDay: j['anchorDay'] as int?,
    done: j['done'] as bool? ?? false,
    completedAt: _date(j['completedAt']),
    snoozedUntil: _date(j['snoozedUntil']),
    createdAt: _date(j['createdAt']) ?? DateTime.now(),
  );
}

class ShoppingItem {
  ShoppingItem({required this.id, required this.name, this.quantity = '', this.checked = false});

  final String id;
  final String name;
  final String quantity;
  final bool checked;

  ShoppingItem copyWith({String? name, String? quantity, bool? checked}) => ShoppingItem(
    id: id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    checked: checked ?? this.checked,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'checked': checked,
  };

  factory ShoppingItem.fromJson(Map<String, dynamic> j) => ShoppingItem(
    id: j['id'] as String,
    name: j['name'] as String? ?? '',
    quantity: j['quantity'] as String? ?? '',
    checked: j['checked'] as bool? ?? false,
  );
}

class ShoppingList {
  ShoppingList({required this.id, required this.name, List<ShoppingItem>? items, required this.createdAt})
    : items = items ?? const [];

  final String id;
  final String name;
  final List<ShoppingItem> items;
  final DateTime createdAt;

  int get remaining => items.where((i) => !i.checked).length;

  ShoppingList copyWith({String? name, List<ShoppingItem>? items}) =>
      ShoppingList(id: id, name: name ?? this.name, items: items ?? this.items, createdAt: createdAt);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'items': items.map((i) => i.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory ShoppingList.fromJson(Map<String, dynamic> j) => ShoppingList(
    id: j['id'] as String,
    name: j['name'] as String? ?? '',
    items: (j['items'] as List? ?? [])
        .map((e) => ShoppingItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    createdAt: _date(j['createdAt']) ?? DateTime.now(),
  );
}

enum ReceiptCategory {
  groceries,
  household,
  electronics,
  clothing,
  health,
  transport,
  eatingOut,
  school,
  other;

  static ReceiptCategory fromName(String? name) => ReceiptCategory.values.firstWhere(
    (c) => c.name == name,
    orElse: () => ReceiptCategory.other,
  );
}

class Receipt {
  Receipt({
    required this.id,
    required this.merchant,
    required this.amountCents,
    required this.currency,
    required this.date,
    this.category = ReceiptCategory.other,
    this.note = '',
    this.imageFile,
    this.warrantyUntil,
    required this.createdAt,
  });

  final String id;
  final String merchant;
  final int amountCents;
  final Currency currency;
  final DateTime date;
  final ReceiptCategory category;
  final String note;

  /// File name (not full path) inside the app's receipt image folder, so
  /// data survives the app container moving (iOS) and backups.
  final String? imageFile;
  final DateTime? warrantyUntil;
  final DateTime createdAt;

  Receipt copyWith({
    String? merchant,
    int? amountCents,
    Currency? currency,
    DateTime? date,
    ReceiptCategory? category,
    String? note,
    String? Function()? imageFile,
    DateTime? Function()? warrantyUntil,
  }) => Receipt(
    id: id,
    merchant: merchant ?? this.merchant,
    amountCents: amountCents ?? this.amountCents,
    currency: currency ?? this.currency,
    date: date ?? this.date,
    category: category ?? this.category,
    note: note ?? this.note,
    imageFile: imageFile != null ? imageFile() : this.imageFile,
    warrantyUntil: warrantyUntil != null ? warrantyUntil() : this.warrantyUntil,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'merchant': merchant,
    'amountCents': amountCents,
    'currency': currency.code,
    'date': date.toIso8601String(),
    'category': category.name,
    'note': note,
    'imageFile': imageFile,
    'warrantyUntil': warrantyUntil?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Receipt.fromJson(Map<String, dynamic> j) => Receipt(
    id: j['id'] as String,
    merchant: j['merchant'] as String? ?? '',
    amountCents: j['amountCents'] as int? ?? 0,
    currency: Currency.fromCode(j['currency'] as String?),
    date: _date(j['date']) ?? DateTime.now(),
    category: ReceiptCategory.fromName(j['category'] as String?),
    note: j['note'] as String? ?? '',
    imageFile: j['imageFile'] as String?,
    warrantyUntil: _date(j['warrantyUntil']),
    createdAt: _date(j['createdAt']) ?? DateTime.now(),
  );
}

enum DocumentType {
  passport,
  idCard,
  drivingLicence,
  insurance,
  vehicle,
  health,
  contract,
  warranty,
  other;

  static DocumentType fromName(String? name) =>
      DocumentType.values.firstWhere((t) => t.name == name, orElse: () => DocumentType.other);
}

/// An important document, optionally with an expiry date and a reminder a
/// chosen number of days before it expires.
class Document {
  Document({
    required this.id,
    required this.notificationId,
    required this.title,
    this.type = DocumentType.other,
    this.number = '',
    this.expiresAt,
    this.remindDaysBefore = 30,
    this.notes = '',
    this.imageFile,
    required this.createdAt,
  });

  final String id;
  final int notificationId;
  final String title;
  final DocumentType type;

  /// Document / policy number (optional).
  final String number;
  final DateTime? expiresAt;

  /// 0 = no reminder.
  final int remindDaysBefore;
  final String notes;
  final String? imageFile;
  final DateTime createdAt;

  static const reminderHour = 9;

  DateTime? get reminderAt {
    if (expiresAt == null || remindDaysBefore <= 0) return null;
    final day = dateOnly(expiresAt!).subtract(Duration(days: remindDaysBefore));
    return DateTime(day.year, day.month, day.day, reminderHour);
  }

  /// Days until expiry (negative once expired), or null without a date.
  int? daysLeft(DateTime now) => expiresAt == null ? null : daysBetween(now, expiresAt!);

  Document copyWith({
    String? title,
    DocumentType? type,
    String? number,
    DateTime? Function()? expiresAt,
    int? remindDaysBefore,
    String? notes,
    String? Function()? imageFile,
  }) => Document(
    id: id,
    notificationId: notificationId,
    title: title ?? this.title,
    type: type ?? this.type,
    number: number ?? this.number,
    expiresAt: expiresAt != null ? expiresAt() : this.expiresAt,
    remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
    notes: notes ?? this.notes,
    imageFile: imageFile != null ? imageFile() : this.imageFile,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'notificationId': notificationId,
    'title': title,
    'type': type.name,
    'number': number,
    'expiresAt': expiresAt?.toIso8601String(),
    'remindDaysBefore': remindDaysBefore,
    'notes': notes,
    'imageFile': imageFile,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Document.fromJson(Map<String, dynamic> j) => Document(
    id: j['id'] as String,
    notificationId: j['notificationId'] as int,
    title: j['title'] as String? ?? '',
    type: DocumentType.fromName(j['type'] as String?),
    number: j['number'] as String? ?? '',
    expiresAt: _date(j['expiresAt']),
    remindDaysBefore: j['remindDaysBefore'] as int? ?? 30,
    notes: j['notes'] as String? ?? '',
    imageFile: j['imageFile'] as String?,
    createdAt: _date(j['createdAt']) ?? DateTime.now(),
  );
}

DateTime? _date(Object? v) => v is String ? DateTime.tryParse(v) : null;
