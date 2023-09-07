import 'dart:io';
import 'package:chatzone/api/apis.dart';
import 'package:chatzone/helper/dialogs.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/screens/screen_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  //* Actions for LogIn button
  _handleGoogleButtonClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then(
      (user) async {
        Navigator.pop(context);
        if (user != null) {
          print('\nuser: ${user.user}');
          print('\nuserAdditionalInfo: ${user.additionalUserInfo}');

          if ((await APIs.userExist())) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ScreenHome();
                },
              ),
            );
          } else {
            await APIs.createUser().then(
              (value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ScreenHome();
                    },
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  //* Firebase authenticator auto generated method
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(
          context, 'Something went wrong. Check internet connection');
      return null;
    }
  }

  //* SignOut Function
  // _signOut() async{
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //* AppBar
      appBar: AppBar(
        //* App Title
        title: const Text('Welcome to ChatZon'),
      ),
      body: Stack(
        children: [
          //* App Icon
          Positioned(
            top: mq.height * .15,
            left: mq.width * .26,
            width: mq.width * .5,
            child: Image.asset('assets/images/icon.png'),
          ),

          //* Google LogIp icon
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              onPressed: () {
                _handleGoogleButtonClick();
              },

              //* Google png logo
              icon: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset('assets/images/google.png'),
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16),
                  children: [
                    TextSpan(text: 'LogIn with '),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
