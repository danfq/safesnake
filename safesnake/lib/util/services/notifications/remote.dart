import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:safesnake/util/help/handler.dart';

///Remote Notifications
class RemoteNotifications {
  ///Service
  static final FlutterLocalNotificationsPlugin _service =
      FlutterLocalNotificationsPlugin();

  ///Initialize Service
  static Future<void> init() async {
    //Notification Settings
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("app_icon"),
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: _onNewNotifIOS,
      ),
    );

    //Initialize
    await _service.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotifResponse,
    );
  }

  ///Show Notification
  static Future<void> showNotif(RemoteNotification notif) async {
    //Show Notification
    await _service.show(
      14,
      notif.title,
      notif.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "safesnake_14",
          "SafeSnake",
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );

    //Check for High-Alert Mode
    if (notif.title == "Quick!" || notif.title == "Rápido!") {
      //Play Alert
      await HelpHandler.highAlertNotif();
    }
  }

  ///On Notification Response
  static void _onNotifResponse(NotificationResponse response) async {}

  ///On New Notification (iOS)
  static void _onNewNotifIOS(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    await showAdaptiveDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title ?? "SafeSnake"),
        content: Text(body ?? "A Loved One needs some help!"),
      ),
    );
  }
}
