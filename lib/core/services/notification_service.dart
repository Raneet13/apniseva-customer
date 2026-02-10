import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static void initialize(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint("Notification received");
      },
    );
  }
}
