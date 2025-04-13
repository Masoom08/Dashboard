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

  // Factory method to create a UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: (map['user_id'] ?? '').toString().trim(),
      email: (map['email'] ?? '').toString().trim(),
      password: (map['password'] ?? '').toString().trim(),
      name: (map['name'] ?? '').toString().trim(),
    );
  }

  // Method to convert UserModel into a Map for Firestore saving
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'password': password,
      'name': name,
    };
  }

  // Optional: Method to create a UserModel from Firestore document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  // Optional: Method to easily convert a UserModel to a string
  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, name: $name)';
  }
}
