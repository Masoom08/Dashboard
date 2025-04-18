import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';


class TotalUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchAllUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
  }

  Future<int> getUserCount() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.size;
  }
}
