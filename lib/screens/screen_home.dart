import 'package:flutter/material.dart';

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
          onPressed: () {},
          child: const Icon(Icons.message),
        ),
      ),
    );
  }
}
