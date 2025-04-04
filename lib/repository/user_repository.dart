
import '../models/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  // Add a new user
  Future<void> addUser(UserModel user) async {
    try {
      await usersCollection.doc(user.userId).set(user.toMap());
    } catch (e) {
      throw Exception("Failed to add user: $e");
    }
  }

  // Get a user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get user: $e");
    }
  }

  // Update user details
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await usersCollection.doc(userId).update(updates);
    } catch (e) {
      throw Exception("Failed to update user: $e");
    }
  }

  // Soft delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).update({'is_deleted': true});
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }
}
