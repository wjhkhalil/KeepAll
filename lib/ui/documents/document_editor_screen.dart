import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/dates.dart';
import '../../data/models.dart';
import '../../state/app_data.dart';
import '../labels.dart';
import '../photo.dart';
import '../widgets.dart';
import 'documents_screen.dart';

const _reminderOptions = [0, 7, 14, 30, 60, 90];

class DocumentEditorScreen extends StatefulWidget {
  const DocumentEditorScreen({super.key, this.document});

  final Document? document;

  @override
  State<DocumentEditorScreen> createState() => _DocumentEditorScreenState();
}

class _DocumentEditorScreenState extends State<DocumentEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AppData _data;
  late final TextEditingController _title;
  late final TextEditingController _number;
  late final TextEditingController _notes;
  late DocumentType _type;
  DateTime? _expires;
  late int _remindDays;
  String? _imageFile;
  final _importedImages = <String>{};

  bool get _isNew => widget.document == null;

  @override
  void initState() {
    super.initState();
    _data = context.read<AppData>();
    final d = widget.document;
    _title = TextEditingController(text: d?.title ?? '');
    _number = TextEditingController(text: d?.number ?? '');
    _notes = TextEditingController(text: d?.notes ?? '');
    _type = d?.type ?? DocumentType.passport;
    _expires = d?.expiresAt;
    _remindDays = d?.remindDaysBefore ?? 30;
    _imageFile = d?.imageFile;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // New documents start with the type's name ("Passport"), easy to change.
    if (_isNew && _title.text.isEmpty) _title.text = documentTypeLabel(context.l10n, _type);
  }

  @override
  void dispose() {
    _title.dispose();
    _number.dispose();
    _notes.dispose();
    for (final name in _importedImages) {
      _data.deleteImageIfUnused(name);
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final name = await pickAndImportPhoto(context);
    if (name == null || !mounted) return;
    _importedImages.add(name);
    setState(() => _imageFile = name);
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expires ?? DateTime(now.year + 1, now.month, now.day),
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 50),
    );
    if (picked == null || !mounted) return;
    setState(() => _expires = picked);
    if (_remindDays > 0) await ensureReminderPermission(context);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.document;
    final base = existing ?? _data.newDocument(title: _title.text.trim());
    final doc = base.copyWith(
      title: _title.text.trim(),
      type: _type,
      number: _number.text.trim(),
      expiresAt: () => _expires,
      remindDaysBefore: _remindDays,
      notes: _notes.text.trim(),
      imageFile: () => _imageFile,
    );
    await _data.saveDocument(doc);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final navigator = Navigator.of(context);
    final outer = navigator.context;
    if (!await confirmDeleteIfNeeded(context, widget.document!.title)) return;
    navigator.pop();
    if (outer.mounted) await deleteDocumentWithUndo(outer, widget.document!, confirmed: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const gap = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l.docNew : l.docEdit),
        actions: [
          if (!_isNew) IconButton(icon: const Icon(Icons.delete_outline), tooltip: l.delete, onPressed: _delete),
          TextButton(onPressed: _save, child: Text(l.save)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<DocumentType>(
              borderRadius: BorderRadius.circular(18),
              initialValue: _type,
              decoration: InputDecoration(labelText: l.docTypeLabel, prefixIcon: Icon(documentTypeIcon(_type))),
              items: [
                for (final t in DocumentType.values) DropdownMenuItem(value: t, child: Text(documentTypeLabel(l, t))),
              ],
              onChanged: (t) => setState(() {
                final previousLabel = documentTypeLabel(l, _type);
                _type = t ?? _type;
                // Suggest a title from the type until the user types their own.
                if (_title.text.isEmpty || _title.text == previousLabel) _title.text = documentTypeLabel(l, _type);
              }),
            ),
            gap,
            TextFormField(
              controller: _title,
              autofocus: _isNew,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.docTitleLabel),
              validator: (v) => v == null || v.trim().isEmpty ? l.taskTitleRequired : null,
            ),
            gap,
            TextFormField(
              controller: _number,
              decoration: InputDecoration(labelText: l.docNumberLabel, prefixIcon: const Icon(Icons.tag)),
            ),
            gap,
            FieldButton(
              icon: Icons.event_busy_rounded,
              label: l.docExpiryLabel,
              value: _expires == null ? l.docNoExpiry : formatDate(_expires!),
              onTap: _pickExpiry,
              trailing: _expires == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l.docNoExpiry,
                      onPressed: () => setState(() => _expires = null),
                    ),
            ),
            gap,
            DropdownButtonFormField<int>(
              borderRadius: BorderRadius.circular(18),
              initialValue: _reminderOptions.contains(_remindDays) ? _remindDays : 30,
              decoration: InputDecoration(
                labelText: l.docRemindLabel,
                prefixIcon: const Icon(Icons.notifications_rounded),
                helperText: _expires == null ? l.docRemindNeedsDate : null,
              ),
              items: [
                for (final d in _reminderOptions)
                  DropdownMenuItem(value: d, child: Text(d == 0 ? l.docRemindNone : l.docRemindBefore(d))),
              ],
              onChanged: (d) => setState(() => _remindDays = d ?? _remindDays),
            ),
            gap,
            PhotoField(
              file: _data.imageNamed(_imageFile),
              semanticLabel: l.docPhoto(_title.text),
              onAdd: _pickPhoto,
              onRemove: () => setState(() => _imageFile = null),
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
