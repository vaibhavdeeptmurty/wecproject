import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs{
  // for auth
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}