import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserFirebaseServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUser() async* {
    yield* _firebaseFirestore.collection("users").snapshots();
  }

  Future<void> addUser(String fullName) async {
    Map<String, dynamic> data = {
      "user-id": FirebaseAuth.instance.currentUser!.uid,
      "user-fullname": fullName,
      "user-email": FirebaseAuth.instance.currentUser!.email,
      "user-token": await FirebaseMessaging.instance.getToken(),
    };
    await _firebaseFirestore.collection("users").add(data);
  }

  Future<void> updateUser(
      { required String uid,required String name,required String email}) async {
    await _firebaseFirestore.collection('users').doc(uid).update({
      "user-name": name,
      "user-email": email,
    });
  }
}