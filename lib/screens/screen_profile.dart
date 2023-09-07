import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/api/apis.dart';
import 'package:chatzone/helper/dialogs.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/screens/auth/screen_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ScreenProfile extends StatefulWidget {
  final ChatUser user;
  const ScreenProfile({super.key, required this.user});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //* Hide keyboard while tap anywhere in the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //* AppBar
        appBar: AppBar(
          //* Home Icon
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              size: 26,
            ),
          ),

          //* App Title
          title: const Text('Profile'),
        ),

        //* Add user Floating Button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 25,
            right: 20,
          ),
          child: FloatingActionButton.extended(
            onPressed: () async {
              //* For showing progress dialog
              Dialogs.showProgressBar(context);

              //* SignOut from app
              await APIs.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScreenLogin(),
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('LogOut'),
            backgroundColor: Colors.red[400],
          ),
        ),
        //* Body
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * .05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Stack(
                    children: [
                      //* Profile Picture
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          height: mq.height * .2,
                          width: mq.height * .2,
                          imageUrl: widget.user.image,
                          fit: BoxFit.fill,
                          placeholder: (context, url) {
                            return const CircularProgressIndicator();
                          },
                          errorWidget: (context, url, error) {
                            return const CircleAvatar(
                              child: Icon(
                                CupertinoIcons.person,
                              ),
                            );
                          },
                        ),
                      ),

                      //* Edit Icon on Profile Picture
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {},
                          color: Colors.white,
                          elevation: 1,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),

                  //* User mail text
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),

                  //* Name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                    //* Name input field decoration
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.deepPurple,
                      ),
                      label: const Text(
                        'Name',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),

                  //* About input field
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),

                    //* About input field decoration
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: Colors.deepPurple,
                      ),
                      label: const Text(
                        'About',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),

                  //* Update profile button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then(
                          (value) {
                            Dialogs.showSnackbar(context, 'Profile Updated');
                          },
                        );
                      }
                    },
                    icon: const Icon(Icons.done),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 19),
                    ),

                    //* Update profile button decoration
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(
                          mq.width * .5,
                          mq.height * .06,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
