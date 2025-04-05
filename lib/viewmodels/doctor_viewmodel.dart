import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../repository/doctor_repository.dart';
import 'package:http/http.dart' as http;

class DoctorViewModel extends ChangeNotifier {
  final DoctorRepository _repository = DoctorRepository();
  List<Doctor> _doctors = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Doctor> get doctors => _doctors;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  DoctorViewModel() {
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Firebase setup abhi nahi hai, toh yahan default data use karenge
      _doctors = [
        Doctor(
          name: "Dr. Anjali Verma",
          email: "anjali.verma@example.com",
          gender: "Female",
          profilePicUrl: "https://randomuser.me/api/portraits/women/2.jpg",
          profession: "Cardiologist",
          state: "Delhi",
          departments: ["Cardiology"],
          languages: ["English", "Hindi"],
          experience: 8,
          isSurgeon: false,
          isOnline: false,
          isLoggedIn: false,
          isTermsAgreed: true,
          isDeleted: false,
          registrationStatus: "Approved",
          educationDocUrl: "",
          medicalProofUrl: "",
          idUrl: "",
          userId: "123456",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Doctor(
          name: "Dr. Ramesh Kapoor",
          email: "ramesh.kapoor@example.com",
          gender: "Male",
          profilePicUrl: "https://randomuser.me/api/portraits/men/3.jpg",
          profession: "Orthopedic Surgeon",
          state: "Mumbai",
          departments: ["Orthopedics"],
          languages: ["English", "Marathi"],
          experience: 15,
          isSurgeon: true,
          isOnline: true,
          isLoggedIn: true,
          isTermsAgreed: true,
          isDeleted: false,
          registrationStatus: "Pending",
          educationDocUrl: "",
          medicalProofUrl: "",
          idUrl: "",
          userId: "654321",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      _totalPages = 1; // Since it's dummy data
    } catch (e) {
      _errorMessage = 'Failed to load doctors: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      fetchDoctors();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchDoctors();
    }
  }
}
