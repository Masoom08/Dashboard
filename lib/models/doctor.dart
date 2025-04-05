class Doctor {
  final String name;
  final String email;
  final String gender;
  final String profilePicUrl;
  final String profession;
  final String state;
  final List<String> departments;
  final List<String> languages;
  final int experience;
  final bool isSurgeon;
  final bool isOnline;
  final bool isLoggedIn;
  final bool isTermsAgreed;
  final bool isDeleted;
  final String registrationStatus;
  final String educationDocUrl;
  final String medicalProofUrl;
  final String idUrl;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.isSurgeon,
    required this.isOnline,
    required this.isLoggedIn,
    required this.isTermsAgreed,
    required this.isDeleted,
    required this.registrationStatus,
    required this.educationDocUrl,
    required this.medicalProofUrl,
    required this.idUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ Factory method to create a Doctor from JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      profilePicUrl: json['profilePicUrl'] ?? '',
      profession: json['profession'] ?? '',
      state: json['state'] ?? '',
      departments: List<String>.from(json['departments'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      experience: json['experience'] ?? 0,
      isSurgeon: json['isSurgeon'] ?? false,
      isOnline: json['isOnline'] ?? false,
      isLoggedIn: json['isLoggedIn'] ?? false,
      isTermsAgreed: json['isTermsAgreed'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      registrationStatus: json['registrationStatus'] ?? '',
      educationDocUrl: json['educationDocUrl'] ?? '',
      medicalProofUrl: json['medicalProofUrl'] ?? '',
      idUrl: json['idUrl'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // ✅ Method to convert a Doctor object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'profilePicUrl': profilePicUrl,
      'profession': profession,
      'state': state,
      'departments': departments,
      'languages': languages,
      'experience': experience,
      'isSurgeon': isSurgeon,
      'isOnline': isOnline,
      'isLoggedIn': isLoggedIn,
      'isTermsAgreed': isTermsAgreed,
      'isDeleted': isDeleted,
      'registrationStatus': registrationStatus,
      'educationDocUrl': educationDocUrl,
      'medicalProofUrl': medicalProofUrl,
      'idUrl': idUrl,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
