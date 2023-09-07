import 'package:chatzone/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //* For authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //* Accessing cloud FireStore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //* For storing current Information
  static late ChatUser me;

  //* Return current user
  static User get user => auth.currentUser!;

  //* For checking user is existing or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //* For getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then(
      (user) {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
          print('\nMy Data: ${user.data()}');
        } else {
          createUser().then(
            (value) => getSelfInfo(),
          );
        }
      },
    );
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

  //* For getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //* For updating user info
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update(
      {
        'name': me.name,
        'about': me.about,
      },
    );
  }
}
