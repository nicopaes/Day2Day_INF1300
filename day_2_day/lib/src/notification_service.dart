import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "123";

  ///
  ///
  ///
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('clockwork');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }

  void showNotification() async {
    await flutterLocalNotificationsPlugin.show(
        1.hashCode,
        "Title",
        "Body",
        const NotificationDetails(
            android: AndroidNotificationDetails(NotificationService.channel_id,
                "Day2Day", 'To remind you about upcoming birthdays')),
        payload: jsonEncode("Test"));
  }

  void showNotificationCustom(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
        title.hashCode,
        title,
        body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                NotificationService.channel_id, "Day2Day", "custom")),
        payload: jsonEncode(title + " " + body));
  }

  void scheduleNotification(/*TimeOfDay userHour*/) async {
    DateTime now = DateTime.now();
    DateTime after = now.add(const Duration(minutes: 2));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        2.hashCode,
        "Reminder now",
        "Test future notification",
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                channel_id, 'Day2Day', 'TEST SCHEDUALE')),
        uiLocalNotificationDateInterpretation: null,
        androidAllowWhileIdle: null);
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    return notificationAppLaunchDetails.didNotificationLaunchApp;
  }
}
