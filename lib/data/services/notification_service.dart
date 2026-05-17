import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

/// Schedules the hourly "did you drink water?" nudge.
/// Stays Android-first for now; iOS works with the same code but requires
/// the user to grant notification permission.
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _hourlyId = 1001;
  static const _testId = 9999;
  static const _channelId = 'momrise_water';
  static const _channelName = 'Su hatırlatması';
  static const _channelDesc = 'Saatlik su tüketimi hatırlatması';

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: DarwinNotificationDetails(),
  );

  static Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      ),
    );
  }

  static Future<bool> requestPermission() async {
    try {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted =
          await androidImpl?.requestNotificationsPermission() ?? false;
      final iosImpl = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final iosGranted = await iosImpl?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true;
      return granted || iosGranted;
    } catch (e) {
      debugPrint('notification permission error: $e');
      return false;
    }
  }

  static Future<void> scheduleHourlyWaterReminder({
    String title = 'Su hatırlatması',
    String body = 'Bugün suyunu içtin mi? +200 ml ekle 💧',
  }) async {
    await _plugin.periodicallyShow(
      id: _hourlyId,
      title: title,
      body: body,
      repeatInterval: RepeatInterval.hourly,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelHourlyWaterReminder() async {
    await _plugin.cancel(id: _hourlyId);
  }

  static Future<void> showTestNow() async {
    await _plugin.show(
      id: _testId,
      title: 'Su hatırlatması',
      body: 'Bugün suyunu içtin mi? +200 ml ekle 💧',
      notificationDetails: _details,
    );
  }
}
