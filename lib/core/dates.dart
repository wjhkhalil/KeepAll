import 'package:intl/intl.dart';

/// European conventions: day before month, 24-hour clock, weeks start on
/// Monday. The separator follows the language (27/09/2026, 27.09.2026,
/// 27-09-2026) and weekday/month names are translated.
const appDateLocale = 'en_GB';

String _locale = appDateLocale;
late DateFormat _date;
late DateFormat _time;
late DateFormat _weekday;
late DateFormat _monthYear;
late DateFormat _weekdayLong;
late DateFormat _longDate;
late DateFormat _dayMonth;
late DateFormat _month;
bool _ready = false;

/// Date separator per language; anything unlisted uses "/".
const _separators = {'de': '.', 'pl': '.', 'nl': '-'};

/// Switches formatting to [languageCode] (e.g. "de"). Call after
/// `initializeDateFormatting()`.
void setDateLanguage(String languageCode) {
  _locale = languageCode == 'en' ? appDateLocale : languageCode;
  final sep = _separators[languageCode] ?? '/';
  _date = DateFormat('dd${sep}MM${sep}yyyy', _locale);
  _time = DateFormat('HH:mm', _locale);
  _weekday = DateFormat('EEE', _locale);
  _monthYear = DateFormat('LLLL yyyy', _locale);
  _weekdayLong = DateFormat('EEEE', _locale);
  _longDate = DateFormat('d MMMM y', _locale);
  _dayMonth = DateFormat('dd${sep}MM', _locale);
  _month = DateFormat('LLLL', _locale);
  _ready = true;
}

void _ensure() {
  if (!_ready) setDateLanguage('en');
}

String formatDate(DateTime d) {
  _ensure();
  return _date.format(d);
}

String formatTime(DateTime d) {
  _ensure();
  return _time.format(d);
}

String formatDateTime(DateTime d) => '${formatDate(d)} ${formatTime(d)}';

String formatWeekday(DateTime d) {
  _ensure();
  return _weekday.format(d);
}

String formatMonthYear(DateTime d) {
  _ensure();
  final s = _monthYear.format(d);
  // Some languages return lower-case month names ("września 2026").
  return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

String _capitalised(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// "Saturday"
String formatWeekdayLong(DateTime d) {
  _ensure();
  return _capitalised(_weekdayLong.format(d));
}

/// "27 September 2026"
String formatLongDate(DateTime d) {
  _ensure();
  return _longDate.format(d);
}

/// "27/09"
String formatDayMonth(DateTime d) {
  _ensure();
  return _dayMonth.format(d);
}

/// "September"
String formatMonth(DateTime d) {
  _ensure();
  return _capitalised(_month.format(d));
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Monday 00:00 of the week containing [d].
DateTime startOfWeek(DateTime d) =>
    dateOnly(d).subtract(Duration(days: d.weekday - DateTime.monday));

/// Whole calendar days from [from] to [to] (negative if [to] is earlier).
/// Uses UTC so daylight-saving changes can't produce 23h/25h "days".
int daysBetween(DateTime from, DateTime to) => DateTime.utc(to.year, to.month, to.day)
    .difference(DateTime.utc(from.year, from.month, from.day))
    .inDays;

/// Adds [months] to [d], clamping the day (31 Jan + 1 month = 28/29 Feb).
/// [day] overrides the preferred day of month, so a monthly task anchored to
/// the 31st goes 31 Jan → 28 Feb → 31 Mar instead of drifting to the 28th.
DateTime addMonths(DateTime d, int months, {int? day}) {
  final totalMonths = d.year * 12 + (d.month - 1) + months;
  final year = totalMonths ~/ 12;
  final month = totalMonths % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  final wanted = day ?? d.day;
  return DateTime(year, month, wanted > lastDay ? lastDay : wanted, d.hour, d.minute);
}
