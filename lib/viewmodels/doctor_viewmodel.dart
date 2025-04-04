import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../repository/doctor_repository.dart';

class DoctorViewModel extends ChangeNotifier {
  final DoctorRepository _repository = DoctorRepository();
  DoctorModel? _doctor;
  bool _isLoading = false;

  DoctorModel? get doctor => _doctor;
  bool get isLoading => _isLoading;

  // Fetch doctor from Firebase
  Future<void> fetchDoctor(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _doctor = await _repository.getDoctor(userId);
    } catch (e) {
      print("Error fetching doctor: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new doctor
  Future<void> addDoctor(DoctorModel doctor) async {
    try {
      await _repository.addDoctor(doctor);
    } catch (e) {
      print("Error adding doctor: $e");
    }
  }

  // Update doctor
  Future<void> updateDoctor(String userId, Map<String, dynamic> updates) async {
    try {
      await _repository.updateDoctor(userId, updates);
      fetchDoctor(userId); // Refresh data
    } catch (e) {
      print("Error updating doctor: $e");
    }
  }

  // Delete doctor
  Future<void> deleteDoctor(String userId) async {
    try {
      await _repository.deleteDoctor(userId);
      _doctor = null;
      notifyListeners();
    } catch (e) {
      print("Error deleting doctor: $e");
    }
  }
}
