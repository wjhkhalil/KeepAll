import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/dates.dart';
import '../core/money.dart';
import '../data/models.dart';
import '../l10n/app_localizations.dart';
import '../state/app_data.dart';
import '../state/settings.dart';
import 'design.dart';
import 'documents/documents_screen.dart';
import 'labels.dart';
import 'receipts/receipts_screen.dart';
import 'tasks/task_tile.dart';
import 'widgets.dart';

enum AppTab { home, tasks, lists, receipts, documents, more }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenTab, required this.onOpenTasks});

  final void Function(AppTab tab) onOpenTab;

  /// Opens the Tasks tab filtered to [category] (null = all).
  final void Function(TaskCategory? category) onOpenTasks;

  (String, String) _greeting(AppLocalizations l, DateTime now, String name) {
    final (g, emoji) = now.hour < 12
        ? (l.greetingMorning, '☀️')
        : now.hour < 18
        ? (l.greetingAfternoon, '🌤️')
        : (l.greetingEvening, '🌙');
    return (name.isEmpty ? g : l.greetingWithName(g, name), emoji);
  }

  String _nextText(AppLocalizations l, List<Task> tasks, DateTime now) {
    final upcoming = tasks.where((t) => t.dueAt != null).toList();
    if (upcoming.isEmpty) return l.homeNothingPlanned;
    return l.homeNext(dueText(l, upcoming.first, now));
  }

  List<_CardData> _cards(BuildContext context, AppData data, Settings settings) {
    final l = context.l10n;
    final c = context.colors;
    final now = data.now;
    final shopping = _CardData(
      icon: Icons.shopping_basket_rounded,
      tint: c.sage,
      title: l.homeShopping,
      value: l.homeShoppingCount(data.shoppingItemsRemaining),
      onTap: () => onOpenTab(AppTab.lists),
    );
    final expiring = data.expiringWithin(expiringSoonDays).length;
    final documents = _CardData(
      icon: Icons.folder_rounded,
      tint: c.blue,
      title: l.homeDocuments,
      value: expiring > 0 ? l.homeDocsExpiring(expiring) : l.homeDocsCount(data.documents.length),
      onTap: () => onOpenTab(AppTab.documents),
      alert: expiring > 0,
    );
    final monthTotals = totalsByCurrency(data.receiptsInMonth(now).map((r) => (r.amountCents, r.currency)));

    switch (settings.mode) {
      case UserMode.student:
        final exam = data.nextExam;
        return [
          _CardData(
            icon: Icons.menu_book_rounded,
            tint: c.category(TaskCategory.study),
            title: l.homeHomework,
            value: l.homeOpen(data.openInCategory(TaskCategory.study).length),
            onTap: () => onOpenTasks(TaskCategory.study),
          ),
          _CardData(
            icon: Icons.school_rounded,
            tint: c.category(TaskCategory.exam),
            title: l.homeNextExam,
            value: exam == null ? l.homeNoExam : '${exam.title}\n${l.examCountdown(daysBetween(now, exam.dueAt!))}',
            onTap: () => onOpenTasks(TaskCategory.exam),
          ),
          shopping,
          _CardData(
            icon: Icons.savings_rounded,
            tint: c.butter,
            title: l.homeSpending,
            value: monthTotals.isEmpty ? l.homeSpendingNone : formatTotals(monthTotals),
            onTap: () => onOpenTab(AppTab.receipts),
          ),
        ];
      case UserMode.everyday:
        return [
          shopping,
          _CardData(
            icon: Icons.receipt_long_rounded,
            tint: c.butter,
            title: l.homeReceipts,
            value: l.homeReceiptsCount(data.receipts.length),
            onTap: () => onOpenTab(AppTab.receipts),
          ),
          documents,
          _CardData(
            icon: Icons.home_rounded,
            tint: c.category(TaskCategory.home),
            title: l.homeHomeTasks,
            value: l.homeDueThisWeek(data.dueThisWeek(TaskCategory.home)),
            onTap: () => onOpenTasks(TaskCategory.home),
          ),
          _CardData(
            icon: Icons.autorenew_rounded,
            tint: c.lavender,
            title: l.homeSubscriptions,
            value: l.homeActive(data.openInCategory(TaskCategory.subscription).length),
            onTap: () => onOpenTasks(TaskCategory.subscription),
          ),
          _CardData(
            icon: Icons.receipt_rounded,
            tint: c.peach,
            title: l.homeBills,
            value: l.homeDueThisWeek(data.dueThisWeek(TaskCategory.bill) + data.dueThisWeek(TaskCategory.document)),
            onTap: () => onOpenTasks(TaskCategory.bill),
          ),
        ];
      case UserMode.simple:
        return [
          _CardData(
            icon: Icons.medication_rounded,
            tint: c.category(TaskCategory.medicine),
            title: l.homeMedicine,
            value: _nextText(l, data.openInCategory(TaskCategory.medicine), now),
            onTap: () => onOpenTasks(TaskCategory.medicine),
          ),
          _CardData(
            icon: Icons.event_rounded,
            tint: c.category(TaskCategory.appointment),
            title: l.homeAppointments,
            value: _nextText(l, data.openInCategory(TaskCategory.appointment), now),
            onTap: () => onOpenTasks(TaskCategory.appointment),
          ),
          shopping,
          documents,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();
    final settings = context.watch<Settings>();
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = context.colors;
    final cards = _cards(context, data, settings);
    final simple = settings.mode == UserMode.simple;
    final (greeting, emoji) = _greeting(l, data.now, settings.name);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            // Greeting header with a tiny illustration (left out in Simple mode).
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(header: true, child: Text('$greeting $emoji', style: theme.textTheme.headlineSmall)),
                      const SizedBox(height: 6),
                      Text(formatWeekdayLong(data.now), style: theme.textTheme.titleMedium?.copyWith(color: c.textMuted)),
                      Text(formatLongDate(data.now), style: theme.textTheme.bodyLarge?.copyWith(color: c.textMuted)),
                    ],
                  ),
                ),
                if (!simple) ...[
                  const SizedBox(width: 12),
                  TinyIllustration(data.now.hour < 18 ? '☁️' : '🌙', color: c.blue, size: 72),
                ],
              ],
            ),
            const SizedBox(height: 20),
            if (simple) ...[
              _EmergencyCard(settings: settings, onSetUp: () => onOpenTab(AppTab.more)),
              const SizedBox(height: 14),
            ],
            _YourDayCard(onSeeAll: () => onOpenTasks(null), simple: simple),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                // One column in Simple mode or when text is large relative to width.
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                final columns = simple || constraints.maxWidth / textScale < 340 ? 1 : 2;
                const spacing = 14.0;
                final width = (constraints.maxWidth - spacing * (columns - 1)) / columns;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final card in cards)
                      SizedBox(width: width, child: simple ? _SimpleCard(data: card) : _SummaryCard(data: card)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// "☀️ Your day" – the most important card: what needs doing today.
class _YourDayCard extends StatelessWidget {
  const _YourDayCard({required this.onSeeAll, required this.simple});

  final VoidCallback onSeeAll;
  final bool simple;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = context.colors;
    final due = context.watch<AppData>().dueTodayOrOverdue;
    final shown = due.take(simple ? 3 : 4).toList();

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBubble(icon: Icons.wb_sunny_rounded, color: c.butter, size: 40),
              const SizedBox(width: 12),
              Expanded(child: Semantics(header: true, child: Text(l.homeYourDay, style: theme.textTheme.titleLarge))),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              due.isEmpty ? '${l.homeAllDone} ✨' : l.homeYourDayCount(due.length),
              style: theme.textTheme.titleMedium?.copyWith(color: c.textMuted),
            ),
          ),
          if (shown.isNotEmpty) ...[
            const SizedBox(height: 4),
            for (final t in shown) _DayTaskRow(key: ValueKey(t.id), task: t),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onSeeAll,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(l.homeSeeAll, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTaskRow extends StatelessWidget {
  const _DayTaskRow({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final theme = Theme.of(context);
    final now = context.read<AppData>().now;
    final overdue = task.isOverdue(now);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => openTaskEditor(context, task: task),
      child: Row(
        children: [
          AnimatedCheck(checked: task.done, label: l.taskMarkDone, onChanged: () => completeTaskWithUndo(context, task)),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(task.title, style: theme.textTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
          if (task.dueAt != null && (task.hasTime || overdue))
            // May shrink with "…" at very large text rather than overflow.
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 4),
                child: Text(
                  overdue ? l.taskOverdue : formatTime(task.dueAt!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(color: overdue ? c.danger : c.textMuted),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CardData {
  const _CardData({
    required this.icon,
    required this.tint,
    required this.title,
    required this.value,
    required this.onTap,
    this.alert = false,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String value;
  final VoidCallback onTap;

  /// Needs attention, e.g. a document about to expire.
  final bool alert;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _CardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.colors;
    return SoftCard(
      onTap: data.onTap,
      semanticLabel: '${data.title}: ${data.value}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBubble(icon: data.icon, color: data.tint),
              const Spacer(),
              if (data.alert)
                Container(width: 10, height: 10, decoration: BoxDecoration(color: c.warning, shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 12),
          // Fixed line counts keep every card in the grid the same height.
          Text(data.title, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          FixedLinesText(
            data.value,
            lines: 2,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: data.alert ? c.warning : c.textMuted,
              fontWeight: data.alert ? FontWeight.w800 : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple mode: fewer decorations, big text and one obvious button.
class _SimpleCard extends StatelessWidget {
  const _SimpleCard({required this.data});

  final _CardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.colors;
    final l = context.l10n;
    return SoftCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconBubble(icon: data.icon, color: data.tint, size: 48),
              const SizedBox(width: 14),
              // Two lines so long words at large text sizes aren't cut off.
              Expanded(child: FixedLinesText(data.title, lines: 2, center: true, style: theme.textTheme.titleLarge)),
            ],
          ),
          const SizedBox(height: 12),
          FixedLinesText(
            data.value,
            lines: 2,
            style: theme.textTheme.titleMedium?.copyWith(
              color: data.alert ? c.warning : c.text,
              fontWeight: data.alert ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: data.onTap,
            child: Semantics(
              label: '${l.homeView}: ${data.title}',
              excludeSemantics: true,
              child: Text(l.homeView.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard({required this.settings, required this.onSetUp});

  final Settings settings;
  final VoidCallback onSetUp;

  Future<void> _call(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: settings.emergencyPhone.replaceAll(RegExp(r'[^0-9+]'), ''));
    final ok = await launchUrl(uri).catchError((_) => false);
    if (!ok && context.mounted) showMessage(context, context.l10n.callFailed);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = context.colors;
    if (!settings.hasEmergencyContact) {
      return SoftCard(
        onTap: onSetUp,
        semanticLabel: '${l.homeEmergency}: ${l.homeEmergencyNotSet}',
        child: Row(
          children: [
            IconBubble(icon: Icons.sos_rounded, color: c.dangerTint),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.homeEmergency, style: theme.textTheme.titleMedium),
                  Text(l.homeEmergencyNotSet, style: theme.textTheme.bodyMedium?.copyWith(color: c.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      );
    }
    final name = settings.emergencyName.isEmpty ? settings.emergencyPhone : settings.emergencyName;
    return SoftCard(
      tint: c.dangerTint,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.homeEmergency, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: c.danger,
              foregroundColor: c.highContrast ? c.background : Colors.white,
              minimumSize: const Size.fromHeight(64),
              textStyle: theme.textTheme.titleLarge,
            ),
            onPressed: () => _call(context),
            icon: const Icon(Icons.phone_rounded, size: 28),
            label: Text(l.homeCall(name)),
          ),
        ],
      ),
    );
  }
}
