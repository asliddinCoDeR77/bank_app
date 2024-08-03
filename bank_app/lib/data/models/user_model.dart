import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String fullName;
  String email;

  User({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory User.fromJson(QueryDocumentSnapshot json) {
    return User(
      id: json["user-id"],
      fullName: json["user-fullName"],
      email: json["user-email"],
    );
  }
}