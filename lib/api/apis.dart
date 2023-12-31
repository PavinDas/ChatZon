import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

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

  //* For accessing Firebase messaging (Push notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  //* For getting messaging firebase token
  static getFirebseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then(
      (t) {
        if (t != null) {
          me.pushToken = t;
          log('\nPush Token: $t');
        }
      },
    );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log('Got a message whilst in the foreground');
        log('Message data: ${message.data}');
        if (message.notification != null) {
          log('Message also contained a notification: ${message.notification}');
        }
      },
    );
  }

  //* For sending push notification
  static sendPushNotification(
    ChatUser chatUser,
    String msg,
  ) async {
    try {
      final body = {
        {
          "to": chatUser.pushToken,
          "notification": {
            "title": chatUser.name,
            "body": msg,
            "android_channel_id": "chats",
          },
          "data": {
            "some_data": "User ID: ${me.id}",
          },
        }
      };
      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAhg5kesg:APA91bGlKDRkczFaV1pJ2PunYd8d3xV_dqKpV7a-9hYnY0PdxHnfPW0Q-bpPqfjd3y3CyFO4VBpUp4Q2qPUKl0tfUTM4S9EC9SKWdZTgTzEuTB6Jepf3kRMgS9FcCskXj9tQAoiw9lAg',
          },
          body: jsonEncode(body));

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotificationE: $e');
    }
  }

  //* For checking user is existing or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //* For adding new user to chat
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //? User Exist

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      //? User Doesn't Exist
      return false;
    }
  }

  //* For getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
          await getFirebseMessagingToken();
          //* For setting user status to active
          APIs.updateActiveStatus(true);
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
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: userIds)
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //* For getting knows users id from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  //* For sending first message to add a new user
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then(
      (value) => sendMessage(
        chatUser,
        msg,
        type,
      ),
    );
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

  //* For getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  //* For update online or active status of user
  static updateActiveStatus(bool isOnline) async {
    return firestore.collection('users').doc(user.uid).update(
      {
        'is_online': isOnline,
        'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
        'push_token': me.pushToken,
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
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //* For sending message
  static sendMessage(ChatUser chatUser, String msg, Type type) async {
    //* Message sending time ( Also used as ID )
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //* Message to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
    );

    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then(
          (value) => sendPushNotification(
              chatUser, type == Type.text ? msg : 'Send you an image'),
        );
  }

  //* Update read status of message
  static updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update(
      {
        'read': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }

  //* Get only last message of specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //* Send image in chat
  static sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'image/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //* Upload image
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

    //* Updating image in firestore database
    final imageURL = await ref.getDownloadURL();
    await sendMessage(chatUser, imageURL, Type.image);
  }

  //* Delete message
  static deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

//* Edit message
  static editMessage(Message message, String editedMsg) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': editedMsg});
  }
}
