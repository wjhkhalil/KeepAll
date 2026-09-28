import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Persists the whole app state as one JSON document. Personal data volumes
/// are small, and a single file keeps backup/restore trivial.
abstract class DataStore {
  Future<Map<String, dynamic>?> load();
  Future<void> save(Map<String, dynamic> data);

  /// Folder for receipt photos.
  Future<Directory> imagesDir();
}

class FileDataStore implements DataStore {
  FileDataStore({Directory? baseDir}) : _baseDir = baseDir;

  static const _fileName = 'keepall_data.json';

  /// File name used before the rename from "MyLife"; read once, then removed.
  static const _legacyFileName = 'mylife_data.json';

  Directory? _baseDir;
  Future<void> _pending = Future.value();

  Future<Directory> _dir() async => _baseDir ??= await getApplicationSupportDirectory();

  @override
  Future<Map<String, dynamic>?> load() async {
    final dir = (await _dir()).path;
    var file = File('$dir/$_fileName');
    if (!await file.exists()) {
      // Data saved under the old name is picked up; the next save moves it.
      file = File('$dir/$_legacyFileName');
      if (!await file.exists()) return null;
    }
    final text = await file.readAsString();
    if (text.trim().isEmpty) return null;
    return Map<String, dynamic>.from(jsonDecode(text) as Map);
  }

  @override
  Future<void> save(Map<String, dynamic> data) {
    // Serialise writes so a slow write can never overwrite a newer one.
    return _pending = _pending.then((_) => _write(data)).catchError((_) => _write(data));
  }

  Future<void> _write(Map<String, dynamic> data) async {
    final dir = await _dir();
    await dir.create(recursive: true);
    final tmp = File('${dir.path}/$_fileName.tmp');
    await tmp.writeAsString(jsonEncode(data), flush: true);
    // Rename is atomic, so a crash mid-write never corrupts existing data.
    await tmp.rename('${dir.path}/$_fileName');
    final legacy = File('${dir.path}/$_legacyFileName');
    if (await legacy.exists()) await legacy.delete();
  }

  @override
  Future<Directory> imagesDir() async {
    final dir = Directory('${(await _dir()).path}/receipts');
    await dir.create(recursive: true);
    return dir;
  }
}

/// In-memory store for tests.
class MemoryDataStore implements DataStore {
  MemoryDataStore([this.data]);

  Map<String, dynamic>? data;
  int saveCount = 0;

  @override
  Future<Map<String, dynamic>?> load() async =>
      data == null ? null : jsonDecode(jsonEncode(data)) as Map<String, dynamic>;

  @override
  Future<void> save(Map<String, dynamic> data) async {
    saveCount++;
    this.data = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
  }

  @override
  Future<Directory> imagesDir() async => Directory.systemTemp.createTemp('keepall_test');
}
