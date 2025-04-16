import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all doctors from Firestore
  Future<List<Doctor>> fetchDoctorsFromFirestore() async {
    final snapshot = await _firestore.collection('doctors').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Doctor.fromMap(data..['id'] = doc.id); // Ensure ID is included
    }).toList();
  }

  // Fetch a specific doctor by ID
  Future<Doctor?> fetchDoctorById(String doctorId) async {
    final doc = await _firestore.collection('doctors').doc(doctorId).get();

    if (doc.exists) {
      final data = doc.data()!;
      return Doctor.fromMap(data..['id'] = doc.id);
    } else {
      return null;
    }
  }

  // Update the `service_agreed` field to true
  Future<void> updateDoctorServiceAgreedStatus(String doctorId) async {
    await _firestore.collection('doctors').doc(doctorId).update({
      'service_agreed': true,
    });
  }

  Future<List<Doctor>> fetchDoctorsByServiceAgreed({required bool isAgreed}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('service_agreed', isEqualTo: isAgreed)
        .get();

    return snapshot.docs.map((doc) => Doctor.fromMap(doc.data())).toList();
  }

}
