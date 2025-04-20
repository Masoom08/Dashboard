import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String password;
  final String name;
  final String profilePicUrl;
  final String state; // Added state field
  final String createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.password,
    required this.name,
    required this.profilePicUrl,
    required this.state, // Constructor to initialize state
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: (map['user_id'] ?? '').toString().trim(),
      email: (map['email'] ?? '').toString().trim(),
      password: (map['password'] ?? '').toString().trim(),
      name: (map['name'] ?? '').toString().trim(),
      profilePicUrl: (map['profile_pic_url'] ?? '').toString().trim(),
      state: (map['state'] ?? '').toString().trim(), // Map state from Firestore
      createdAt: (map['created_at'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'password': password,
      'name': name,
      'profile_pic_url': profilePicUrl,
      'state': state, // Add state to Firestore map
      'created_at' : createdAt,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }
}
