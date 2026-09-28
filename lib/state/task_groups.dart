import '../core/dates.dart';
import '../data/models.dart';
import 'app_data.dart';

enum TaskGroup { overdue, today, tomorrow, thisWeek, later, noDate }

/// Buckets open tasks by due date. Order within a bucket is by due time.
/// "This week" ends on Sunday because weeks start on Monday.
Map<TaskGroup, List<Task>> groupTasks(Iterable<Task> tasks, DateTime now) {
  final groups = {for (final g in TaskGroup.values) g: <Task>[]};
  final today = dateOnly(now);
  final endOfWeek = startOfWeek(now).add(const Duration(days: 7));

  for (final t in tasks) {
    if (t.done) continue;
    final due = t.dueAt;
    final TaskGroup group;
    if (due == null) {
      group = TaskGroup.noDate;
    } else if (t.isOverdue(now)) {
      group = TaskGroup.overdue;
    } else if (isSameDay(due, today)) {
      group = TaskGroup.today;
    } else if (daysBetween(today, due) == 1) {
      group = TaskGroup.tomorrow;
    } else if (due.isBefore(endOfWeek)) {
      group = TaskGroup.thisWeek;
    } else {
      group = TaskGroup.later;
    }
    groups[group]!.add(t);
  }
  for (final list in groups.values) {
    list.sort(AppData.compareByDue);
  }
  return groups;
}
