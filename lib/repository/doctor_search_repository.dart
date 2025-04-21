import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorSearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchAllDoctors() async {
    final doctorSnapshot = await _firestore.collection('doctors').get();
    List<Doctor> allDoctors = [];

    for (var doc in doctorSnapshot.docs) {
      final data = doc.data();
      final doctorId = doc.id;

      final walletDoc = await _firestore.collection('wallets')
          .doc(doctorId)
          .get();
      final balance = walletDoc.exists ? walletDoc['balance'] ?? 0.0 : 0.0;

      final userDoc = await _firestore.collection('users').doc(doctorId).get();
      final phone = userDoc.exists ? userDoc['phone'] ?? '' : '';

      data['phone'] = phone;
      allDoctors.add(Doctor.fromMap(data, balance: balance));
    }

    return allDoctors;
  }
}
