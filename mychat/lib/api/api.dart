import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mychat/models/chat_user.dart';

class APIs {
  // STORING SELF INFO
  static late ChatUser me;
  // AUTH
  static FirebaseAuth auth = FirebaseAuth.instance;
  //FIREBASE DATABASE
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

//   CHECK IF USER EXIST
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
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
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

//   CREATING NEW USER
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
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

  // FOR GETTING ALL USERS FROM FIREBASE DATABASE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
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
}
