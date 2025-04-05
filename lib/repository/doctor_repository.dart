import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor.dart';

class DoctorRepository {
  final String baseUrl = "https://your-api-url.com"; // API ka actual URL yahan dalna

  Future<Map<String, dynamic>> fetchDoctors(int page) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/doctors?page=$page"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Doctor> doctors = (data['doctors'] as List).map((doc) => Doctor.fromJson(doc)).toList();
        int totalPages = data['totalPages'];

        return {
          'doctors': doctors,
          'totalPages': totalPages,
        };
      } else {
        throw Exception("Failed to load doctors: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching doctors: ${e.toString()}");
    }
  }
}
