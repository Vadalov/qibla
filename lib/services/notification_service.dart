import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'prayer_time_service.dart';
import 'storage_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
    _initialized = true;
  }

  /// Show a simple notification immediately (for testing).
  Future<void> showSimpleNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'Namaz Vakitleri',
      channelDescription: 'Namaz vakitleri bildirim kanalı',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  /// Schedule daily notifications for the given prayer times.
  ///
  /// NOTE: For tam doğru zamanlama, `timezone` paketi ve `zonedSchedule`
  /// kullanılmalıdır. Burada sade bir iskelet ve anlık bildirim örneği veriyoruz.
  Future<void> scheduleDailyPrayerNotifications(PrayerTimes times) async {
    await init();

    final storage = StorageService();
    await storage.init();

    final enabled = storage.isNotificationsEnabled();
    if (!enabled) {
      debugPrint('Notifications are disabled, skipping scheduling.');
      return;
    }

    // Basit bir örnek: sonraki vakit için tek seferlik bildirim göster.
    await showSimpleNotification(
      title: 'Namaz Vakti',
      body:
          'Bugünkü namaz vakitleri yüklendi. Bildirim zamanlama altyapısı hazır.',
    );
  }
}


