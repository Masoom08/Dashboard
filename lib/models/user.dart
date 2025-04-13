import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String password;
  final String name;

  UserModel({
    required this.userId,
    required this.email,
    required this.password,
    required this.name,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: (map['user_id'] ?? '').toString().trim(),
      email: (map['email'] ?? '').toString().trim(),
      password: (map['password'] ?? '').toString().trim(),
      name: (map['name'] ?? '').toString().trim(),
    );
  }
}
