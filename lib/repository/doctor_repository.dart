
import '../models/doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference doctorsCollection =
  FirebaseFirestore.instance.collection('doctors');

  // Add a new doctor
  Future<void> addDoctor(DoctorModel doctor) async {
    try {
      await doctorsCollection.doc(doctor.userId).set(doctor.toMap());
    } catch (e) {
      throw Exception("Failed to add doctor: $e");
    }
  }

  // Get doctor by ID
  Future<DoctorModel?> getDoctor(String userId) async {
    try {
      DocumentSnapshot doc = await doctorsCollection.doc(userId).get();
      if (doc.exists) {
        return DoctorModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get doctor: $e");
    }
  }

  // Update doctor details
  Future<void> updateDoctor(String userId, Map<String, dynamic> updates) async {
    try {
      await doctorsCollection.doc(userId).update(updates);
    } catch (e) {
      throw Exception("Failed to update doctor: $e");
    }
  }

  // Soft delete a doctor
  Future<void> deleteDoctor(String userId) async {
    try {
      await doctorsCollection.doc(userId).update({'is_deleted': true});
    } catch (e) {
      throw Exception("Failed to delete doctor: $e");
    }
  }
}
