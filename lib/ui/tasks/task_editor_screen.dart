import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/dates.dart';
import '../../data/models.dart';
import '../../state/app_data.dart';
import '../../state/settings.dart';
import '../labels.dart';
import '../widgets.dart';
import 'task_tile.dart';

class TaskEditorScreen extends StatefulWidget {
  const TaskEditorScreen({super.key, this.task, this.initialCategory});

  /// Null when creating a new task.
  final Task? task;
  final TaskCategory? initialCategory;

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late TaskCategory _category;
  DateTime? _date;
  TimeOfDay? _time;
  late bool _remind;
  late Repeat _repeat;

  bool get _isNew => widget.task == null;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _title = TextEditingController(text: t?.title ?? '');
    _notes = TextEditingController(text: t?.notes ?? '');
    _category = t?.category ?? widget.initialCategory ?? _defaultCategory();
    _date = t?.dueAt == null ? null : dateOnly(t!.dueAt!);
    _time = t != null && t.hasTime && t.dueAt != null ? TimeOfDay.fromDateTime(t.dueAt!) : null;
    _remind = t?.remind ?? false;
    _repeat = t?.repeat ?? Repeat.none;
  }

  TaskCategory _defaultCategory() => categoriesFor(context.read<Settings>().mode).first;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: _isNew ? dateOnly(now) : DateTime(now.year - 5),
      lastDate: DateTime(now.year + 20),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _time = picked;
        _date ??= dateOnly(DateTime.now());
      });
    }
  }

  Future<void> _setRemind(bool value) async {
    setState(() {
      _remind = value;
      if (value) _date ??= dateOnly(DateTime.now());
    });
    if (value) await ensureReminderPermission(context);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = context.read<AppData>();
    final dueAt = _date == null
        ? null
        : DateTime(_date!.year, _date!.month, _date!.day, _time?.hour ?? 0, _time?.minute ?? 0);

    if (_isNew && dueAt != null) {
      final now = DateTime.now();
      final isPast = _time != null
          ? dueAt.isBefore(now)
          : dateOnly(dueAt).isBefore(dateOnly(now));
      if (isPast) {
        showMessage(context, context.l10n.taskPastDateTime);
        return;
      }
    }

    final remind = _remind && dueAt != null;
    final existing = widget.task;
    final task = existing == null
        ? data.newTask(
            title: _title.text.trim(),
            notes: _notes.text.trim(),
            category: _category,
            dueAt: dueAt,
            hasTime: _time != null,
            remind: remind,
            repeat: dueAt == null ? Repeat.none : _repeat,
          )
        : existing.copyWith(
            title: _title.text.trim(),
            notes: _notes.text.trim(),
            category: _category,
            dueAt: () => dueAt,
            hasTime: _time != null,
            remind: remind,
            repeat: dueAt == null ? Repeat.none : _repeat,
            // Editing the time replaces any earlier snooze.
            snoozedUntil: () => null,
          );
    // Remember the chosen day so "every month on the 31st" doesn't drift.
    final anchored = task.repeat == Repeat.monthly || task.repeat == Repeat.yearly;
    await data.saveTask(task.copyWith(anchorDay: () => anchored ? dueAt!.day : null));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final task = widget.task!;
    final navigator = Navigator.of(context);
    final messengerContext = navigator.context;
    if (!await confirmDeleteIfNeeded(context, task.title)) return;
    navigator.pop();
    if (messengerContext.mounted) await deleteTaskWithUndoConfirmed(messengerContext, task);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mode = context.watch<Settings>().mode;
    const gap = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l.taskNew : l.taskEdit),
        actions: [
          if (!_isNew)
            IconButton(icon: const Icon(Icons.delete_outline), tooltip: l.delete, onPressed: _delete),

          TextButton(onPressed: _save, child: Text(l.save)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              autofocus: _isNew,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.taskTitleLabel),
              validator: (v) => v == null || v.trim().isEmpty ? l.taskTitleRequired : null,
              textInputAction: TextInputAction.done,
            ),
            gap,
            Semantics(header: true, child: Text(l.taskCategoryLabel, style: Theme.of(context).textTheme.titleSmall)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in categoriesFor(mode))
                  ChoiceChip(
                    avatar: Icon(taskCategoryIcon(c), size: 18),
                    label: Text(taskCategoryLabel(l, c)),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            gap,
            FieldButton(
              icon: Icons.calendar_today_rounded,
              label: l.taskDateLabel,
              value: _date == null ? l.taskNoDate : '${formatWeekday(_date!)} ${formatDate(_date!)}',
              onTap: _pickDate,
              trailing: _date == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l.taskClearDate,
                      onPressed: () => setState(() {
                        _date = null;
                        _time = null;
                        _remind = false;
                        _repeat = Repeat.none;
                      }),
                    ),
            ),
            gap,
            FieldButton(
              icon: Icons.schedule,
              label: l.taskTimeLabel,
              value: _time == null
                  ? l.taskAllDay
                  : formatTime(DateTime(2000, 1, 1, _time!.hour, _time!.minute)),
              onTap: _pickTime,
              trailing: _time == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l.taskClearTime,
                      onPressed: () => setState(() => _time = null),
                    ),
            ),
            gap,
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.notifications_rounded),
              title: Text(l.taskRemind),
              subtitle: _date == null
                  ? Text(l.taskRemindNeedsDate)
                  : _time == null && _remind
                  ? Text(l.taskRemindAllDayHint)
                  : null,
              value: _remind,
              onChanged: _setRemind,
            ),
            gap,
            DropdownButtonFormField<Repeat>(
              borderRadius: BorderRadius.circular(18),
              initialValue: _repeat,
              decoration: InputDecoration(labelText: l.taskRepeatLabel, prefixIcon: const Icon(Icons.repeat)),
              items: [
                for (final r in Repeat.values) DropdownMenuItem(value: r, child: Text(repeatLabel(l, r))),
              ],
              onChanged: (r) => setState(() {
                _repeat = r ?? Repeat.none;
                if (_repeat != Repeat.none) _date ??= dateOnly(DateTime.now());
              }),
            ),
            gap,
            TextFormField(
              controller: _notes,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.taskNotesLabel, alignLabelWithHint: true),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: _save, icon: const Icon(Icons.check), label: Text(l.save)),
          ],
        ),
      ),
    );
  }
}
