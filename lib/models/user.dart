import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String email;
  String phone;
  int age;
  String gender;
  String profilePicUrl;
  bool isLoggedIn;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.profilePicUrl,
    required this.isLoggedIn,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['user_id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      profilePicUrl: data['profile_pic_url'] ?? '',
      isLoggedIn: data['is_logged_in'] ?? false,
      isDeleted: data['is_deleted'] ?? false,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // Convert UserModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'profile_pic_url': profilePicUrl,
      'is_logged_in': isLoggedIn,
      'is_deleted': isDeleted,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}
