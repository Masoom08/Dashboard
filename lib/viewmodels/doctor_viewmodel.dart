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

  /// Fetch doctors from Firestore
  Future<void> fetchDoctors() async {
    _setLoading(true);
    _errorMessage = '';
    notifyListeners();

    try {
      final fetchedDoctors = await _repository.fetchDoctorsFromFirestore();
      _doctors = fetchedDoctors;
      _totalPages = (_doctors.length / 10).ceil(); // Pagination logic based on page size (10 per page)
    } catch (e) {
      _errorMessage = 'Failed to load doctors: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Filter by department (category)
  List<Doctor> getFilteredDoctors(String department) {
    if (department.isEmpty) {
      return _doctors; // Return all doctors if no specific category is selected
    }
    return _doctors.where((doctor) => doctor.departments.contains(department)).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
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

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to get doctors for the current page with pagination
  List<Doctor> getDoctorsForCurrentPage() {
    int startIndex = (_currentPage - 1) * 10;
    int endIndex = startIndex + 10;
    return _doctors.sublist(startIndex, endIndex < _doctors.length ? endIndex : _doctors.length);
  }
}
