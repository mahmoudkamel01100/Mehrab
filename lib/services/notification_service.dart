import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
      
  static Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    try {
      // Since this app is dedicated to Al-Hawamdeya, Egypt, we lock timezone to Africa/Cairo
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    } catch (e) {
      print('Could not set Africa/Cairo location: $e');
    }
    
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings iosInit =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );
        
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification click if needed
      },
    );

    // Create the custom notification channel on Android for custom sound
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'prayer_times_channel_v2',
        'مواقيت الصلاة والأذان',
        description: 'تنبيهات مواقيت الصلاة والأذان لمسجد الحوامدية',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('adhan'),
      );
      await androidPlugin.createNotificationChannel(channel);
    }
  }
  
  static Future<bool> requestPermissions() async {
    // 1. Request POST_NOTIFICATIONS (Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // 2. Request SCHEDULE_EXACT_ALARM (Android 12+)
    // This is required to make the notification fire exactly at the prayer time.
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    // 3. Request IGNORE_BATTERY_OPTIMIZATIONS
    // This is required to prevent the OS from killing the background notifications when the app is closed.
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    // Request iOS permission
    final iosPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    return true;
  }
  
  static Future<void> schedulePrayerNotifications() async {
    // 1. Cancel any existing notifications first to prevent duplicates
    await cancelAllNotifications();
    
    final prefs = await SharedPreferences.getInstance();
    final bool isEnabled = prefs.getBool('prayer_notifications_enabled') ?? true;
    if (!isEnabled) return;
    
    // 5 daily prayers
    final List<String> prayerNames = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    
    // Al-Hawamdeya coordinates
    const double latitude = 29.8967;
    const double longitude = 31.2631;
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi; // Shafi'i madhab standard for Egypt
    
    final DateTime now = DateTime.now();
    
    // Schedule for the next 7 days (today + 6 days ahead)
    for (int day = 0; day < 7; day++) {
      final DateTime targetDate = now.add(Duration(days: day));
      final dateComponents = DateComponents.from(targetDate);
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
      
      final List<DateTime> times = [
        prayerTimes.fajr,
        prayerTimes.dhuhr,
        prayerTimes.asr,
        prayerTimes.maghrib,
        prayerTimes.isha,
      ];
      
      for (int i = 0; i < times.length; i++) {
        final DateTime time = times[i];
        
        // Skip if the prayer time has already passed
        if (time.isBefore(now)) continue;
        
        final int notificationId = day * 10 + i;
        final String prayerName = prayerNames[i];
        
        // Adhan sound configuration. Looks for res/raw/adhan.mp3 on Android.
        // If missing, Android automatically falls back to default notification sound.
        final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          'prayer_times_channel_v2',
          'مواقيت الصلاة والأذن',
          channelDescription: 'تنبيهات مواقيت الصلاة والأذان لمسجد الحوامدية',
          importance: Importance.max,
          priority: Priority.high,
          sound: const RawResourceAndroidNotificationSound('adhan'),
          playSound: true,
        );
        
        const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
          sound: 'adhan.caf', // Custom sound file for iOS bundle
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        
        final NotificationDetails details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );
        
        try {
          await _localNotifications.zonedSchedule(
            notificationId,
            'حان الآن موعد أذان $prayerName',
            'صلاة $prayerName في مدينة الحوامدية وضواحيها',
            tz.TZDateTime.from(time, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (e) {
          print('Failed to schedule exact notification: $e');
          try {
            await _localNotifications.zonedSchedule(
              notificationId,
              'حان الآن موعد أذان $prayerName',
              'صلاة $prayerName في مدينة الحوامدية وضواحيها',
              tz.TZDateTime.from(time, tz.local),
              details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
          } catch (err) {
            print('Failed to schedule inexact notification: $err');
          }
        }
      }
    }
  }
  
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
}
