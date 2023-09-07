import 'package:chatzone/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //* For authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //* Accessing cloud FireStore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //* Return current user
  static User get user => auth.currentUser!;

  //* For checking user is existing or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //*  For creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      about: 'Hey I am using ChatZon',
      createdAt: time,
      id: user.uid,
      isOnline: auth.currentUser!.isAnonymous,
      lastActive: time,
      pushToken: '',
      email: user.email.toString(),
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}
