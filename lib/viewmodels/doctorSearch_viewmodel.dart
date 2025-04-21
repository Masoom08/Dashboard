import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../repository/doctor_search_repository.dart';


class DoctorSearchViewModel extends ChangeNotifier {
  final DoctorSearchRepository _repository;


  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  String _searchQuery = '';

  DoctorSearchViewModel({DoctorSearchRepository? repository})
      : _repository = repository ?? DoctorSearchRepository() {
    _fetchAllDoctors();
  }

  List<Doctor> get filteredDoctors => _filteredDoctors;
  String get searchQuery => _searchQuery;

  Future<void> _fetchAllDoctors() async {
    try {
      _allDoctors = await _repository.fetchAllDoctors();
      _filteredDoctors = _allDoctors;
      notifyListeners();
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  void searchDoctors(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredDoctors = _allDoctors;
    } else {
      _filteredDoctors = _allDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
            doctor.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
