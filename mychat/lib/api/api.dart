import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:mychat/models/chat_user.dart';
import 'package:mychat/models/message.dart';

class APIs {
  // STORING SELF INFO
  static late ChatUser me;
  // AUTH
  static FirebaseAuth auth = FirebaseAuth.instance;
  //FIREBASE DATABASE
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
// FOR PUSH NOTIFICATIONS FROM FIREBASE
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
//   FOR GETTING FIREBASE MESSAGE TOKEN
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
      }
    });
  }

//   CHECK IF USER EXIST
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //   FOR ADDING CHAT USER FOR OUR COVERSATION
  static Future<bool> addChatUserExists(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_chats')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }

//   RETURN CURRENT USER
  static User get user => auth.currentUser!;
  // FOR GETTING SELF INFO
  static Future<void> getSelfInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        // FOR SETTING USER STATUS TO ACTIVE
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

//   CREATING NEW USER
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey! I am new user",
        createdAt: time,
        id: user.uid,
        isOnline: false,
        lastActive: time,
        pushToken: '',
        email: user.email.toString());

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // FOR GETTING ALL KNOW USERS ID FROM FIREBASE DATABASE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_chats')
        .snapshots();
  }

  // FOR GETTING ALL USERS FROM FIREBASE DATABASE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    if (userIds.isNotEmpty) {
      return firestore
          .collection('users')
          .where('id', whereIn: userIds)
          .snapshots();
    } else {
      // Return an empty stream instead of querying Firestore
      return const Stream.empty();
    }
  }

  //FOR ADDING USER TO MY USER WHEN FIRST MSG IS SENT
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_chats')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // FOR UPDATING USER INFO
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // FOR UPDATING PROFILE PICTURE
  static Future<void> updateProfilePicture(File file) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dgzupiivv/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'proflie_upload'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));
    // UPLOADING IMAGE
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      // UPDATING IMAGE URL IN FIRESTORE
      me.image = jsonMap['url'];
      await firestore.collection('users').doc(user.uid).update({
        'image': me.image,
      });
    }
  }

  // GETTING SPECIFIC USER INFO
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // UPDATE ONLINE / LAST ACTIVE STATUS OF USER
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken
    });
  }

  ///**********CHAT SCREEN RELATED APIs*****************

  // GETTING CONV ID
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // FOR GETTING ALL MESSAGES OF SPECIFIC USER FROM FIREBASE DATABASE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

//   FOR SENDING MESSAGE
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    // MESSAGE SENDING TIME ALSO USED AS ID
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // MESSAGE TO SEND
    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: '',
        type: type,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

//   UPDATE READ STATUS OF MESSAGE
  static Future<void> updateReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

//   GETTING LAST MESSAGE OF SPECIFIC CHAT
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // SEND CHAT IMAGE
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dgzupiivv/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'chat_image'
      ..fields['folder'] = 'chats/${getConversationId(chatUser.id)}'
      ..fields['public_id'] = '${DateTime.now().microsecondsSinceEpoch}'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));
    // UPLOADING IMAGE
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      // UPDATING IMAGE URL IN FIRESTORE
      final imageUrl = jsonMap['secure_url'] ?? jsonMap['url'];
      await sendMessage(chatUser, imageUrl, Type.image);
    }
  }

//   DELETE MESSAGE FROM FIREBASE
  static Future<void> deleteMessage(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
  }
}
