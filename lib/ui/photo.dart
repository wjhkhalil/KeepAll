import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../state/app_data.dart';
import 'labels.dart';
import 'widgets.dart';

/// Lets the user take or choose a photo and copies it into app storage.
/// Returns the stored file name, or null if cancelled or failed.
Future<String?> pickAndImportPhoto(BuildContext context) async {
  final l = context.l10n;
  final data = context.read<AppData>();
  final picker = ImagePicker();
  ImageSource? source = ImageSource.gallery;
  if (picker.supportsImageSource(ImageSource.camera)) {
    source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(l.photoTake),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l.photoChoose),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
  if (source == null) return null;
  try {
    final picked = await picker.pickImage(source: source, maxWidth: 2000, imageQuality: 85);
    if (picked == null) return null;
    return await data.importImage(picked.path);
  } catch (_) {
    if (context.mounted) showMessage(context, l.photoError);
    return null;
  }
}

/// Shows an attached photo (tap to zoom, button to remove) or an
/// "Add photo" button.
class PhotoField extends StatelessWidget {
  const PhotoField({super.key, required this.file, required this.semanticLabel, required this.onAdd, required this.onRemove});

  final File? file;
  final String semanticLabel;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  void _view(BuildContext context, File f) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: InteractiveViewer(
          maxScale: 5,
          child: Center(child: Image.file(f, semanticLabel: semanticLabel)),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = file;
    if (f == null) {
      return OutlinedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add_a_photo_rounded), label: Text(l.photoAdd));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => _view(context, f),
            child: Image.file(
              f,
              height: 220,
              fit: BoxFit.cover,
              semanticLabel: semanticLabel,
              errorBuilder: (_, _, _) => const SizedBox(height: 80, child: Icon(Icons.broken_image_rounded)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(onPressed: onRemove, icon: const Icon(Icons.close), label: Text(l.photoRemove)),
        ),
      ],
    );
  }
}
