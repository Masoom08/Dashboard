import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String userId;
  String name;
  String email;
  String profession;
  String about;
  String gender;
  String state;
  bool isSurgeon;
  bool isLoggedIn;
  bool isDeleted;
  bool isOnline;
  bool isTermsAgreed;
  bool registrationStatus;
  String profilePicUrl;
  String idUrl;
  String educationDocUrl;
  String medicalProofUrl;
  List<String> departments;
  List<String> languages;
  int experience;
  DateTime createdAt;
  DateTime updatedAt;

  DoctorModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.profession,
    required this.about,
    required this.gender,
    required this.state,
    required this.isSurgeon,
    required this.isLoggedIn,
    required this.isDeleted,
    required this.isOnline,
    required this.isTermsAgreed,
    required this.registrationStatus,
    required this.profilePicUrl,
    required this.idUrl,
    required this.educationDocUrl,
    required this.medicalProofUrl,
    required this.departments,
    required this.languages,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Firestore document to DoctorModel
  factory DoctorModel.fromMap(Map<String, dynamic> data) {
    return DoctorModel(
      userId: data['user_id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profession: data['profession'] ?? '',
      about: data['about'] ?? '',
      gender: data['gender'] ?? '',
      state: data['state'] ?? '',
      isSurgeon: data['isSurgeon'] ?? false,
      isLoggedIn: data['is_logged_in'] ?? false,
      isDeleted: data['is_deleted'] ?? false,
      isOnline: data['is_online'] ?? false,
      isTermsAgreed: data['is_terms_agreed'] ?? false,
      registrationStatus: data['registration_status'] ?? false,
      profilePicUrl: data['profile_pic_url'] ?? '',
      idUrl: data['id_url'] ?? '',
      educationDocUrl: data['education_doc_url'] ?? '',
      medicalProofUrl: data['medical_proof_url'] ?? '',
      departments: List<String>.from(data['departments'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
      experience: data['experience'] ?? 0,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // Convert DoctorModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'profession': profession,
      'about': about,
      'gender': gender,
      'state': state,
      'isSurgeon': isSurgeon,
      'is_logged_in': isLoggedIn,
      'is_deleted': isDeleted,
      'is_online': isOnline,
      'is_terms_agreed': isTermsAgreed,
      'registration_status': registrationStatus,
      'profile_pic_url': profilePicUrl,
      'id_url': idUrl,
      'education_doc_url': educationDocUrl,
      'medical_proof_url': medicalProofUrl,
      'departments': departments,
      'languages': languages,
      'experience': experience,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}
