import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../repository/doctor_repository.dart';

class DoctorViewModel extends ChangeNotifier {
  final DoctorRepository _repository;

  List<Doctor> _doctors = [];
  List<Doctor> _serviceAgreedDoctors = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCategory = '';

  List<Doctor> get doctors => _doctors;
  List<Doctor> get serviceAgreedDoctors => _serviceAgreedDoctors;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  DoctorViewModel({DoctorRepository? repository})
      : _repository = repository ?? DoctorRepository() {
    fetchDoctors(); // Will also trigger fetchDoctorsByServiceAgreement inside
  }

  Future<void> fetchDoctors() async {
    _setLoading(true);
    _errorMessage = '';
    notifyListeners();

    try {
      final fetchedDoctors = await _repository.fetchDoctorsFromFirestore();
      _doctors = fetchedDoctors;
      _totalPages = (_doctors.length / 10).ceil();
      _currentPage = 1;

      // ✅ Automatically fetch serviceAgreedDoctors after loading all
      await fetchDoctorsByServiceAgreement();
    } catch (e) {
      _errorMessage = 'Failed to load doctors: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchDoctorsByServiceAgreement() async {
    _errorMessage = '';
    try {
      final filteredDoctors = await _repository.fetchDoctorsByServiceAgreed(isAgreed: false);
      _serviceAgreedDoctors = filteredDoctors;
      _totalPages = (_serviceAgreedDoctors.length / 10).ceil();
      _currentPage = 1;
    } catch (e) {
      _errorMessage = 'Failed to load doctors by service agreement: ${e.toString()}';
    }
    notifyListeners();
  }

  List<Doctor> getFilteredDoctors(String department) {
    if (department.isEmpty) {
      return _doctors;
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
      fetchDoctorsForCurrentPage();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchDoctorsForCurrentPage();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void fetchDoctorsForCurrentPage() {
    try {
      final doctorsForPage = _doctors.sublist(
        (_currentPage - 1) * 10,
        (_currentPage * 10 <= _doctors.length) ? _currentPage * 10 : _doctors.length,
      );
      _doctors = doctorsForPage;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch doctors for the current page: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateServiceAgreedStatus(String doctorId) async {
    _setLoading(true);
    try {
      await _repository.updateDoctorServiceAgreedStatus(doctorId);
      await fetchDoctors(); // 🔁 Updates both all doctors and filtered list
    } catch (e) {
      _errorMessage = 'Failed to update service agreed status: ${e.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      return await _repository.fetchDoctorById(doctorId);
    } catch (e) {
      _errorMessage = 'Failed to fetch doctor: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
}
