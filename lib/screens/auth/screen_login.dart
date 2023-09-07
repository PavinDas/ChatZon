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
  _handleGoogleButtonClick() {
    _signInWithGoogle().then(
      (user) {
        print('\nuser: ${user.user}');
        print('\nuserAdditionalInfo: ${user.additionalUserInfo}');
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

  Future<UserCredential> _signInWithGoogle() async {
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
          Positioned(
            top: mq.height * .15,
            left: mq.width * .26,
            width: mq.width * .5,
            child: Image.asset('assets/images/icon.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              onPressed: () {
                _handleGoogleButtonClick();
              },
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
