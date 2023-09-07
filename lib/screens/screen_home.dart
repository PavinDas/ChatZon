import 'dart:convert';

import 'package:chatzone/api/apis.dart';
import 'package:chatzone/main.dart';
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
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.message),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          final list = [];

          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            for (var i in data!) {
              print('\nData: ${jsonEncode(i.data())}');
              list.add(i.data()['about']);
            }
          }
          return ListView.builder(
            itemCount: list.length,
            padding: EdgeInsets.only(top: mq.height * .008),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              //? return const ChatUserCard();
              return Text('Name: ${list[index]}');
            },
          );
        },
      ),
    );
  }
}
