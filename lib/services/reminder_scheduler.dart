import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/models.dart';

/// One scheduled reminder, already rendered into user-facing text.
class ReminderRequest {
  const ReminderRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.when,
    required this.payload,
    this.repeat = Repeat.none,
  });

  final int id;
  final String title;
  final String body;

  /// The first time it fires.
  final DateTime when;
  final String payload;

  /// After [when], the phone repeats it by itself (same time of day) without
  /// the app running, so a repeating task that nobody ticks off keeps
  /// reminding. [Repeat.none] fires once.
  final Repeat repeat;
}

/// Localised labels the OS shows outside the app.
class ReminderTexts {
  const ReminderTexts({
    required this.channelName,
    required this.channelDescription,
    required this.snooze,
    required this.done,
  });

  final String channelName;
  final String channelDescription;
  final String snooze;
  final String done;
}

/// What the user did with a notification.
class ReminderResponse {
  const ReminderResponse({required this.payload, this.action});

  final String payload;

  /// [ReminderScheduler.actionSnooze], [ReminderScheduler.actionDone] or null
  /// when the notification body itself was tapped.
  final String? action;
}

abstract class ReminderScheduler {
  static const actionSnooze = 'snooze';
  static const actionDone = 'done';

  /// Taps and action-button presses while the app is running.
  Stream<ReminderResponse> get responses;

  Future<void> init(ReminderTexts texts);

  /// New labels after the user changes language.
  void updateTexts(ReminderTexts texts);

  /// The notification that launched the app from a terminated state, if any.
  Future<ReminderResponse?> launchResponse();

  Future<bool> requestPermission();

  /// Whether reminders fire at their exact time. False on Android 14+ until
  /// the user allows "Alarms & reminders": Android then delays reminders
  /// while the phone sleeps, so they may only show up when it wakes.
  Future<bool> canRemindOnTime();

  /// Opens the system "Alarms & reminders" setting for this app. Returns
  /// whether reminders can now fire on time.
  Future<bool> requestOnTimeReminders();

  Future<void> schedule(ReminderRequest request);
  Future<void> cancel(int id);

  /// Replaces every pending reminder with [requests]. Called on start-up so
  /// the OS schedule always matches stored data (after restore, updates...).
  Future<void> replaceAll(List<ReminderRequest> requests);
}

class LocalNotificationScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _responses = StreamController<ReminderResponse>.broadcast();
  ReminderTexts? _texts;
  bool _ready = false;

  /// Scheduled notifications are supported on Android, iOS, macOS and Windows.
  /// On Linux and web we degrade gracefully to no reminders.
  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Stream<ReminderResponse> get responses => _responses.stream;

  @override
  Future<void> init(ReminderTexts texts) async {
    _texts = texts;
    if (!_supported) return;

    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Unknown zone name: fall back to UTC offsets, still correct locally.
      tz.setLocalLocation(tz.UTC);
    }

    final darwinCategory = DarwinNotificationCategory(
      'reminder',
      actions: [
        DarwinNotificationAction.plain(ReminderScheduler.actionSnooze, texts.snooze,
            options: {DarwinNotificationActionOption.foreground}),
        DarwinNotificationAction.plain(ReminderScheduler.actionDone, texts.done,
            options: {DarwinNotificationActionOption.foreground}),
      ],
    );

    await _plugin.initialize(
      settings: InitializationSettings(
        // White status-bar icon; kept in release builds by res/raw/keep.xml.
        android: const AndroidInitializationSettings('@drawable/ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [darwinCategory],
        ),
        macOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [darwinCategory],
        ),
      ),
      onDidReceiveNotificationResponse: (r) {
        final payload = r.payload;
        if (payload == null) return;
        _responses.add(ReminderResponse(payload: payload, action: r.actionId));
      },
    );
    _ready = true;
  }

  @override
  void updateTexts(ReminderTexts texts) => _texts = texts;

  @override
  Future<ReminderResponse?> launchResponse() async {
    if (!_ready) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    final r = details?.notificationResponse;
    if (details?.didNotificationLaunchApp != true || r?.payload == null) return null;
    return ReminderResponse(payload: r!.payload!, action: r.actionId);
  }

  @override
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final android = _plugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        return await android?.requestNotificationsPermission() ?? false;
      case TargetPlatform.iOS:
        final ios = _plugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        return await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
      case TargetPlatform.macOS:
        final mac = _plugin
            .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
        return await mac?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
      default:
        return false;
    }
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      defaultTargetPlatform == TargetPlatform.android
          ? _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          : null;

  @override
  Future<bool> canRemindOnTime() async {
    final android = _android;
    if (!_ready || android == null) return true;
    return await android.canScheduleExactNotifications() ?? true;
  }

  @override
  Future<bool> requestOnTimeReminders() async {
    final android = _android;
    if (!_ready || android == null) return true;
    return await android.requestExactAlarmsPermission() ?? false;
  }

  NotificationDetails _details() {
    final t = _texts!;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders',
        t.channelName,
        channelDescription: t.channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        actions: [
          AndroidNotificationAction(ReminderScheduler.actionSnooze, t.snooze,
              showsUserInterface: true, cancelNotification: true),
          AndroidNotificationAction(ReminderScheduler.actionDone, t.done,
              showsUserInterface: true, cancelNotification: true),
        ],
      ),
      iOS: const DarwinNotificationDetails(categoryIdentifier: 'reminder'),
      macOS: const DarwinNotificationDetails(categoryIdentifier: 'reminder'),
    );
  }

  Future<AndroidScheduleMode> _scheduleMode() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }
    final android =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final exact = await android?.canScheduleExactNotifications() ?? false;
    // Without the exact-alarm permission, reminders may arrive a few minutes late.
    return exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  @override
  Future<void> schedule(ReminderRequest request) async {
    if (!_ready) return;
    await cancel(request.id);
    if (!request.when.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id: request.id,
      title: request.title,
      body: request.body,
      scheduledDate: tz.TZDateTime.from(request.when, tz.local),
      notificationDetails: _details(),
      androidScheduleMode: await _scheduleMode(),
      payload: request.payload,
      matchDateTimeComponents: switch (request.repeat) {
        Repeat.none => null,
        Repeat.daily => DateTimeComponents.time,
        Repeat.weekly => DateTimeComponents.dayOfWeekAndTime,
        Repeat.monthly => DateTimeComponents.dayOfMonthAndTime,
        Repeat.yearly => DateTimeComponents.dateAndTime,
      },
    );
  }

  @override
  Future<void> cancel(int id) async {
    if (!_ready) return;
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> replaceAll(List<ReminderRequest> requests) async {
    if (!_ready) return;
    await _plugin.cancelAllPendingNotifications();
    for (final r in requests) {
      await schedule(r);
    }
  }
}

/// Records calls instead of talking to the OS. Used in tests.
class FakeReminderScheduler implements ReminderScheduler {
  final scheduled = <int, ReminderRequest>{};
  final controller = StreamController<ReminderResponse>.broadcast();
  ReminderResponse? pendingLaunch;

  @override
  Stream<ReminderResponse> get responses => controller.stream;

  ReminderTexts? texts;

  @override
  Future<void> init(ReminderTexts texts) async => this.texts = texts;

  @override
  void updateTexts(ReminderTexts texts) => this.texts = texts;

  @override
  Future<ReminderResponse?> launchResponse() async => pendingLaunch;

  @override
  Future<bool> requestPermission() async => true;

  bool onTimeAllowed = true;
  int onTimeRequests = 0;

  @override
  Future<bool> canRemindOnTime() async => onTimeAllowed;

  @override
  Future<bool> requestOnTimeReminders() async {
    onTimeRequests++;
    return onTimeAllowed = true;
  }

  @override
  Future<void> schedule(ReminderRequest request) async {
    if (request.when.isAfter(DateTime.now())) {
      scheduled[request.id] = request;
    } else {
      scheduled.remove(request.id);
    }
  }

  @override
  Future<void> cancel(int id) async => scheduled.remove(id);

  @override
  Future<void> replaceAll(List<ReminderRequest> requests) async {
    scheduled.clear();
    for (final r in requests) {
      await schedule(r);
    }
  }
}
