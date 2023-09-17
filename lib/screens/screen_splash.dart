import 'dart:developer';

import 'package:chatzone/api/apis.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/screens/auth/screen_login.dart';
import 'package:chatzone/screens/screen_home.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    
      //* Checking the user is existing or not
    Future.delayed(const Duration(seconds: 2), () {

      if (APIs.auth.currentUser != null) {
        log('\nuser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenHome(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenLogin(),
          ),
        );
      }
    });
  }

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      //* AppBar
      appBar: AppBar(
        //* App Title
        title: const Text(''), backgroundColor: Colors.indigo[50], elevation: 0,
      ),

      //* Body
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            left: mq.width * .26,
            width: mq.width * .5,
            child: Image.asset('assets/images/icon.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Center(
              child: Text(
                'Welcome',
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
