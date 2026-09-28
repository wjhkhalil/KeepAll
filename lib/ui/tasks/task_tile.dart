import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';

import '../../core/dates.dart';
import '../../data/models.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_data.dart';
import '../../state/settings.dart';
import '../design.dart';
import '../labels.dart';
import '../widgets.dart';
import 'task_editor_screen.dart';

/// Human-friendly due text: "Today 14:00", "Tomorrow", "Mon 29/09/2026".
String dueText(AppLocalizations l, Task task, DateTime now) {
  final due = task.dueAt!;
  final days = daysBetween(now, due);
  final day = switch (days) {
    0 => l.sectionToday,
    1 => l.sectionTomorrow,
    _ => '${formatWeekday(due)} ${formatDate(due)}',
  };
  return task.hasTime ? '$day ${formatTime(due)}' : day;
}

Future<void> completeTaskWithUndo(BuildContext context, Task task) async {
  final data = context.read<AppData>();
  final l = context.l10n;
  final previous = await data.completeTask(task.id);
  if (previous == null || !context.mounted) return;
  final updated = data.taskById(task.id);
  final message = updated != null && !updated.done && updated.dueAt != null
      ? l.taskRescheduled(dueText(l, updated, data.now))
      : l.taskCompleted;
  showMessage(context, message, onUndo: () => data.saveTask(previous));
}

Future<void> deleteTaskWithUndo(BuildContext context, Task task) async {
  if (!await confirmDeleteIfNeeded(context, task.title)) return;
  if (context.mounted) await deleteTaskWithUndoConfirmed(context, task);
}

/// Deletes without asking (the caller already confirmed) and offers undo.
Future<void> deleteTaskWithUndoConfirmed(BuildContext context, Task task) async {
  final data = context.read<AppData>();
  final l = context.l10n;
  await data.deleteTask(task.id);
  if (!context.mounted) return;
  showMessage(context, l.taskDeleted, onUndo: () => data.saveTask(task));
}

void openTaskEditor(BuildContext context, {Task? task, TaskCategory? category}) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => TaskEditorScreen(task: task, initialCategory: category),
    fullscreenDialog: task == null,
  ));
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, this.showCategory = true});

  final Task task;
  final bool showCategory;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = context.colors;
    final now = context.read<AppData>().now;
    final overdue = task.isOverdue(now);
    final simple = context.watch<Settings>().mode == UserMode.simple;

    final details = <String>[
      if (showCategory) taskCategoryLabel(l, task.category),
      if (task.dueAt != null) dueText(l, task, now),
    ];

    // Card with a thin category-coloured strip on the left: colour for
    // personality, but the icon and label still carry the meaning.
    final card = Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border, width: c.highContrast ? 2 : 1),
        boxShadow: c.highContrast ? null : [BoxShadow(color: c.shadow, blurRadius: 10, offset: const Offset(0, 3))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => openTaskEditor(context, task: task),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: c.highContrast ? c.border : c.category(task.category)),
                const SizedBox(width: 2),
                Center(
                  child: AnimatedCheck(
                    checked: task.done,
                    label: task.done ? l.taskMarkNotDone : l.taskMarkDone,
                    onChanged: () =>
                        task.done ? context.read<AppData>().reopenTask(task.id) : completeTaskWithUndo(context, task),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Same number of lines on every card so they all
                        // have the same height (two title lines in Simple mode).
                        FixedLinesText(
                          task.title,
                          lines: simple ? 2 : 1,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: task.done ? TextDecoration.lineThrough : null,
                            color: task.done ? c.textMuted : c.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(children: [
                            if (overdue)
                              TextSpan(
                                text: details.isEmpty ? l.taskOverdue : '${l.taskOverdue} · ',
                                style: TextStyle(color: c.danger, fontWeight: FontWeight.w800),
                              ),
                            TextSpan(text: details.isEmpty && !overdue ? l.taskNoDate : details.join(' · ')),
                          ]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (task.repeat != Repeat.none)
                        Icon(Icons.repeat_rounded, size: 18, color: c.textMuted,
                            semanticLabel: '${l.taskRepeats}: ${repeatLabel(l, task.repeat)}'),
                      if (task.remind && !task.done) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.notifications_active_rounded, size: 18, color: c.textMuted, semanticLabel: l.taskRemind),
                      ],
                      const SizedBox(width: 8),
                      IconBubble(icon: taskCategoryIcon(task.category), color: c.category(task.category), size: 34),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Dismissible(
        key: ValueKey('task-${task.id}'),
        direction: task.done ? DismissDirection.endToStart : DismissDirection.horizontal,
        background: SwipeBackground(icon: Icons.check_rounded, color: c.success, alignEnd: false),
        secondaryBackground: SwipeBackground(icon: Icons.delete_rounded, color: c.danger, alignEnd: true),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await completeTaskWithUndo(context, task);
          } else {
            await deleteTaskWithUndo(context, task);
          }
          // The list rebuilds from data; never let Dismissible remove the row itself.
          return false;
        },
        child: Semantics(
          customSemanticsActions: {
            if (!task.done) CustomSemanticsAction(label: l.taskMarkDone): () => completeTaskWithUndo(context, task),
            CustomSemanticsAction(label: l.delete): () => deleteTaskWithUndo(context, task),
          },
          child: card,
        ),
      ),
    );
  }
}
