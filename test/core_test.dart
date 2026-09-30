import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lifekeeper/core/dates.dart';
import 'package:lifekeeper/core/money.dart';
import 'package:lifekeeper/data/models.dart';

void main() {
  setUpAll(() => initializeDateFormatting(appDateLocale));

  group('parseMoneyToCents', () {
    test('accepts European and English formats', () {
      expect(parseAmount('12,50', Currency.eur), 1250);
      expect(parseAmount('12.50', Currency.eur), 1250);
      expect(parseAmount('12,5', Currency.eur), 1250);
      expect(parseAmount('12', Currency.eur), 1200);
      expect(parseAmount('1.234,56', Currency.eur), 123456);
      expect(parseAmount('1,234.56', Currency.eur), 123456);
      expect(parseAmount('1 234,56', Currency.eur), 123456);
      expect(parseAmount('1.234', Currency.eur), 123400);
      expect(parseAmount('€ 9,99', Currency.eur), 999);
      expect(parseAmount('CHF 30', Currency.eur), 3000);
      expect(parseAmount(',50', Currency.eur), 50);
    });

    test('rejects invalid input', () {
      expect(parseAmount('', Currency.eur), isNull);
      expect(parseAmount('abc', Currency.eur), isNull);
      expect(parseAmount('12,345,6', Currency.eur), isNull);
      expect(parseAmount('1.2.3', Currency.eur), isNull);
      expect(parseAmount('12.505', Currency.eur), 1250500); // thousands grouping
    });

    test('round-trips through amountToInput', () {
      for (final c in [0, 5, 99, 100, 1250, 123456]) {
        expect(parseAmount(amountToInput(c, Currency.eur), Currency.eur), c);
      }
    });
  });

  test('formatMoney uses symbol or code', () {
    expect(formatMoney(123450, Currency.eur), '€1,234.50');
    expect(formatMoney(999, Currency.gbp), '£9.99');
    expect(formatMoney(3000, Currency.chf), 'CHF 30.00');
    expect(formatMoney(5, Currency.sek), 'SEK 0.05');
    expect(formatMoney(-250, Currency.eur), '-€2.50');
  });

  group('all world currencies', () {
    test('about 150 currencies, each code unique', () {
      expect(Currency.all.length, greaterThan(140));
      expect(Currency.all.map((c) => c.code).toSet().length, Currency.all.length);
      for (final code in ['USD', 'JPY', 'INR', 'PKR', 'BRL', 'ZAR', 'KWD', 'CNY', 'AUD', 'EUR']) {
        expect(Currency.tryCode(code), isNotNull, reason: code);
      }
    });

    test('uses each currency\'s own decimals', () {
      final jpy = Currency.fromCode('JPY');
      final kwd = Currency.fromCode('KWD');
      expect(jpy.decimals, 0);
      expect(kwd.decimals, 3);
      expect(formatMoney(150000, jpy), '¥150,000');
      expect(formatMoney(1250, kwd), 'KWD 1.250');
      expect(formatMoney(1999, Currency.usd), '\$19.99');
      expect(formatMoney(1999, Currency.fromCode('CAD')), 'CA\$19.99');
      expect(formatMoney(50000, Currency.fromCode('INR')), '₹500.00');
    });

    test('parses amounts using the currency\'s decimals', () {
      final jpy = Currency.fromCode('JPY');
      final kwd = Currency.fromCode('KWD');
      expect(parseAmount('1500', jpy), 1500);
      expect(parseAmount('1.500', jpy), 1500);
      expect(parseAmount('1,500', jpy), 1500);
      expect(parseAmount('1500,00', jpy), 1500);
      expect(parseAmount('12,5', jpy), isNull);
      expect(parseAmount('1,250', kwd), 1250);
      expect(parseAmount('1.5', kwd), 1500);
      expect(parseAmount('\$ 19.99', Currency.usd), 1999);
      for (final c in [jpy, kwd, Currency.usd]) {
        for (final v in [0, 7, 1250, 987654]) {
          expect(parseAmount(amountToInput(v, c), c), v, reason: '${c.code} $v');
        }
      }
    });

    test('search finds currencies by code, name or country, in any language', () {
      bool finds(String q, String code, [String lang = 'en']) =>
          Currency.all.where((c) => c.matches(q, lang)).any((c) => c.code == code);
      expect(finds('jpy', 'JPY'), isTrue);
      expect(finds('yen', 'JPY'), isTrue);
      expect(finds('japan', 'JPY'), isTrue);
      expect(finds('Japon', 'JPY', 'fr'), isTrue);
      expect(finds('pakistan', 'PKR'), isTrue);
      expect(finds('Schweiz', 'CHF', 'de'), isTrue);
      expect(Currency.fromCode('PLN').name('pl'), 'Złoty polski');
    });

    test('guesses the currency from the phone region', () {
      expect(currencyForRegion('CH'), Currency.chf);
      expect(currencyForRegion('US'), Currency.usd);
      expect(currencyForRegion('DE'), Currency.eur);
      expect(currencyForRegion('IN').code, 'INR');
      expect(currencyForRegion(null), Currency.eur);
    });

    test('unknown codes in old data fall back to euro', () {
      expect(Currency.fromCode('XXX'), Currency.eur);
    });
  });

  test('totalsByCurrency never mixes currencies', () {
    final totals = totalsByCurrency([
      (1000, Currency.eur),
      (500, Currency.eur),
      (2000, Currency.chf),
    ]);
    expect(totals, {Currency.eur: 1500, Currency.chf: 2000});
  });

  group('dates', () {
    test('formats as DD/MM/YYYY and 24h', () {
      final d = DateTime(2026, 9, 7, 14, 5);
      expect(formatDate(d), '07/09/2026');
      expect(formatTime(d), '14:05');
    });

    test('weeks start on Monday', () {
      // 27/09/2026 is a Sunday.
      expect(startOfWeek(DateTime(2026, 9, 27, 18)), DateTime(2026, 9, 21));
      expect(startOfWeek(DateTime(2026, 9, 21)), DateTime(2026, 9, 21));
    });

    test('daysBetween ignores DST changes', () {
      // Clocks change in Europe on 25/10/2026.
      expect(daysBetween(DateTime(2026, 10, 24, 23), DateTime(2026, 10, 26, 1)), 2);
      expect(daysBetween(DateTime(2026, 9, 27), DateTime(2026, 9, 26)), -1);
    });

    test('addMonths clamps the day', () {
      expect(addMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
      expect(addMonths(DateTime(2028, 1, 31), 1), DateTime(2028, 2, 29));
      expect(addMonths(DateTime(2026, 12, 15), 1), DateTime(2027, 1, 15));
    });
  });

  group('Task', () {
    Task task({DateTime? due, bool hasTime = false, bool remind = true, DateTime? snooze}) => Task(
      id: 'a',
      notificationId: 1,
      title: 'Pills',
      dueAt: due,
      hasTime: hasTime,
      remind: remind,
      snoozedUntil: snooze,
      createdAt: DateTime(2026),
    );

    test('all-day reminders fire at 09:00', () {
      expect(task(due: DateTime(2026, 9, 28)).reminderAt, DateTime(2026, 9, 28, 9));
    });

    test('snooze moves the reminder later', () {
      final t = task(due: DateTime(2026, 9, 28, 8), hasTime: true, snooze: DateTime(2026, 9, 28, 8, 10));
      expect(t.reminderAt, DateTime(2026, 9, 28, 8, 10));
    });

    test('no reminder without a date or when done', () {
      expect(task().reminderAt, isNull);
      expect(task(due: DateTime(2026, 9, 28)).copyWith(done: true).reminderAt, isNull);
    });

    test('overdue rules for all-day vs timed tasks', () {
      final now = DateTime(2026, 9, 27, 12);
      expect(task(due: DateTime(2026, 9, 27)).isOverdue(now), isFalse);
      expect(task(due: DateTime(2026, 9, 26)).isOverdue(now), isTrue);
      expect(task(due: DateTime(2026, 9, 27, 11), hasTime: true).isOverdue(now), isTrue);
    });

    test('JSON round-trip', () {
      final t = task(due: DateTime(2026, 9, 28, 8), hasTime: true).copyWith(repeat: Repeat.weekly, category: TaskCategory.medicine);
      final back = Task.fromJson(t.toJson());
      expect(back.toJson(), t.toJson());
    });
  });

  test('Receipt JSON round-trip keeps cents and currency', () {
    final r = Receipt(
      id: 'r',
      merchant: 'Lidl',
      amountCents: 1999,
      currency: Currency.pln,
      date: DateTime(2026, 9, 1),
      warrantyUntil: DateTime(2028, 9, 1),
      createdAt: DateTime(2026, 9, 1),
    );
    expect(Receipt.fromJson(r.toJson()).toJson(), r.toJson());
  });
}
