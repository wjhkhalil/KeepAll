import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/models.dart';
import '../../state/app_data.dart';
import '../../state/settings.dart';
import '../labels.dart';
import '../currency_picker.dart';
import '../photo.dart';
import '../widgets.dart';
import 'receipts_screen.dart';

class ReceiptEditorScreen extends StatefulWidget {
  const ReceiptEditorScreen({super.key, this.receipt});

  final Receipt? receipt;

  @override
  State<ReceiptEditorScreen> createState() => _ReceiptEditorScreenState();
}

class _ReceiptEditorScreenState extends State<ReceiptEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _merchant;
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late Currency _currency;
  late DateTime _date;
  late ReceiptCategory _category;
  DateTime? _warranty;
  String? _imageFile;

  /// Photos imported during this edit; any not kept are deleted on exit.
  final _importedImages = <String>{};
  late final AppData _data;
  bool _showDateError = false;

  bool get _isNew => widget.receipt == null;

  @override
  void initState() {
    super.initState();
    _data = context.read<AppData>();
    final r = widget.receipt;
    _merchant = TextEditingController(text: r?.merchant ?? '');
    _amount = TextEditingController(text: r == null ? '' : amountToInput(r.amountCents, r.currency));
    _note = TextEditingController(text: r?.note ?? '');
    _currency = r?.currency ?? context.read<Settings>().currency;
    _date = r?.date ?? dateOnly(DateTime.now());
    _category = r?.category ?? ReceiptCategory.groceries;
    _warranty = r?.warrantyUntil;
    _imageFile = r?.imageFile;
  }

  @override
  void dispose() {
    _merchant.dispose();
    _amount.dispose();
    _note.dispose();
    _cleanupImages();
    super.dispose();
  }

  void _cleanupImages() {
    // Photos that ended up in a saved receipt are kept automatically.
    for (final name in _importedImages) {
      _data.deleteImageIfUnused(name);
    }
  }

  Future<void> _pickImage() async {
    final name = await pickAndImportPhoto(context);
    if (name == null || !mounted) return;
    _importedImages.add(name);
    setState(() => _imageFile = name);
  }

  /// A purchase can't happen in the future; a warranty end date can.
  Future<DateTime?> _pickDate(DateTime initial, {bool allowFuture = false, DateTime? notBefore}) {
    final now = DateTime.now();
    final first = notBefore ?? DateTime(now.year - 20);
    final last = allowFuture ? DateTime(now.year + 20) : dateOnly(now);
    // Keep the starting date inside the allowed range (older data may be outside it).
    final start = initial.isAfter(last) ? last : (initial.isBefore(first) ? first : initial);
    return showDatePicker(context: context, initialDate: start, firstDate: first, lastDate: last);
  }

  bool get _dateInFuture => dateOnly(_date).isAfter(dateOnly(DateTime.now()));

  Future<void> _save() async {
    final validForm = _formKey.currentState!.validate();
    setState(() => _showDateError = _dateInFuture);
    if (!validForm || _dateInFuture) return;
    final data = context.read<AppData>();
    final cents = parseAmount(_amount.text, _currency)!;
    final existing = widget.receipt;
    final receipt = existing == null
        ? Receipt(
            id: data.newId(),
            merchant: _merchant.text.trim(),
            amountCents: cents,
            currency: _currency,
            date: _date,
            category: _category,
            note: _note.text.trim(),
            imageFile: _imageFile,
            warrantyUntil: _warranty,
            createdAt: data.now,
          )
        : existing.copyWith(
            merchant: _merchant.text.trim(),
            amountCents: cents,
            currency: _currency,
            date: _date,
            category: _category,
            note: _note.text.trim(),
            imageFile: () => _imageFile,
            warrantyUntil: () => _warranty,
          );
    await data.saveReceipt(receipt);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final navigator = Navigator.of(context);
    final outer = navigator.context;
    if (!await confirmDeleteIfNeeded(context, widget.receipt!.merchant)) return;
    navigator.pop();
    if (outer.mounted) await deleteReceiptWithUndo(outer, widget.receipt!, confirmed: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const gap = SizedBox(height: 16);
    final imageFile = _data.imageNamed(_imageFile);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l.receiptNew : l.receiptEdit),
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
            PhotoField(
              file: imageFile,
              semanticLabel: l.receiptPhoto(_merchant.text),
              onAdd: _pickImage,
              onRemove: () => setState(() => _imageFile = null),
            ),
            gap,
            TextFormField(
              controller: _merchant,
              autofocus: _isNew,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.receiptMerchantLabel, prefixIcon: const Icon(Icons.store_rounded)),
              validator: (v) => v == null || v.trim().isEmpty ? l.receiptMerchantRequired : null,
              textInputAction: TextInputAction.next,
            ),
            gap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\s]'))],
                    decoration: InputDecoration(
                      labelText: l.receiptAmountLabel,
                      hintText: exampleAmount(_currency),
                    ),
                    validator: (v) {
                      final cents = parseAmount(v ?? '', _currency);
                      return cents == null || cents < 0 ? l.receiptAmountInvalid(exampleAmount(_currency)) : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Semantics(
                    label: '${l.receiptCurrencyLabel}: ${currencyName(l, _currency)}',
                    button: true,
                    excludeSemantics: true,
                    child: FieldButton(
                      icon: Icons.payments_rounded,
                      label: l.receiptCurrencyLabel,
                      value: _currency.code,
                      onTap: () async {
                        final c = await pickCurrency(context, selected: _currency);
                        if (c != null) setState(() => _currency = c);
                      },
                    ),
                  ),
                ),
              ],
            ),
            gap,
            FieldButton(
              icon: Icons.calendar_today_rounded,
              label: l.receiptDateLabel,
              value: formatDate(_date),
              errorText: _showDateError && _dateInFuture ? l.receiptDateFuture : null,
              onTap: () async {
                final d = await _pickDate(_date);
                if (d != null) {
                  setState(() {
                    _date = d;
                    // Warranty can't end before the purchase.
                    if (_warranty != null && _warranty!.isBefore(d)) _warranty = null;
                  });
                }
              },
            ),
            gap,
            DropdownButtonFormField<ReceiptCategory>(
              borderRadius: BorderRadius.circular(18),
              initialValue: _category,
              decoration: InputDecoration(labelText: l.receiptCategoryLabel, prefixIcon: Icon(receiptCategoryIcon(_category))),
              items: [
                for (final c in ReceiptCategory.values)
                  DropdownMenuItem(value: c, child: Text(receiptCategoryLabel(l, c))),
              ],
              onChanged: (c) => setState(() => _category = c ?? _category),
            ),
            gap,
            FieldButton(
              icon: Icons.verified_rounded,
              label: l.receiptWarrantyLabel,
              value: _warranty == null ? l.receiptNoWarranty : formatDate(_warranty!),
              onTap: () async {
                final d = await _pickDate(
                  _warranty ?? DateTime(_date.year + 2, _date.month, _date.day),
                  allowFuture: true,
                  notBefore: _date,
                );
                if (d != null) setState(() => _warranty = d);
              },
              trailing: _warranty == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l.receiptNoWarranty,
                      onPressed: () => setState(() => _warranty = null),
                    ),
            ),
            gap,
            TextFormField(
              controller: _note,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.receiptNoteLabel, alignLabelWithHint: true),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: _save, icon: const Icon(Icons.check), label: Text(l.save)),
          ],
        ),
      ),
    );
  }
}
