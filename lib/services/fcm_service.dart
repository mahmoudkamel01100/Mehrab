import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling background message: ${message.messageId}");
}

class FcmService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    try {
      // 1. Initialize Firebase App
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint("Firebase.initializeApp failed: $e");
      return; // Can't continue without Firebase
    }

    try {
      // 2. Set the background messaging handler early on
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 3. Request user notification permission (critical for Android 13+)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('User notification permission status: ${settings.authorizationStatus}');

      // 4. Subscribe automatically to general topic "all"
      // This allows sending announcements to every app user at once from Firebase Console!
      await _firebaseMessaging.subscribeToTopic('all');
      debugPrint('Successfully subscribed to topic: all');

      // 5. Handle foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint('Message notification title: ${message.notification?.title}');
          debugPrint('Message notification body: ${message.notification?.body}');
        }
      });
    } catch (e) {
      debugPrint("Error initializing Firebase Cloud Messaging: $e");
    }
  }

  // Get device FCM token (for debugging/targeted testing)
  static Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
      return null;
    }
  }
}
