import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';

import '../../core/dates.dart';
import '../../data/models.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_data.dart';
import '../design.dart';
import '../labels.dart';
import '../widgets.dart';
import 'document_editor_screen.dart';

/// Documents expiring within this many days are highlighted.
const expiringSoonDays = 30;

void openDocumentEditor(BuildContext context, {Document? document}) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => DocumentEditorScreen(document: document),
    fullscreenDialog: document == null,
  ));
}

/// "Expired", "Expires in 12 days", "Valid until 01/03/2030" or "No expiry date".
String documentStatus(AppLocalizations l, Document d, DateTime now) {
  final left = d.daysLeft(now);
  if (left == null) return l.docNoExpiry;
  if (left < 0) return l.docExpired;
  if (left <= expiringSoonDays) return l.docExpiresIn(left);
  return l.docValidUntil(formatDate(d.expiresAt!));
}

Future<void> deleteDocumentWithUndo(BuildContext context, Document doc, {bool confirmed = false}) async {
  final data = context.read<AppData>();
  final l = context.l10n;
  if (!confirmed && !await confirmDeleteIfNeeded(context, doc.title)) return;
  final removed = await data.deleteDocument(doc.id);
  if (removed == null || !context.mounted) return;
  var undone = false;
  final controller = showMessage(context, l.docDeleted, onUndo: () {
    undone = true;
    data.saveDocument(removed);
  });
  controller.closed.then((_) {
    if (!undone && removed.imageFile != null) data.deleteImageIfUnused(removed.imageFile!);
  });
}

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final data = context.watch<AppData>();
    final docs = data.documentsByExpiry;
    final theme = Theme.of(context);
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(l.docsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => openDocumentEditor(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.docNew),
      ),
      body: docs.isEmpty
          ? FriendlyEmptyState(
              emoji: '📁',
              color: c.blue,
              title: l.docsEmptyTitle,
              body: l.docsEmptyBody,
              actionLabel: l.docNew,
              onAction: () => openDocumentEditor(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final d = docs[i];
                final left = d.daysLeft(data.now);
                final expired = left != null && left < 0;
                final soon = left != null && !expired && left <= expiringSoonDays;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Dismissible(
                    key: ValueKey('doc-${d.id}'),
                    direction: DismissDirection.endToStart,
                    background: SwipeBackground(icon: Icons.delete_rounded, color: c.danger, alignEnd: true),
                    confirmDismiss: (_) async {
                      await deleteDocumentWithUndo(context, d);
                      return false;
                    },
                    child: Semantics(
                      customSemanticsActions: {
                        CustomSemanticsAction(label: l.delete): () => deleteDocumentWithUndo(context, d),
                      },
                      child: SoftCard(
                        onTap: () => openDocumentEditor(context, document: d),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            IconBubble(icon: documentTypeIcon(d.type), color: documentTypeTint(c, d.type), size: 50),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name, type and a status pill on every card, so all
                                  // cards are the same height. Only the pill is coloured.
                                  Text(d.title,
                                      style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text(
                                    documentTypeLabel(l, d.type),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(color: c.textMuted),
                                  ),
                                  const SizedBox(height: 8),
                                  StatusPill(
                                    label: documentStatus(l, d, data.now),
                                    color: expired
                                        ? c.danger
                                        : soon
                                        ? c.warning
                                        : left == null
                                        ? c.textMuted
                                        : c.success,
                                    tint: expired
                                        ? c.dangerTint
                                        : soon
                                        ? c.warningTint
                                        : left == null
                                        ? c.category(TaskCategory.general)
                                        : c.sage,
                                  ),
                                ],
                              ),
                            ),
                            if (d.remindDaysBefore > 0 && d.expiresAt != null)
                              Icon(Icons.notifications_active_rounded, size: 20, color: c.textMuted, semanticLabel: l.taskRemind),
                            const SizedBox(width: 4),
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
