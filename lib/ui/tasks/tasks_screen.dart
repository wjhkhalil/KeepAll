import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_data.dart';
import '../../state/settings.dart';
import '../../state/task_groups.dart';
import '../design.dart';
import '../labels.dart';
import 'task_tile.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.filter});

  /// Selected category, shared with the home screen so its cards can open a
  /// pre-filtered list.
  final ValueNotifier<TaskCategory?> filter;

  String _groupLabel(AppLocalizations l, TaskGroup g) => switch (g) {
    TaskGroup.overdue => l.sectionOverdue,
    TaskGroup.today => l.sectionToday,
    TaskGroup.tomorrow => l.sectionTomorrow,
    TaskGroup.thisWeek => l.sectionThisWeek,
    TaskGroup.later => l.sectionLater,
    TaskGroup.noDate => l.sectionNoDate,
  };

  Widget _pill(AppLocalizations l, AppColors c, TaskGroup g) {
    final (dot, tint) = switch (g) {
      TaskGroup.overdue => (c.danger, c.dangerTint),
      TaskGroup.today => (c.success, c.sage),
      TaskGroup.tomorrow => (c.text, c.blue),
      TaskGroup.thisWeek => (c.text, c.lavender),
      TaskGroup.later => (c.text, c.butter),
      TaskGroup.noDate => (c.textMuted, c.category(TaskCategory.general)),
    };
    return SectionPill(_groupLabel(l, g), dot: dot, tint: tint);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final data = context.watch<AppData>();
    final mode = context.watch<Settings>().mode;
    final theme = Theme.of(context);
    final c = context.colors;

    return ValueListenableBuilder<TaskCategory?>(
      valueListenable: filter,
      builder: (context, selected, _) {
        final all = data.tasks;
        final visible = selected == null ? all : all.where((t) => t.category == selected).toList();
        final groups = groupTasks(visible, data.now);
        final completed = visible.where((t) => t.done).toList()
          ..sort((a, b) => (b.completedAt ?? b.createdAt).compareTo(a.completedAt ?? a.createdAt));

        // Show chips for the mode's main categories plus any category in use.
        final used = all.map((t) => t.category).toSet();
        final chipCategories = categoriesFor(mode)
            .where((c) => categoriesFor(mode).indexOf(c) < 3 || used.contains(c) || c == selected)
            .toList();

        return Scaffold(
          appBar: AppBar(title: Text(l.tasksTitle)),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            tooltip: l.taskNew,
            onPressed: () => openTaskEditor(context, category: selected),
            child: const Icon(Icons.add_rounded, size: 30),
          ),
          body: Column(
            children: [
              if (all.isNotEmpty)
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
                          selected: selected == null,
                          onSelected: (_) => filter.value = null,
                        ),
                      ),
                      for (final c in chipCategories)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            avatar: Icon(taskCategoryIcon(c), size: 18),
                            label: Text(taskCategoryLabel(l, c)),
                            selected: selected == c,
                            onSelected: (_) => filter.value = selected == c ? null : c,
                          ),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: all.isEmpty
                    ? FriendlyEmptyState(
                        emoji: '🌱',
                        title: l.tasksEmptyTitle,
                        body: l.tasksEmptyBody,
                        actionLabel: l.taskNew,
                        onAction: () => openTaskEditor(context, category: selected),
                      )
                    : visible.isEmpty
                    ? FriendlyEmptyState(
                        emoji: '🍃',
                        color: c.blue,
                        title: l.tasksEmptyFiltered,
                        actionLabel: l.taskNew,
                        onAction: () => openTaskEditor(context, category: selected),
                      )
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 120),
                        children: [
                          // Everything done: a little sun instead of an empty list.
                          if (groups.values.every((g) => g.isEmpty))
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                              child: Column(
                                children: [
                                  TinyIllustration('☀️', color: c.butter),
                                  const SizedBox(height: 16),
                                  Text(l.homeAllDone, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
                                  const SizedBox(height: 4),
                                  Text(l.tasksAllDoneBody,
                                      style: theme.textTheme.bodyLarge?.copyWith(color: c.textMuted),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          for (final g in TaskGroup.values)
                            if (groups[g]!.isNotEmpty) ...[
                              _pill(l, c, g),
                              for (final t in groups[g]!) TaskTile(key: ValueKey(t.id), task: t, showCategory: selected == null),
                            ],
                          if (completed.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: SoftCard(
                                padding: EdgeInsets.zero,
                                child: ExpansionTile(
                                  leading: Icon(Icons.task_alt_rounded, color: c.success),
                                  title: Text(l.sectionCompleted(completed.length)),
                                  childrenPadding: const EdgeInsets.only(bottom: 8),
                                  children: [
                                    for (final t in completed)
                                      TaskTile(key: ValueKey(t.id), task: t, showCategory: selected == null),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
