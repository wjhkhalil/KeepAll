import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/app_data.dart';
import '../design.dart';
import '../labels.dart';
import '../widgets.dart';
import 'list_detail_screen.dart';

/// Asks for a list name. Returns null if cancelled.
Future<String?> askListName(BuildContext context, {String initial = ''}) async {
  final l = context.l10n;
  final values = await showTextFieldsDialog(
    context,
    title: initial.isEmpty ? l.listNew : l.rename,
    fields: [DialogField(label: l.listNameLabel, initial: initial, requiredMessage: l.listNameRequired)],
  );
  return values?.first;
}

Future<void> deleteListWithUndo(BuildContext context, ShoppingList list) async {
  final data = context.read<AppData>();
  final l = context.l10n;
  if (!await confirmDeleteIfNeeded(context, list.name)) return;
  final removed = await data.deleteList(list.id);
  if (removed == null || !context.mounted) return;
  showMessage(context, l.listDeleted, onUndo: () => data.restoreList(removed.$1, removed.$2));
}

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  Future<void> _create(BuildContext context) async {
    final name = await askListName(context);
    if (name == null || !context.mounted) return;
    final list = await context.read<AppData>().addList(name);
    if (context.mounted) _open(context, list);
  }

  void _open(BuildContext context, ShoppingList list) => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ListDetailScreen(listId: list.id)),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lists = context.watch<AppData>().lists;
    final theme = Theme.of(context);
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(l.listsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: Text(l.listNew),
      ),
      body: lists.isEmpty
          ? FriendlyEmptyState(
              emoji: '🧺',
              color: c.sage,
              title: l.listsEmptyTitle,
              body: l.listsEmptyBody,
              actionLabel: l.listNew,
              onAction: () => _create(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              itemCount: lists.length,
              itemBuilder: (context, i) {
                final list = lists[i];
                final total = list.items.length;
                final done = total - list.remaining;
                final complete = total > 0 && list.remaining == 0;
                final tints = [c.sage, c.lavender, c.peach, c.butter, c.blue];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Dismissible(
                    key: ValueKey('list-${list.id}'),
                    direction: DismissDirection.endToStart,
                    background: SwipeBackground(icon: Icons.delete_rounded, color: c.danger, alignEnd: true),
                    confirmDismiss: (_) async {
                      await deleteListWithUndo(context, list);
                      return false;
                    },
                    child: Semantics(
                      customSemanticsActions: {
                        CustomSemanticsAction(label: l.delete): () => deleteListWithUndo(context, list),
                      },
                      child: SoftCard(
                        onTap: () => _open(context, list),
                        semanticLabel: '${list.name}: ${l.listItemsLeft(list.remaining)}',
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            BounceOnTrue(
                              trigger: complete,
                              child: IconBubble(
                                icon: complete ? Icons.check_rounded : Icons.shopping_basket_rounded,
                                color: tints[i % tints.length],
                                size: 52,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // One line each and an always-present bar keep
                                  // every list card the same height.
                                  Text(list.name,
                                      style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text(
                                    complete ? '${l.listItemsLeft(0)} ✨' : l.listItemsLeft(list.remaining),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(color: c.textMuted),
                                  ),
                                  const SizedBox(height: 10),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(end: total == 0 ? 0 : done / total),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                    builder: (_, v, _) => ExcludeSemantics(child: LinearProgressIndicator(value: v)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right_rounded, color: c.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
