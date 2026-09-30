import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../state/app_data.dart';
import '../state/settings.dart';

/// Backups are a single .zip:
///   lifekeeper.json – format marker + version (older backups: keepall.json, mylife.json)
///   data.json      – tasks, lists, receipts, documents
///   settings.json  – mode, theme, currency, language...
///   images/NAME    – receipt and document photos
class Backup {
  static const _marker = 'lifekeeper.json';
  static const appName = 'LifeKeeper';

  /// Backups made before the app was renamed from "MyLife" still restore.
  static const _legacyMarker = 'mylife.json';
  static const _legacyAppName = 'MyLife';

  /// Backups made before the app was renamed to "LifeKeeper" still restore.
  static const _legacyMarker2 = 'keepall.json';
  static const _legacyAppName2 = 'KeepAll';
  static const _legacyAppName3 = 'Keepall';
  static const _data = 'data.json';
  static const _settings = 'settings.json';
  static const _images = 'images/';
  static const formatVersion = 1;

  static String fileName(DateTime now) =>
      'lifekeeper-backup-${now.year}-${_two(now.month)}-${_two(now.day)}.zip';

  static String _two(int v) => v.toString().padLeft(2, '0');

  static Future<Uint8List> create(AppData data, Settings settings) async {
    final archive = Archive()
      ..add(ArchiveFile.string(_marker, jsonEncode({'app': appName, 'format': formatVersion})))
      ..add(ArchiveFile.string(_data, jsonEncode(data.toJson())))
      ..add(ArchiveFile.string(_settings, jsonEncode(settings.toJson())));

    final dir = await data.imagesDir();
    for (final name in data.referencedImages) {
      final file = File('${dir.path}/$name');
      if (await file.exists()) archive.add(ArchiveFile.bytes('$_images$name', await file.readAsBytes()));
    }
    return ZipEncoder().encodeBytes(archive);
  }

  /// Parses and validates a backup. Throws [BackupException] if the file is
  /// not a LifeKeeper (or older KeepAll / MyLife) backup or was made by a
  /// newer version of the app.
  static BackupContents read(Uint8List bytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw const BackupException(BackupError.notABackup);
    }
    Map<String, dynamic> json(String name) {
      final file = archive.findFile(name);
      if (file == null) throw const BackupException(BackupError.notABackup);
      try {
        return Map<String, dynamic>.from(jsonDecode(utf8.decode(file.content)) as Map);
      } catch (_) {
        throw const BackupException(BackupError.notABackup);
      }
    }

    final marker = json(
      archive.findFile(_marker) != null
          ? _marker
          : archive.findFile(_legacyMarker2) != null
              ? _legacyMarker2
              : _legacyMarker,
    );
    if (marker['app'] != appName &&
        marker['app'] != _legacyAppName &&
        marker['app'] != _legacyAppName2 &&
        marker['app'] != _legacyAppName3) {
      throw const BackupException(BackupError.notABackup);
    }
    final format = marker['format'];
    if (format is! int || format > formatVersion) throw const BackupException(BackupError.tooNew);

    final data = json(_data);
    final dataVersion = data['version'];
    if (dataVersion is int && dataVersion > AppData.schemaVersion) {
      throw const BackupException(BackupError.tooNew);
    }

    final images = <String, Uint8List>{};
    for (final f in archive.files) {
      if (!f.isFile || !f.name.startsWith(_images)) continue;
      final name = f.name.substring(_images.length);
      // Ignore anything that could escape the images folder.
      if (name.isEmpty || name.contains('/') || name.contains('\\') || name.contains('..')) continue;
      images[name] = f.content;
    }
    return BackupContents(data: data, settings: json(_settings), images: images);
  }

  /// Replaces everything in the app with [contents].
  static Future<void> restore(BackupContents contents, AppData data, Settings settings) async {
    final dir = await data.imagesDir();
    for (final e in contents.images.entries) {
      await File('${dir.path}/${e.key}').writeAsBytes(e.value, flush: true);
    }
    await data.replaceAllData(contents.data);
    await settings.applyJson(contents.settings);
  }
}

class BackupContents {
  const BackupContents({required this.data, required this.settings, required this.images});

  final Map<String, dynamic> data;
  final Map<String, dynamic> settings;
  final Map<String, Uint8List> images;

  int count(String key) => (data[key] as List?)?.length ?? 0;
}

enum BackupError { notABackup, tooNew }

class BackupException implements Exception {
  const BackupException(this.error);

  final BackupError error;

  @override
  String toString() => 'BackupException($error)';
}
