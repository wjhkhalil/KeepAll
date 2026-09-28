import 'currency_data.g.dart';

/// Any currency that is legal tender somewhere today (ISO 4217, from Unicode
/// CLDR). Amounts are always stored as integer minor units – cents, øre,
/// fils… – using the currency's own number of decimals (0 for JPY, 3 for
/// KWD), so we never lose precision to doubles.
class Currency {
  const Currency._(this.code, this.symbol, this.decimals, this.countries, this.exampleMinor);

  final String code;

  /// English display symbol: "€", "£", "\$", "CA\$", "¥", or the code itself.
  final String symbol;
  final int decimals;

  /// ISO country codes that use this currency.
  final List<String> countries;

  /// A realistic small purchase in minor units (≈ €12.50 converted), used as
  /// the example in amount fields: 12.50 for EUR, 3900 for PKR, 2200 for JPY.
  final int exampleMinor;

  static final List<Currency> all = [for (final (c, s, d, t, e) in currencyTable) Currency._(c, s, d, t, e)];
  static final Map<String, Currency> _byCode = {for (final c in all) c.code: c};

  static Currency get eur => _byCode['EUR']!;
  static Currency get gbp => _byCode['GBP']!;
  static Currency get chf => _byCode['CHF']!;
  static Currency get sek => _byCode['SEK']!;
  static Currency get nok => _byCode['NOK']!;
  static Currency get dkk => _byCode['DKK']!;
  static Currency get pln => _byCode['PLN']!;
  static Currency get czk => _byCode['CZK']!;
  static Currency get usd => _byCode['USD']!;

  /// Shown at the top of pickers: the European currencies plus the US dollar.
  static List<Currency> get popular => [
    for (final c in ['EUR', 'GBP', 'CHF', 'SEK', 'NOK', 'DKK', 'PLN', 'CZK', 'USD']) _byCode[c]!,
  ];

  static Currency? tryCode(String? code) => _byCode[code?.toUpperCase()];

  /// Unknown or missing codes fall back to the euro.
  static Currency fromCode(String? code) => tryCode(code) ?? eur;

  /// Localised name, e.g. "Japanese Yen" / "Japanischer Yen".
  String name(String language) => currencyNames[language]?[code] ?? currencyNames['en']![code] ?? code;

  /// True if [query] matches the code, symbol, name or a country using it
  /// (in [language] or English), e.g. "yen", "jpy", "japan", "Japon".
  bool matches(String query, String language) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (code.toLowerCase().contains(q) || symbol.toLowerCase() == q) return true;
    for (final lang in {language, 'en'}) {
      if ((currencyNames[lang]?[code] ?? '').toLowerCase().contains(q)) return true;
      for (final country in countries) {
        if ((countryNames[lang]?[country] ?? '').toLowerCase().contains(q)) return true;
      }
    }
    return false;
  }

  /// Symbols that aren't plain letters (€, £, \$, CA\$, ₹) sit right next to
  /// the number in English; letter codes get a space ("CHF 12.50").
  bool get _tightSymbol => symbol.runes.any((r) {
    final ch = String.fromCharCode(r);
    return ch.trim().isNotEmpty && ch.toUpperCase() == ch.toLowerCase();
  });

  int get _factor {
    var f = 1;
    for (var i = 0; i < decimals; i++) {
      f *= 10;
    }
    return f;
  }

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

/// The currency used in a region (ISO country code), or the euro if unknown.
Currency currencyForRegion(String? countryCode) {
  if (countryCode == null) return Currency.eur;
  final cc = countryCode.toUpperCase();
  for (final c in Currency.all) {
    if (c.countries.contains(cc)) return c;
  }
  return Currency.eur;
}

/// Number style per language: decimal separator, thousands separator and
/// whether the currency goes before the amount.
class _MoneyStyle {
  const _MoneyStyle(this.decimal, this.group, {required this.symbolFirst});

  final String decimal;
  final String group;
  final bool symbolFirst;
}

const _nbsp = '\u00A0';
const _styles = {
  'en': _MoneyStyle('.', ',', symbolFirst: true),
  'de': _MoneyStyle(',', '.', symbolFirst: false),
  'fr': _MoneyStyle(',', _nbsp, symbolFirst: false),
  'es': _MoneyStyle(',', '.', symbolFirst: false),
  'it': _MoneyStyle(',', '.', symbolFirst: false),
  'nl': _MoneyStyle(',', '.', symbolFirst: true),
  'pl': _MoneyStyle(',', _nbsp, symbolFirst: false),
};

var _style = _styles['en']!;
var _moneyLanguage = 'en';

/// Switches number formatting to [languageCode] (e.g. "de" → "1.234,50 €").
void setMoneyLanguage(String languageCode) {
  _moneyLanguage = _styles.containsKey(languageCode) ? languageCode : 'en';
  _style = _styles[_moneyLanguage]!;
}

