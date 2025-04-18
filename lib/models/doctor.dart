import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String name;
  final String email;
  final String gender;
  final String profilePicUrl;
  final String profession;
  final String state;
  final List<String> departments;
  final List<String> languages;
  final String experience;
  final String isSurgeonString;
  final bool isSurgeon;
  final bool isOnline;
  final bool isLoggedIn;
  final bool isTermsAgreed;
  final bool isDeleted;
  final String registrationStatus;
  final String educationDoc;
  final String educationDocUrl;
  final String medicalProof;
  final String medicalProofUrl;
  final String idUrl;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phone;
  final double balance;  // New balance field

  Doctor({
    required this.name,
    required this.email,
    required this.gender,
    required this.profilePicUrl,
    required this.profession,
    required this.state,
    required this.departments,
    required this.languages,
    required this.experience,
    required this.isSurgeonString,
    required this.isSurgeon,
    required this.isOnline,
    required this.isLoggedIn,
    required this.isTermsAgreed,
    required this.isDeleted,
    required this.registrationStatus,
    required this.educationDoc,
    required this.educationDocUrl,
    required this.medicalProof,
    required this.medicalProofUrl,
    required this.idUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.phone,
    required this.balance,  // Balance passed here
  });

  factory Doctor.fromMap(Map<String, dynamic> json, {double balance = 0.0}) {
    return Doctor(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      profilePicUrl: json['profileImage'] ?? json['profile_pic_url'] ?? '',
      profession: json['profession'] ?? '',
      state: json['state'] ?? '',
      departments: List<String>.from(json['departments'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      experience: json['experience']?.toString() ?? '0',
      isSurgeonString: json['isSurgeon']?.toString() ?? '',
      isSurgeon: _parseBool(json['is_surgeon']),
      isOnline: _parseBool(json['is_online']),
      isLoggedIn: _parseBool(json['is_logged_in']),
      isTermsAgreed: _parseBool(json['is_terms_agreed']),
      isDeleted: _parseBool(json['is_deleted']),
      registrationStatus: json['registration_status'] ?? '',
      educationDoc: json['education_doc'] ?? '',
      educationDocUrl: json['education_doc_url'] ?? '',
      medicalProof: json['medical_proof'] ?? '',
      medicalProofUrl: json['medical_proof_url'] ?? '',
      idUrl: json['id_url'] ?? '',
      userId: json['user_id'] ?? '',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      phone: json['phone'] ?? '',
      balance: balance, // Set balance here
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'profile_pic_url': profilePicUrl,
      'profession': profession,
      'state': state,
      'departments': departments,
      'languages': languages,
      'experience': experience,
      'isSurgeon': isSurgeonString,
      'is_surgeon': isSurgeon,
      'is_online': isOnline,
      'is_logged_in': isLoggedIn,
      'is_terms_agreed': isTermsAgreed,
      'is_deleted': isDeleted,
      'registration_status': registrationStatus,
      'educationDoc': educationDoc,
      'education_doc_url': educationDocUrl,
      'medical_proof': medicalProof,
      'medical_proof_url': medicalProofUrl,
      'id_url': idUrl,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'phone': phone,
      'balance': balance,  // Include balance when saving to Firestore
    };
  }
}
