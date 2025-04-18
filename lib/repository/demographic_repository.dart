import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class DemographicsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users from Firestore
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        return UserModel.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to fetch users');
    }
  }
}