/// Formats [minor] units of [currency], e.g. `€1,234.50`, `CHF 12.00`,
/// `¥1,500` or `KWD 1.250` in English, `1.234,50 €` in German.
String formatMoney(int minor, Currency currency) {
  final negative = minor < 0;
  final abs = minor.abs();
  final whole = _groupThousands(abs ~/ currency._factor, _style.group);
  final number = currency.decimals == 0
      ? whole
      : '$whole${_style.decimal}${(abs % currency._factor).toString().padLeft(currency.decimals, '0')}';
  final String withSymbol;
  if (!_style.symbolFirst) {
    withSymbol = '$number$_nbsp${currency.symbol}';
  } else if (currency._tightSymbol && _moneyLanguage == 'en') {
    withSymbol = '${currency.symbol}$number';
  } else {
    withSymbol = '${currency.symbol} $number';
  }
  return negative ? '-$withSymbol' : withSymbol;
}

String _groupThousands(int value, String separator) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(separator);
    buf.write(s[i]);
  }
  return buf.toString();
}

/// Editable amount in the current language style, e.g. `12.50`, `12,50`
/// or `1500` for yen.
String amountToInput(int minor, Currency currency) {
  final abs = minor.abs();
  final whole = abs ~/ currency._factor;
  final s = currency.decimals == 0
      ? '$whole'
      : '$whole${_style.decimal}${(abs % currency._factor).toString().padLeft(currency.decimals, '0')}';
  return minor < 0 ? '-$s' : s;
}

/// Example amount for input hints and error messages, in the current
/// language style: "12.50" / "12,50" for EUR, "3900" for PKR, "4.500" for KWD.
/// Large amounts leave out a ".00" nobody would type.
String exampleAmount(Currency currency) {
  final m = currency.exampleMinor;
  if (m ~/ currency._factor >= 100 && m % currency._factor == 0) return '${m ~/ currency._factor}';
  return amountToInput(m, currency);
}

/// Parses user input into minor units of [currency]. Accepts European and
/// English styles and ignores symbols: `12,50`, `12.50`, `1.234,50`,
/// `1,234.50`, `1 234,5`, `€ 12`, `¥1,500`. Returns null if invalid.
int? parseAmount(String input, Currency currency) {
  final decimals = currency.decimals;
  var s = input.replaceAll(RegExp(r'[^0-9.,\-]'), '');
  if (s.isEmpty) return null;
  var negative = false;
  if (s.startsWith('-')) {
    negative = true;
    s = s.substring(1);
  }
  if (!RegExp(r'^[0-9.,]+$').hasMatch(s)) return null;

  final lastDot = s.lastIndexOf('.');
  final lastComma = s.lastIndexOf(',');
  String intPart;
  String fracPart = '';

  if (lastDot >= 0 && lastComma >= 0) {
    // Both present: whichever comes last is the decimal separator.
    final decimalIndex = lastDot > lastComma ? lastDot : lastComma;
    intPart = s.substring(0, decimalIndex).replaceAll(RegExp('[.,]'), '');
    fracPart = s.substring(decimalIndex + 1);
  } else if (lastDot >= 0 || lastComma >= 0) {
    final sep = lastDot >= 0 ? '.' : ',';
    final parts = s.split(sep);
    final tail = parts.last;
    final looksDecimal = parts.length == 2 &&
        tail.length <= (decimals == 0 ? 2 : decimals) &&
        // "1.234" is a thousand, unless the currency really has 3 decimals.
        (tail.length < 3 || decimals == 3) &&
        // For whole-number currencies only accept ",00"-style zeros.
        (decimals > 0 || RegExp(r'^0*$').hasMatch(tail));
    if (looksDecimal) {
      intPart = parts.first;
      fracPart = decimals == 0 ? '' : tail;
    } else if (parts.skip(1).every((p) => p.length == 3)) {
      // Thousands grouping only, e.g. "1.234" or "1,234,567".
      intPart = parts.join();
    } else {
      return null;
    }
  } else {
    intPart = s;
  }

  if (intPart.isEmpty) intPart = '0';
  if (fracPart.length > decimals || !RegExp(r'^\d*$').hasMatch(fracPart)) return null;
  if (!RegExp(r'^\d+$').hasMatch(intPart)) return null;

  final minor = int.parse(intPart) * currency._factor + (decimals == 0 ? 0 : int.parse(fracPart.padRight(decimals, '0')));
  return negative ? -minor : minor;
}

/// Sums amounts per currency. Different currencies are never added together.
Map<Currency, int> totalsByCurrency(Iterable<(int cents, Currency currency)> amounts) {
  final totals = <Currency, int>{};
  for (final (cents, currency) in amounts) {
    totals[currency] = (totals[currency] ?? 0) + cents;
  }
  return totals;
}
