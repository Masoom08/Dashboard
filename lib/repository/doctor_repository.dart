import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchDoctorsFromFirestore() async {
    final snapshot = await _firestore.collection('doctors').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Doctor.fromMap(data);
    }).toList();
  }
}
