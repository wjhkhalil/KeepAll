import 'package:flutter/material.dart';

import '../core/currency_data.g.dart';
import '../core/money.dart';
import '../data/models.dart';
import 'design.dart';
import 'labels.dart';

/// Opens a searchable list of every currency. Returns the chosen one, or
/// null if the user backs out.
Future<Currency?> pickCurrency(BuildContext context, {Currency? selected}) =>
    Navigator.of(context).push<Currency>(MaterialPageRoute(
      builder: (_) => CurrencyPickerScreen(selected: selected),
      fullscreenDialog: true,
    ));

class CurrencyPickerScreen extends StatefulWidget {
  const CurrencyPickerScreen({super.key, this.selected});

  final Currency? selected;

  @override
  State<CurrencyPickerScreen> createState() => _CurrencyPickerScreenState();
}

class _CurrencyPickerScreenState extends State<CurrencyPickerScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final lang = Localizations.localeOf(context).languageCode;

    String sortName(Currency x) => x.name(lang).toLowerCase();
    final results = Currency.all.where((x) => x.matches(_query, lang)).toList()
      ..sort((a, b) => sortName(a).compareTo(sortName(b)));

    final popular = [
      if (widget.selected != null) widget.selected!,
      ...Currency.popular.where((x) => x != widget.selected),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsCurrency)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              autofocus: false,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: l.currencySearchHint,
                labelText: l.currencySearchHint,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? FriendlyEmptyState(emoji: '🪙', color: c.butter, title: l.currencyNoResults)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    children: [
                      if (_query.trim().isEmpty) ...[
                        SectionPill(l.currencyPopular, dot: c.success, tint: c.sage),
                        _group(context, popular, lang),
                        SectionPill(l.currencyAll, dot: c.textMuted, tint: c.category(TaskCategory.general)),
                      ],
                      _group(context, results, lang),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _group(BuildContext context, List<Currency> items, String lang) {
    final c = context.colors;
    final theme = Theme.of(context);
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          for (final x in items)
            ListTile(
              key: ValueKey('currency-${x.code}'),
              selected: x == widget.selected,
              selectedColor: c.text,
              leading: _SymbolBubble(currency: x),
              title: Text(x.name(lang), maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                [x.code, ..._countries(x, lang)].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: x == widget.selected ? Icon(Icons.check_circle_rounded, color: c.primary) : null,
              titleTextStyle: theme.textTheme.titleMedium,
              onTap: () => Navigator.pop(context, x),
            ),
        ],
      ),
    );
  }

  /// A few country names to help people recognise the currency.
  List<String> _countries(Currency x, String lang) {
    final names = [for (final code in x.countries) countryNames[lang]?[code] ?? code]..sort();
    return names.length > 3 ? [...names.take(3), '…'] : names;
  }
}

class _SymbolBubble extends StatelessWidget {
  const _SymbolBubble({required this.currency});

  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Long symbols ("CHF", "F CFA") shrink to fit the circle.
    return ExcludeSemantics(
      child: Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: c.butter,
          shape: BoxShape.circle,
          border: c.highContrast ? Border.all(color: c.border, width: 1.5) : null,
        ),
        child: FittedBox(
          child: Text(
            currency.symbol,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
