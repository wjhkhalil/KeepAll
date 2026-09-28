import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:keepall/core/dates.dart';
import 'package:keepall/core/money.dart';
import 'package:keepall/data/data_store.dart';
import 'package:keepall/data/models.dart';
import 'package:keepall/services/backup.dart';
import 'package:keepall/services/reminder_scheduler.dart';
import 'package:keepall/state/app_data.dart';
import 'package:keepall/state/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() => initializeDateFormatting());
  tearDown(() {
    setDateLanguage('en');
    setMoneyLanguage('en');
  });

  group('language-aware formatting', () {
    test('money follows each language', () {
      setMoneyLanguage('de');
      expect(formatMoney(123450, Currency.eur), '1.234,50 €');
      expect(formatMoney(3000, Currency.chf), '30,00 CHF');
      expect(amountToInput(1250, Currency.eur), '12,50');
      setMoneyLanguage('nl');
      expect(formatMoney(1250, Currency.eur), '€ 12,50');
      setMoneyLanguage('pl');
      expect(formatMoney(123450, Currency.pln), '1 234,50 PLN');
      setMoneyLanguage('en');
      expect(formatMoney(123450, Currency.eur), '€1,234.50');
    });

    test('dates use the local separator and translated names', () {
      final d = DateTime(2026, 9, 27);
      setDateLanguage('de');
      expect(formatDate(d), '27.09.2026');
      expect(formatMonthYear(d), 'September 2026');
      setDateLanguage('nl');
      expect(formatDate(d), '27-09-2026');
      setDateLanguage('fr');
      expect(formatDate(d), '27/09/2026');
      expect(formatMonthYear(d), 'Septembre 2026'); // capitalised
    });
  });

  test('monthly repeat anchored to the 31st does not drift', () {
    var d = DateTime(2026, 1, 31, 9);
    final seen = <DateTime>[];
    for (var i = 0; i < 3; i++) {
      d = Repeat.monthly.next(d, anchorDay: 31);
      seen.add(d);
    }
    expect(seen, [DateTime(2026, 2, 28, 9), DateTime(2026, 3, 31, 9), DateTime(2026, 4, 30, 9)]);
  });

  group('documents', () {
    late FakeReminderScheduler scheduler;
    late AppData data;
    final now = DateTime(2100, 3, 1, 10);

    setUp(() async {
      scheduler = FakeReminderScheduler();
      data = AppData(store: MemoryDataStore(), scheduler: scheduler, clock: () => now);
      await data.load();
    });

    test('reminder fires N days before expiry at 09:00', () async {
      final doc = data.newDocument(title: 'Passport').copyWith(expiresAt: () => DateTime(2100, 6, 1), remindDaysBefore: 30);
      await data.saveDocument(doc);
      final r = scheduler.scheduled[doc.notificationId]!;
      expect(r.when, DateTime(2100, 5, 2, 9));
      expect(r.payload, 'doc:${doc.id}');
      expect(r.body, contains('01/06/2100'));
    });

    test('no reminder when disabled; delete cancels', () async {
      final doc = data.newDocument(title: 'ID').copyWith(expiresAt: () => DateTime(2100, 6, 1), remindDaysBefore: 0);
      await data.saveDocument(doc);
      expect(scheduler.scheduled, isEmpty);
      await data.saveDocument(doc.copyWith(remindDaysBefore: 14));
      expect(scheduler.scheduled, hasLength(1));
      await data.deleteDocument(doc.id);
      expect(scheduler.scheduled, isEmpty);
    });

    test('sorted by expiry and expiring-soon filter', () async {
      await data.saveDocument(data.newDocument(title: 'Later').copyWith(expiresAt: () => DateTime(2101, 1, 1)));
      await data.saveDocument(data.newDocument(title: 'Soon').copyWith(expiresAt: () => DateTime(2100, 3, 10)));
      await data.saveDocument(data.newDocument(title: 'Expired').copyWith(expiresAt: () => DateTime(2100, 2, 1)));
      await data.saveDocument(data.newDocument(title: 'None'));
      expect(data.documentsByExpiry.map((d) => d.title), ['Expired', 'Soon', 'Later', 'None']);
      expect(data.expiringWithin(30).map((d) => d.title), ['Expired', 'Soon']);
    });

    test('tapping a document reminder opens it', () async {
      final doc = data.newDocument(title: 'Insurance');
      await data.saveDocument(doc);
      final target = await data.handleReminderResponse(ReminderResponse(payload: 'doc:${doc.id}'));
      expect(target!.isDocument, isTrue);
      expect(target.id, doc.id);
    });
  });

  group('backup', () {
    late Directory tmp;

    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('keepall_backup_test');
    });
    tearDown(() => tmp.delete(recursive: true));

    Future<(AppData, Settings, FakeReminderScheduler)> make(String sub, Map<String, Object> prefs) async {
      SharedPreferences.setMockInitialValues(prefs);
      final settings = await Settings.load();
      final scheduler = FakeReminderScheduler();
      final data = AppData(
        store: FileDataStore(baseDir: Directory('${tmp.path}/$sub')),
        scheduler: scheduler,
        clock: () => DateTime(2100, 1, 1),
      );
      await data.load();
      return (data, settings, scheduler);
    }

    test('round-trips data, settings and photos', () async {
      final (src, srcSettings, _) = await make('src', {'onboarded': true, 'mode': 'simple', 'language': 'de', 'currency': 'CHF'});
      final photo = File('${tmp.path}/photo.jpg')..writeAsBytesSync([1, 2, 3, 4]);
      final imageName = await src.importImage(photo.path);
      await src.saveReceipt(Receipt(
        id: 'r1', merchant: 'Migros', amountCents: 4550, currency: Currency.chf,
        date: DateTime(2100, 1, 1), imageFile: imageName, createdAt: DateTime(2100),
      ));
      await src.saveTask(src.newTask(title: 'Pills', dueAt: DateTime(2100, 1, 2, 8), hasTime: true, remind: true));
      await src.saveDocument(src.newDocument(title: 'Passport').copyWith(expiresAt: () => DateTime(2100, 5, 1)));
      final list = await src.addList('Groceries');
      await src.addItem(list.id, 'Milk');

      final bytes = await Backup.create(src, srcSettings);
      final contents = Backup.read(bytes);
      expect(contents.count('tasks'), 1);
      expect(contents.count('documents'), 1);
      expect(contents.images.keys, [imageName]);

      final (dst, dstSettings, dstScheduler) = await make('dst', {});
      await Backup.restore(contents, dst, dstSettings);

      expect(dst.receipts.single.amountCents, 4550);
      expect(dst.tasks.single.title, 'Pills');
      expect(dst.documents.single.title, 'Passport');
      expect(dst.lists.single.items.single.name, 'Milk');
      expect(await dst.imageFor(dst.receipts.single)!.readAsBytes(), [1, 2, 3, 4]);
      expect(dstSettings.mode, UserMode.simple);
      expect(dstSettings.language, 'de');
      expect(dstSettings.currency, Currency.chf);
      expect(dstSettings.onboarded, isTrue);
      // Reminders are rescheduled from the restored data.
      expect(dstScheduler.scheduled, hasLength(2));
    });

    test('rejects files that are not backups', () {
      expect(
        () => Backup.read(Uint8List.fromList([1, 2, 3])),
        throwsA(isA<BackupException>().having((e) => e.error, 'error', BackupError.notABackup)),
      );
      final otherZip = ZipEncoder().encodeBytes(Archive()..add(ArchiveFile.string('hello.txt', 'hi')));
      expect(() => Backup.read(otherZip), throwsA(isA<BackupException>()));
    });

    test('rejects backups from a newer app version', () {
      final zip = ZipEncoder().encodeBytes(Archive()
        ..add(ArchiveFile.string('keepall.json', '{"app":"Keepall","format":99}'))
        ..add(ArchiveFile.string('data.json', '{}'))
        ..add(ArchiveFile.string('settings.json', '{}')));
      expect(
        () => Backup.read(zip),
        throwsA(isA<BackupException>().having((e) => e.error, 'error', BackupError.tooNew)),
      );
    });

    test('still restores backups made when the app was called MyLife', () {
      final zip = ZipEncoder().encodeBytes(Archive()
        ..add(ArchiveFile.string('mylife.json', '{"app":"MyLife","format":1}'))
        ..add(ArchiveFile.string('data.json', '{"version":1,"tasks":[{"id":"t","notificationId":1,"title":"Old"}]}'))
        ..add(ArchiveFile.string('settings.json', '{}')));
      expect(Backup.read(zip).count('tasks'), 1);
    });

    test('new backups are marked as Keepall', () async {
      final (src, settings, _) = await make('mark', {});
      final contents = ZipDecoder().decodeBytes(await Backup.create(src, settings));
      expect(utf8.decode(contents.findFile('keepall.json')!.content), contains('"Keepall"'));
      expect(Backup.fileName(DateTime(2026, 9, 27)), 'keepall-backup-2026-09-27.zip');
    });

    test('data saved under the old MyLife file name is picked up and moved', () async {
      final dir = Directory('${tmp.path}/legacy')..createSync();
      File('${dir.path}/mylife_data.json').writeAsStringSync('{"version":1,"tasks":[{"id":"t","notificationId":1,"title":"Kept"}]}');
      final store = FileDataStore(baseDir: dir);
      final data = AppData(store: store, scheduler: FakeReminderScheduler());
      await data.load();
      expect(data.tasks.single.title, 'Kept');
      await data.saveTask(data.tasks.single.copyWith(title: 'Kept'));
      expect(File('${dir.path}/keepall_data.json').existsSync(), isTrue);
      expect(File('${dir.path}/mylife_data.json').existsSync(), isFalse);
    });

    test('ignores image paths that try to escape the folder', () {
      final zip = ZipEncoder().encodeBytes(Archive()
        ..add(ArchiveFile.string('keepall.json', '{"app":"Keepall","format":1}'))
        ..add(ArchiveFile.string('data.json', '{"version":1}'))
        ..add(ArchiveFile.string('settings.json', '{}'))
        ..add(ArchiveFile.bytes('images/../../evil.sh', [1]))
        ..add(ArchiveFile.bytes('images/ok.jpg', [2])));
      expect(Backup.read(zip).images.keys, ['ok.jpg']);
    });
  });
}
