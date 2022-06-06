import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/routes/routes.dart';

import 'helpers/show_notification.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin fltrNotification;

  @override
  void initState() {
    super.initState();
    initializeLocalNotification();

  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService()),
        ChangeNotifierProvider(create: ( _ ) => SocketService()),
        ChangeNotifierProvider(create: ( _ ) => ChatService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
  void initializeLocalNotification(){
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const iOSInitilize = IOSInitializationSettings();
    const initializationsSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iOSInitilize);
    fltrNotification = FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initializationsSettings);
  }
}

