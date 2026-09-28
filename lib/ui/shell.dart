import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../services/reminder_scheduler.dart';
import '../state/app_data.dart';
import '../state/settings.dart';
import 'design.dart';
import 'documents/document_editor_screen.dart';
import 'documents/documents_screen.dart';
import 'home_screen.dart';
import 'labels.dart';
import 'lists/lists_screen.dart';
import 'more_screen.dart';
import 'receipts/receipts_screen.dart';
import 'tasks/task_editor_screen.dart';
import 'tasks/tasks_screen.dart';
import 'widgets.dart';

/// Tabs in the bottom bar for each mode. Simple mode keeps just three so
/// navigation stays obvious; the other screens open from Home and More.
List<AppTab> tabsFor(UserMode mode) => switch (mode) {
  UserMode.simple => const [AppTab.home, AppTab.tasks, AppTab.more],
  _ => const [AppTab.home, AppTab.tasks, AppTab.lists, AppTab.receipts, AppTab.more],
};

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  AppTab _tab = AppTab.home;
  final _taskFilter = ValueNotifier<TaskCategory?>(null);
  StreamSubscription<ReminderResponse>? _responses;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final data = context.read<AppData>();
    _responses = data.scheduler.responses.listen(_onReminder);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final launch = await data.scheduler.launchResponse();
      if (launch != null) await _onReminder(launch);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _responses?.cancel();
    _taskFilter.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh "today"/"overdue" when the app comes back after midnight etc.
    if (state == AppLifecycleState.resumed && mounted) setState(() {});
  }

  Future<void> _onReminder(ReminderResponse response) async {
    final data = context.read<AppData>();
    final l = context.l10n;
    final target = await data.handleReminderResponse(response);
    if (!mounted) return;
    if (response.action == ReminderScheduler.actionSnooze) {
      showMessage(context, l.taskSnoozed);
      return;
    }
    if (target == null) return;
    final navigator = Navigator.of(context)..popUntil((r) => r.isFirst);
    if (target.isDocument) {
      final doc = data.documentById(target.id);
      if (doc != null) navigator.push(MaterialPageRoute<void>(builder: (_) => DocumentEditorScreen(document: doc)));
      return;
    }
    final task = data.taskById(target.id);
    if (task == null) {
      showMessage(context, l.taskNotFound);
      return;
    }
    setState(() => _tab = AppTab.tasks);
    navigator.push(MaterialPageRoute<void>(builder: (_) => TaskEditorScreen(task: task)));
  }

  /// Switches to [tab] if it is in the bottom bar, otherwise opens it as a page.
  void _open(AppTab tab) {
    final tabs = tabsFor(context.read<Settings>().mode);
    if (tabs.contains(tab)) {
      setState(() => _tab = tab);
      return;
    }
    final Widget page = switch (tab) {
      AppTab.lists => const ListsScreen(),
      AppTab.receipts => const ReceiptsScreen(),
      AppTab.documents => const DocumentsScreen(),
      _ => const SizedBox.shrink(),
    };
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  void _openTasks(TaskCategory? category) {
    _taskFilter.value = category;
    setState(() => _tab = AppTab.tasks);
  }

  Widget _page(AppTab tab) => switch (tab) {
    AppTab.home => HomeScreen(onOpenTab: _open, onOpenTasks: _openTasks),
    AppTab.tasks => TasksScreen(filter: _taskFilter),
    AppTab.lists => const ListsScreen(),
    AppTab.receipts => const ReceiptsScreen(),
    AppTab.documents => const DocumentsScreen(),
    AppTab.more => MoreScreen(onOpen: _open),
  };

  PillNavItem _navItem(AppTab tab, UserMode mode) {
    final l = context.l10n;
    return switch (tab) {
      AppTab.home => PillNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: l.navHome),
      AppTab.tasks => PillNavItem(icon: Icons.check_circle_outline_rounded, selectedIcon: Icons.check_circle_rounded, label: l.navTasks),
      AppTab.lists => PillNavItem(icon: Icons.shopping_cart_outlined, selectedIcon: Icons.shopping_cart_rounded, label: l.navLists),
      AppTab.receipts => PillNavItem(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        label: mode == UserMode.student ? l.navSpending : l.navReceipts,
      ),
      AppTab.documents => PillNavItem(icon: Icons.folder_outlined, selectedIcon: Icons.folder_rounded, label: l.docsTitle),
      AppTab.more => PillNavItem(icon: Icons.more_horiz_rounded, selectedIcon: Icons.more_horiz_rounded, label: l.navMore),
    };
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();
    final mode = settings.mode;
    final tabs = tabsFor(mode);
    // After a mode change the current tab may no longer be in the bar.
    final current = tabs.contains(_tab) ? _tab : AppTab.home;
    final index = tabs.indexOf(current);

    return PopScope(
      // Back on another tab returns to Home before leaving the app.
      canPop: current == AppTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _tab = AppTab.home);
      },
      child: Scaffold(
        body: IndexedStack(index: index, children: [for (final t in tabs) _page(t)]),
        bottomNavigationBar: FloatingPillNav(
          items: [for (final t in tabs) _navItem(t, mode)],
          selected: index,
          large: settings.bigTargets,
          onSelect: (i) => setState(() => _tab = tabs[i]),
        ),
      ),
    );
  }
}
