import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/service.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference servicesCollection =
  FirebaseFirestore.instance.collection('services');

  // Fetch all services
  Future<List<DoctorService>> getAllServices() async {
    try {
      QuerySnapshot querySnapshot = await servicesCollection.get();
      return querySnapshot.docs
          .map((doc) => DoctorService.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error fetching services: $e");
    }
  }

  // Fetch services by doctor ID
  Future<List<DoctorService>> getServicesByDoctor(String doctorId) async {
    try {
      QuerySnapshot querySnapshot =
      await servicesCollection.where('doctor_id', isEqualTo: doctorId).get();
      return querySnapshot.docs
          .map((doc) => DoctorService.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error fetching doctor's services: $e");
    }
  }

  // Add a new service
  Future<void> addService(DoctorService service) async {
    try {
      await servicesCollection.add(service.toMap());
    } catch (e) {
      throw Exception("Error adding service: $e");
    }
  }

  // Update an existing service
  Future<void> updateService(String serviceId, Map<String, dynamic> updatedData) async {
    try {
      await servicesCollection.doc(serviceId).update(updatedData);
    } catch (e) {
      throw Exception("Error updating service: $e");
    }
  }

  // Delete a service (soft delete)
  Future<void> deleteService(String serviceId) async {
    try {
      await servicesCollection.doc(serviceId).update({'isDeleted': true});
    } catch (e) {
      throw Exception("Error deleting service: $e");
    }
  }
}
