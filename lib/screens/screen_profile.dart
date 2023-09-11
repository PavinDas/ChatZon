import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/api/apis.dart';
import 'package:chatzone/helper/dialogs.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/screens/auth/screen_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ScreenProfile extends StatefulWidget {
  final ChatUser user;
  const ScreenProfile({super.key, required this.user});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //* Hide keyboard while tap anywhere in the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 206, 240, 238),
        //* AppBar
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 77, 179, 162),
          //* Home Icon
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              size: 26,
              color: Colors.white,
            ),
          ),

          //* App Title
          title: const Text('My Profile'),
        ),

        //* LogOut Floating Button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 25,
            right: 20,
          ),
          child: FloatingActionButton.extended(
            onPressed: () async {
              //* For showing progress dialog
              Dialogs.showProgressBar(context);

              await APIs.updateActiveStatus(false);

              //* SignOut from app
              await APIs.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      //* For hiding progress dialog
                      Navigator.pop(context);

                      APIs.auth = FirebaseAuth.instance;

                      //* Replace profile scree with Login screen
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
            foregroundColor: Colors.white,
            label: const Text('LogOut'),
            backgroundColor: Color.fromARGB(255, 77, 179, 162),
          ),
        ),
        //* Body
        body: Container(
          child: Form(
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

                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image.toString()),
                                  height: mq.height * .2,
                                  width: mq.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  imageUrl: widget.user.image,
                                  height: mq.height * .2,
                                  width: mq.height * .2,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(
                                      CupertinoIcons.person,
                                    ),
                                  ),
                                ),
                              ),

                        //* Edit Icon on Profile Picture
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {
                              _showBottomSheet();
                            },
                            color: Colors.white,
                            elevation: 1,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 77, 179, 162),
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Color.fromARGB(255, 77, 179, 162),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.user.email,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
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
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 66, 88, 79),
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                      //* Name input field decoration
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 77, 179, 162),
                        ),
                        label: const Text(
                          'Name',
                          style: TextStyle(
                            color: Color.fromARGB(255, 77, 179, 162),
                          ),
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
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      style: const TextStyle(
                        color:Color.fromARGB(255, 66, 88, 79),
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),

                      //* About input field decoration
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Color.fromARGB(255, 77, 179, 162),
                        ),
                        label: const Text(
                          'About',
                          style: TextStyle(
                            color: Color.fromARGB(255, 77, 179, 162),
                          ),
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
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'UPDATE',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),

                      //* Update profile button decoration
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(
                          mq.width * .5,
                          mq.height * .06,
                        ),
                        backgroundColor: Color.fromARGB(255, 77, 179, 162),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //* Bottom sheet for picking a profile picture for user
  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return ListView(
          padding: EdgeInsets.only(
            top: mq.height * .03,
            bottom: mq.height * .05,
          ),
          children: [
            const Text(
              'Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(
              height: mq.height * .02,
            ),
            //* Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //* Image picker button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      mq.width * .3,
                      mq.height * .15,
                    ),
                  ),

                  //* Pick an image
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      print(
                          '\nImage Path: ${image.path} -- MimeType: ${image.mimeType}');

                      setState(
                        () {
                          _image = image.path;
                        },
                      );

                      APIs.updateProfilePicture(
                        File(_image!),
                      );

                      //* For hiding image picker
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/add_image.png'),
                ),

                //* Image capture button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      mq.width * .3,
                      mq.height * .15,
                    ),
                  ),

                  //* Capture an image
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);

                    if (image != null) {
                      print('\nImage Path: ${image.path}');

                      setState(
                        () {
                          _image = image.path;
                        },
                      );

                      APIs.updateProfilePicture(
                        File(_image!),
                      );

                      //* For hiding image picker
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/camera.png'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
