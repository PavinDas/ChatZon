import 'dart:io';

import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  //* For authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //* Accessing cloud FireStore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //*  Accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

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

  //* Update profile picture
  static updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    print('\n Extension $ext');
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(
      file,
      SettableMetadata(contentType: 'image/$ext'),
    )
        .then(
      (p0) {
        print('\nData Transfered: ${p0.bytesTransferred / 1000} kb');
      },
    );
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update(
      {
        'image': me.image,
      },
    );
  }

  //! ************************* Chat Screen Related APIs *************************** !\\

  //*chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  //* Useful for getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //* For getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .snapshots();
  }

  //* For sending message
  static sendMessage(ChatUser chatUser, String msg) async {
    //* Message sending time ( Also used as ID )
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //* Message to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: Type.text,
      fromId: user.uid,
      sent: time,
    );

    final ref =
        firestore.collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
