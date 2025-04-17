import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> loginUser(String email, String password) async {
    print('🟡 Attempting login for email: $email');

    try {
      final snapshot = await _firestore
          .collection('users') // ✅ Ensure correct collection
          .where('email', isEqualTo: email.trim())
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final user = UserModel.fromMap(data);

        print('✅ User found in Firestore: ${user.email}');
        print('🔐 Firestore password: "${user.password}", Input password: "$password"');

        if (user.password == password.trim()) {
          print('✅ Password matched. Login successful for $email');
          return user;
        } else {
          print('❌ Password mismatch for $email');
        }
      } else {
        print('🚫 No user found with email: $email');
      }

      return null;
    } catch (e) {
      print('🔥 Exception during login: $e');
      throw Exception('Login failed: $e');
    }
  }
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('🔥 Error fetching all users: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }

}
