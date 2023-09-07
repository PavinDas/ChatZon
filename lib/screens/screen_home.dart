import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* AppBar
      appBar: AppBar(
        //* Home Icon
        leading: const Icon(
          Icons.home,
          size: 26,
        ),

        //* App Title
        title: const Text('ChatZon'),
        actions: [
          //* Search Button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),

          //* More Button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      //* Add user Floating Button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 25,
          right: 20,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.message),
        ),
      ),
    );
  }
}
