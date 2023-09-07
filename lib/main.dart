import 'package:chatzone/screens/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
      title: 'ChatZone',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
}
