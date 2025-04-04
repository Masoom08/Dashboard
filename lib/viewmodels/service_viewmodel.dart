import 'package:flutter/material.dart';
import '../models/service.dart';
import '../repository/service_repository.dart';

class ServiceViewModel extends ChangeNotifier {
  final ServiceRepository _repository = ServiceRepository();
  List<DoctorService> _services = [];
  bool _isLoading = false;

  List<DoctorService> get services => _services;
  bool get isLoading => _isLoading;

  // Fetch all services
  Future<void> fetchAllServices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await _repository.getAllServices();
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch doctor's services
  Future<void> fetchDoctorServices(String doctorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await _repository.getServicesByDoctor(doctorId);
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
