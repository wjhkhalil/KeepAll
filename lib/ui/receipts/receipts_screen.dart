import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/models.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_data.dart';
import '../../state/settings.dart';
import '../design.dart';
import '../labels.dart';
import '../widgets.dart';
import 'receipt_editor_screen.dart';

void openReceiptEditor(BuildContext context, {Receipt? receipt}) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => ReceiptEditorScreen(receipt: receipt),
    fullscreenDialog: receipt == null,
  ));
}

/// Deletes a receipt, offering undo. The photo is only removed from disk
/// once the undo window has passed.
Future<void> deleteReceiptWithUndo(BuildContext context, Receipt receipt, {bool confirmed = false}) async {
  final data = context.read<AppData>();
  final l = context.l10n;
  if (!confirmed && !await confirmDeleteIfNeeded(context, receipt.merchant)) return;
  final removed = await data.deleteReceipt(receipt.id);
  if (removed == null || !context.mounted) return;
  var undone = false;
  final controller = showMessage(context, l.receiptDeleted, onUndo: () {
    undone = true;
    data.restoreReceipt(removed);
  });
  controller.closed.then((_) {
    if (!undone) data.purgeReceiptImage(removed);
  });
}

/// "€12.50 · CHF 30.00" – each currency totalled separately.
String formatTotals(Map<Currency, int> totals) =>
    totals.entries.map((e) => formatMoney(e.value, e.key)).join(' · ');

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final _search = TextEditingController();
  String _query = '';
  ReceiptCategory? _category;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(AppLocalizations l, Receipt r) {
    if (_category != null && r.category != _category) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return r.merchant.toLowerCase().contains(q) ||
        r.note.toLowerCase().contains(q) ||
        receiptCategoryLabel(l, r.category).toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final data = context.watch<AppData>();
    final theme = Theme.of(context);
    final c = context.colors;
    final all = data.receiptsByDate;
    final visible = all.where((r) => _matches(l, r)).toList();
    final monthTotals = totalsByCurrency(
      data.receiptsInMonth(data.now).map((r) => (r.amountCents, r.currency)),
    );
    final usedCategories = all.map((r) => r.category).toSet();

    // Group by month; each month's receipts sit together in one card.
    final byMonth = <String, List<Receipt>>{};
    for (final r in visible) {
      byMonth.putIfAbsent(formatMonthYear(r.date), () => []).add(r);
    }
    final children = <Widget>[
      for (final e in byMonth.entries) ...[
        SectionPill(e.key, dot: c.textMuted, tint: c.category(TaskCategory.general)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SoftCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: [for (final r in e.value) _ReceiptTile(receipt: r)]),
          ),
        ),
      ],
    ];
    final monthCount = data.receiptsInMonth(data.now).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Settings>().mode == UserMode.student ? l.spendingTitle : l.receiptsTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => openReceiptEditor(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.receiptNew),
      ),
      body: all.isEmpty
          ? FriendlyEmptyState(
              emoji: '👛',
              color: c.butter,
              title: l.receiptsEmptyTitle,
              body: l.receiptsEmptyBody,
              actionLabel: l.receiptNew,
              onAction: () => openReceiptEditor(context),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                // Mature summary: this month's spending in a soft tinted card.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: SoftCard(
                    tint: c.blue,
                    padding: const EdgeInsets.all(20),
                    child: Semantics(
                      container: true,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.receiptMonthSpending(formatMonth(data.now)), style: theme.textTheme.titleMedium),
                                const SizedBox(height: 6),
                                Text(
                                  monthTotals.isEmpty
                                      ? formatMoney(0, context.watch<Settings>().currency)
                                      : formatTotals(monthTotals),
                                  style: theme.textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(l.receiptCount(monthCount), style: theme.textTheme.bodyMedium?.copyWith(color: c.textMuted)),
                              ],
                            ),
                          ),
                          IconBubble(icon: Icons.account_balance_wallet_rounded, color: c.card, size: 52),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: l.receiptSearchHint,
                      labelText: l.receiptSearchHint,
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: l.close,
                              onPressed: () => setState(() {
                                _search.clear();
                                _query = '';
                              }),
                            ),
                    ),
                    onChanged: (v) => setState(() => _query = v.trim()),
                  ),
                ),
                if (usedCategories.length > 1)
                  SizedBox(
                    height: 56,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(l.all),
                            selected: _category == null,
                            onSelected: (_) => setState(() => _category = null),
                          ),
                        ),
                        for (final c in ReceiptCategory.values.where(usedCategories.contains))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(receiptCategoryLabel(l, c)),
                              selected: _category == c,
                              onSelected: (_) => setState(() => _category = _category == c ? null : c),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(l.receiptNoResults, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
                  ),
                ...children,
              ],
            ),
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final data = context.read<AppData>();
    final image = data.imageFor(receipt);
    final warranty = receipt.warrantyUntil;

    final c = context.colors;
    final subtitle = [
      formatDayMonth(receipt.date),
      receiptCategoryLabel(l, receipt.category),
      if (warranty != null)
        warranty.isBefore(dateOnly(data.now)) ? l.receiptWarrantyExpired : l.receiptWarrantyUntil(formatDate(warranty)),
    ].join(' · ');

    return Dismissible(
      key: ValueKey('receipt-${receipt.id}'),
      direction: DismissDirection.endToStart,
      background: SwipeBackground(icon: Icons.delete_rounded, color: c.danger, alignEnd: true),
      confirmDismiss: (_) async {
        await deleteReceiptWithUndo(context, receipt);
        return false;
      },
      child: Semantics(
        customSemanticsActions: {
          CustomSemanticsAction(label: l.delete): () => deleteReceiptWithUndo(context, receipt),
        },
        child: InkWell(
          onTap: () => openReceiptEditor(context, receipt: receipt),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconBubble(icon: receiptCategoryIcon(receipt.category), color: receiptCategoryTint(c, receipt.category)),
                    if (image != null)
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(color: c.card, shape: BoxShape.circle),
                          child: Icon(Icons.photo_rounded, size: 14, color: c.textMuted,
                              semanticLabel: l.receiptPhoto(receipt.merchant)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(receipt.merchant, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(color: c.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Amounts can be long ("12 345,67 PLN"); never let them take the whole row.
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatMoney(receipt.amountCents, receipt.currency),
                      maxLines: 1,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
