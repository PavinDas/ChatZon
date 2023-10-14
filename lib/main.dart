import 'package:chatzone/screens/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'firebase_options.dart';
import 'dart:developer';

//* Global object to get device screen size
late Size mq;

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  _initFirebase();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatZone',
      theme: ThemeData(
        primarySwatch:  Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 23,
          ),
        ),
      ),
      home: const ScreenSplash(),
    );
  }
}

//* Firebase initialize in flutter
_initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
    
);
log('\n Notification Channel result : $result');
}
