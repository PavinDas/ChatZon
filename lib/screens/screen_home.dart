import 'package:chatzone/api/apis.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/screens/screen_profile.dart';
import 'package:chatzone/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  //* For store all users
  List<ChatUser> _list = [];

  //* For store search items
  final List<ChatUser> _searchList = [];

  //* For store search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //* For hide keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //* If search is on & back button is pressed when search
        //* or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(
              () {
                _isSearching = !_isSearching;
              },
            );
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //* AppBar
          appBar: AppBar(
            //* Home Icon
            leading: const Icon(
              Icons.home,
              size: 26,
            ),

            //* App Title
            title: _isSearching
                ? TextFormField(
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, letterSpacing: .5),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ' Enter Name or Email',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(.4),
                      ),
                    ),
                    onChanged: (val) {
                      //* logic for Search

                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(
                                  val.toLowerCase(),
                                ) ||
                            i.email.toLowerCase().contains(
                                  val.toLowerCase(),
                                )) {
                          _searchList.add(i);
                        }
                        setState(
                          () {
                            _searchList;
                          },
                        );
                      }
                    },
                    autofocus: true,
                  )
                : const Text('ChatZon'),
            actions: [
              //* Search Button
              IconButton(
                onPressed: () {
                  setState(
                    () {
                      _isSearching = !_isSearching;
                    },
                  );
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                ),
              ),

              //* More Button
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenProfile(user: APIs.me),
                    ),
                  );
                },
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

          //* Body of App
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //* if Data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                //* if Some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      padding: EdgeInsets.only(top: mq.height * .008),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index]);
                        //return Text('Name: ${list[index]}');
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No connection found!',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
