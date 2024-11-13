import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initializationSettings  for Android

  static Future initNoti() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  static void initialize() {
    //, RemoteMessage message
    // initializationSettings  for Android

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
    );
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // print(message.data["_id"]);
        // print(message.notification);
        // _handlermessage(context, message);
      },

      // onDidReceiveBackgroundNotificationResponse: (details) =>
      //     _handlermessage(context, message),
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "ferantaCustomer", "pushnotificationappchannel",
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
      );

      await notificationsPlugin.show(
        0, //id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
      // }
    } on Exception catch (e) {
      print(e);
    }
  }

  static final androidChannel = const AndroidNotificationChannel(
      'ferantaCustomer', "pushnotificationappchannel",
      description: "This channel is important for notification",
      importance: Importance.defaultImportance);
  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }
}

_handlermessage(BuildContext context, RemoteMessage message) {
  if (message.data["_id"] != null) {}
}
