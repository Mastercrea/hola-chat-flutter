import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late FlutterLocalNotificationsPlugin fltrNotification;

  void showNotification(String title, String body) async{

    const androidDetails = AndroidNotificationDetails("channelId", "Test", channelDescription: "this is my channel", importance: Importance.max);
    const iOSDetails = IOSNotificationDetails();
    const generalNotificationsDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);
    fltrNotification = FlutterLocalNotificationsPlugin();
    await fltrNotification.show(0, title, body, generalNotificationsDetails);
  }
