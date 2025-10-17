import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat/models/chat_user.dart';

class APIs{
  // for auth
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   for checking if user exists
  static Future<bool> userExists()async{
    return (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
    ).exists;
  }
//   to return current user
  static User get user => auth.currentUser!;
//   for creating new user
  static Future<void> createUser()async{
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
        email: user.email.toString()
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}