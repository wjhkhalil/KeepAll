import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models.dart';
import '../../state/app_data.dart';
import '../design.dart';
import '../labels.dart';
import '../widgets.dart';
import 'lists_screen.dart';

enum _ListAction { rename, clearChecked, delete }

class ListDetailScreen extends StatefulWidget {
  const ListDetailScreen({super.key, required this.listId});

  final String listId;

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  final _input = TextEditingController();
  final _focus = FocusNode();
  final _justAdded = <String>{};

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    final name = _input.text.trim();
    if (name.isEmpty) return;
    _input.clear();
    final data = context.read<AppData>();
    await data.addItem(widget.listId, name);
    final added = data.listById(widget.listId)?.items.lastOrNull;
    if (added != null && mounted) setState(() => _justAdded.add(added.id));
    // Keep the keyboard open for fast entry of several items.
    _focus.requestFocus();
  }

  Future<void> _removeItem(ShoppingItem item) async {
    final data = context.read<AppData>();
    final l = context.l10n;
    if (!await confirmDeleteIfNeeded(context, item.name)) return;
    final removed = await data.removeItem(widget.listId, item.id);
    if (removed == null || !mounted) return;
    showMessage(context, l.itemRemoved, onUndo: () => data.restoreItem(widget.listId, removed.$1, removed.$2));
  }

  Future<void> _editItem(ShoppingItem item) async {
    final l = context.l10n;
    final values = await showTextFieldsDialog(
      context,
      title: l.itemEdit,
      fields: [
        DialogField(label: l.itemNameLabel, initial: item.name, requiredMessage: l.listNameRequired),
        DialogField(label: l.itemQuantityLabel, initial: item.quantity),
      ],
    );
    if (values == null || !mounted) return;
    await context.read<AppData>().updateItem(widget.listId, item.copyWith(name: values[0], quantity: values[1]));
  }

  /// Shares the list as plain text (WhatsApp, SMS, email...). Unticked items
  /// come first so the recipient sees what's still needed.
  Future<void> _share(ShoppingList list) async {
    String line(ShoppingItem i) => '${i.checked ? '✓' : '☐'} ${i.name}${i.quantity.isEmpty ? '' : ' (${i.quantity})'}';
    final text = [
      list.name,
      '',
      ...list.items.where((i) => !i.checked).map(line),
      ...list.items.where((i) => i.checked).map(line),
    ].join('\n');
    try {
      await SharePlus.instance.share(ShareParams(text: text, subject: list.name));
    } catch (_) {
      // No share sheet (e.g. some desktops): copy instead.
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) showMessage(context, context.l10n.listCopied);
    }
  }

  Future<void> _onMenu(_ListAction action, ShoppingList list) async {
    final data = context.read<AppData>();
    final l = context.l10n;
    switch (action) {
      case _ListAction.rename:
        final name = await askListName(context, initial: list.name);
        if (name != null) await data.saveList(list.copyWith(name: name));
      case _ListAction.clearChecked:
        final before = await data.clearChecked(list.id);
        if (before != null && mounted) {
          showMessage(context, l.clearedChecked, onUndo: () => data.saveList(before));
        }
      case _ListAction.delete:
        final navigator = Navigator.of(context);
        final outer = navigator.context;
        if (!await confirmDeleteIfNeeded(context, list.name)) return;
        final removed = await data.deleteList(list.id);
        navigator.pop();
        if (removed != null && outer.mounted) {
          showMessage(outer, l.listDeleted, onUndo: () => data.restoreList(removed.$1, removed.$2));
        }
    }
  }

  Widget _itemRow(BuildContext context, ShoppingList list, ShoppingItem item) {
    final l = context.l10n;
    final c = context.colors;
    Widget row = Dismissible(
      key: ValueKey('item-${item.id}'),
      direction: DismissDirection.endToStart,
      background: SwipeBackground(icon: Icons.delete_rounded, color: c.danger, alignEnd: true),
      confirmDismiss: (_) async {
        await _removeItem(item);
        return false;
      },
      child: Semantics(
        customSemanticsActions: {
          CustomSemanticsAction(label: l.edit): () => _editItem(item),
          CustomSemanticsAction(label: l.delete): () => _removeItem(item),
        },
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: item.checked,
          onChanged: (_) => context.read<AppData>().toggleItem(list.id, item.id),
          // Quantity sits in a small pill on the same line, so every row
          // has the same height with or without one.
          title: Row(
            children: [
              Flexible(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: item.checked ? TextStyle(decoration: TextDecoration.lineThrough, color: c.textMuted) : null,
                ),
              ),
              if (item.quantity.isNotEmpty) ...[
                const SizedBox(width: 8),
                Flexible(
                  flex: 0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: StatusPill(label: item.quantity, color: c.text, tint: c.butter),
                  ),
                ),
              ],
            ],
          ),
          secondary: IconButton(
            icon: Icon(Icons.edit_rounded, color: c.textMuted),
            tooltip: l.itemEdit,
            onPressed: () => _editItem(item),
          ),
        ),
      ),
    );
    // New items slide in gently.
    if (_justAdded.contains(item.id)) row = SlideIn(key: ValueKey('in-${item.id}'), child: row);
    return row;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final list = context.watch<AppData>().listById(widget.listId);
    final theme = Theme.of(context);

    if (list == null) {
      // Deleted (e.g. from another screen); show nothing while we pop.
      return const Scaffold();
    }

    // Unticked items first, ticked items sink to the bottom.
    final items = [...list.items.where((i) => !i.checked), ...list.items.where((i) => i.checked)];
    final hasChecked = list.items.any((i) => i.checked);
    final complete = list.items.isNotEmpty && !list.items.any((i) => !i.checked);

    return Scaffold(
      appBar: AppBar(
        title: Text(list.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: l.listShare,
            onPressed: list.items.isEmpty ? null : () => _share(list),
          ),
          PopupMenuButton<_ListAction>(
            tooltip: l.listOptions,
            onSelected: (a) => _onMenu(a, list),
            itemBuilder: (_) => [
              PopupMenuItem(value: _ListAction.rename, child: Text(l.rename)),
              PopupMenuItem(value: _ListAction.clearChecked, enabled: hasChecked, child: Text(l.clearChecked)),
              PopupMenuItem(value: _ListAction.delete, child: Text(l.delete)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? FriendlyEmptyState(emoji: '🧺', color: c.sage, title: l.listEmptyItems)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    children: [
                      // Tiny celebration when everything is ticked.
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        child: complete
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SoftCard(
                                  tint: c.sage,
                                  child: Row(
                                    children: [
                                      BounceOnTrue(
                                        trigger: complete,
                                        child: const TinyIllustration('🧺', size: 52),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text('${l.listItemsLeft(0)} ✨', style: theme.textTheme.titleMedium),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                      SoftCard(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            for (final item in items) _itemRow(context, list, item),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      focusNode: _focus,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: l.itemAddHint,
                        labelText: l.itemAddHint,
                        prefixIcon: const Icon(Icons.add_shopping_cart_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: c.border, width: c.highContrast ? 2 : 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: c.primary, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => _addItem(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    icon: const Icon(Icons.add_rounded),
                    tooltip: l.itemAdd,
                    iconSize: 30,
                    style: IconButton.styleFrom(minimumSize: const Size(56, 56)),
                    onPressed: _addItem,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
