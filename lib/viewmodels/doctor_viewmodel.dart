import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../repository/doctor_repository.dart';

class DoctorViewModel extends ChangeNotifier {
  final DoctorRepository _repository;
  List<Doctor> _doctors = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCategory = '';

  // Getters
  List<Doctor> get doctors => _doctors;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  // Constructor
  DoctorViewModel({DoctorRepository? repository})
      : _repository = repository ?? DoctorRepository() {
    fetchDoctors();
  }

  // Fetch doctors (dummy data for now)
  Future<void> fetchDoctors() async {
    _setLoading(true);
    _errorMessage = '';
    notifyListeners();

    try {
      _doctors = _getMockDoctors();
      _totalPages = 1;
    } catch (e) {
      _errorMessage = 'Failed to load doctors: ${e.toString()}';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Filtering doctors based on selected department/category
  List<Doctor> getFilteredDoctors(String department) {
    return _doctors
        .where((doctor) => doctor.departments.contains(department))
        .toList();
  }

  // Set category for filtering (e.g., from dropdown/tab)
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Pagination
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

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Dummy data
  List<Doctor> _getMockDoctors() {
    return [
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
  }
}
