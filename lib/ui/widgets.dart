import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_data.dart';
import '../state/settings.dart';
import 'labels.dart';

/// Asks for confirmation when the user (or Simple mode) wants it.
Future<bool> confirmDeleteIfNeeded(BuildContext context, String name) async {
  if (!context.read<Settings>().confirmDelete) return true;
  final l = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.confirmDeleteTitle),
      content: Text(l.confirmDeleteItem(name)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.delete)),
      ],
    ),
  );
  return result ?? false;
}

/// Asks for everything a reminder needs when the user turns one on: the
/// notification permission and, on Android 14+, "Alarms & reminders".
/// Without the second one Android holds reminders back while the phone
/// sleeps, so they only appeared once the app was opened again.
Future<void> ensureReminderPermission(BuildContext context) async {
  final data = context.read<AppData>();
  final scheduler = data.scheduler;
  final l = context.l10n;
  final granted = await scheduler.requestPermission();
  if (!context.mounted) return;
  if (!granted) {
    showMessage(context, l.reminderPermissionDenied);
    return;
  }
  if (await scheduler.canRemindOnTime() || !context.mounted) return;
  final allow = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.alarm_rounded),
      title: Text(l.reminderOnTimeTitle),
      content: Text(l.reminderOnTimeBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.reminderOnTimeLater)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.reminderOnTimeAllow)),
      ],
    ),
  );
  if (allow != true) return;
  // Reminders scheduled before were inexact; schedule them again on time.
  if (await scheduler.requestOnTimeReminders()) await data.resyncReminders();
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(
  BuildContext context,
  String message, {
  VoidCallback? onUndo,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  return messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      action: onUndo == null ? null : SnackBarAction(label: context.l10n.undo, onPressed: onUndo),
    ),
  );
}

/// Background shown behind a list row while swiping.
class SwipeBackground extends StatelessWidget {
  const SwipeBackground({super.key, required this.icon, required this.color, required this.alignEnd});

  final IconData icon;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
    alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Icon(icon, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
  );
}

/// A tappable row showing a label and current value, used for date/time/
/// dropdown style fields in forms.
class FieldButton extends StatelessWidget {
  const FieldButton({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing,
    this.errorText,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;

  /// Shown in red under the field, like a form validation error.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), suffixIcon: trailing, errorText: errorText),
        child: Text(value, style: theme.textTheme.bodyLarge),
      ),
    );
  }
}

class DialogField {
  const DialogField({
    required this.label,
    this.initial = '',
    this.hint,
    this.requiredMessage,
    this.keyboardType,
    this.capitalization = TextCapitalization.sentences,
  });

  final String label;
  final String initial;
  final String? hint;

  /// If set, the field may not be empty and this message is shown.
  final String? requiredMessage;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
}

/// Shows a dialog with one or more text fields. Returns the trimmed values,
/// or null if cancelled. The dialog owns its controllers so they outlive the
/// closing animation.
Future<List<String>?> showTextFieldsDialog(
  BuildContext context, {
  required String title,
  required List<DialogField> fields,
}) => showDialog<List<String>>(
  context: context,
  builder: (_) => _TextFieldsDialog(title: title, fields: fields),
);

class _TextFieldsDialog extends StatefulWidget {
  const _TextFieldsDialog({required this.title, required this.fields});

  final String title;
  final List<DialogField> fields;

  @override
  State<_TextFieldsDialog> createState() => _TextFieldsDialogState();
}

class _TextFieldsDialogState extends State<_TextFieldsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _controllers = [for (final f in widget.fields) TextEditingController(text: f.initial)];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, [for (final c in _controllers) c.text.trim()]);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.fields.length; i++)
                Padding(
                  padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
                  child: TextFormField(
                    controller: _controllers[i],
                    autofocus: i == 0,
                    keyboardType: widget.fields[i].keyboardType,
                    textCapitalization: widget.fields[i].capitalization,
                    textInputAction: i == widget.fields.length - 1 ? TextInputAction.done : TextInputAction.next,
                    decoration: InputDecoration(labelText: widget.fields[i].label, hintText: widget.fields[i].hint),
                    validator: widget.fields[i].requiredMessage == null
                        ? null
                        : (v) => v == null || v.trim().isEmpty ? widget.fields[i].requiredMessage : null,
                    onFieldSubmitted: i == widget.fields.length - 1 ? (_) => _submit() : null,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: _submit, child: Text(l.save)),
      ],
    );
  }
}
