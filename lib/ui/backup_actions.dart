import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/backup.dart';
import '../state/app_data.dart';
import '../state/settings.dart';
import 'labels.dart';
import 'widgets.dart';

bool get _isDesktop => !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

/// Builds a backup and lets the user choose where to save it
/// (Files / Google Drive / iCloud on phones, a folder on desktop).
Future<void> createBackup(BuildContext context) async {
  final l = context.l10n;
  final data = context.read<AppData>();
  final settings = context.read<Settings>();
  try {
    final bytes = await Backup.create(data, settings);
    final path = await FilePicker.saveFile(
      dialogTitle: l.backupCreate,
      fileName: Backup.fileName(data.now),
      type: FileType.custom,
      allowedExtensions: const ['zip'],
      bytes: bytes,
    );
    if (path == null) return; // cancelled
    // Desktop pickers only return a path; phones write the bytes themselves.
    if (_isDesktop) await File(path).writeAsBytes(bytes, flush: true);
    if (context.mounted) showMessage(context, l.backupCreated);
  } catch (e) {
    debugPrint('Backup failed: $e');
    if (context.mounted) showMessage(context, l.backupFailed);
  }
}

/// Lets the user pick a backup file, shows what's in it and, after
/// confirmation, replaces all current data with it.
Future<void> restoreBackup(BuildContext context) async {
  final l = context.l10n;
  final data = context.read<AppData>();
  final settings = context.read<Settings>();

  final BackupContents contents;
  try {
    final result = await FilePicker.pickFiles(
      dialogTitle: l.backupRestore,
      type: FileType.custom,
      allowedExtensions: const ['zip'],
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) return; // cancelled
    final bytes = file.bytes ?? (file.path != null ? await File(file.path!).readAsBytes() : null);
    if (bytes == null) throw const BackupException(BackupError.notABackup);
    contents = Backup.read(bytes);
  } on BackupException catch (e) {
    if (context.mounted) {
      showMessage(context, e.error == BackupError.tooNew ? l.backupTooNew : l.backupInvalid);
    }
    return;
  } catch (e) {
    debugPrint('Reading backup failed: $e');
    if (context.mounted) showMessage(context, l.backupInvalid);
    return;
  }
  if (!context.mounted) return;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.backupRestoreConfirmTitle),
      content: Text(
        '${l.backupContains(contents.count('tasks'), contents.count('lists'), contents.count('receipts'), contents.count('documents'))}'
        '\n\n${l.backupRestoreWarning}',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.backupRestoreAction)),
      ],
    ),
  );
  if (confirmed != true) return;

  try {
    await Backup.restore(contents, data, settings);
    if (context.mounted) showMessage(context, l.backupRestored);
  } catch (e) {
    debugPrint('Restore failed: $e');
    if (context.mounted) showMessage(context, l.backupFailed);
  }
}
