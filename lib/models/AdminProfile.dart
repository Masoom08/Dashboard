class AdminProfile {
  final String uid;
  final String email;
  final String name;
  final String? phone; // Nullable phone field
  final String? role; // Nullable role field
  final String? profilePicUrl; // Nullable profilePicUrl field

  AdminProfile({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.role,
    this.profilePicUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone ?? '',
      'role': role ?? '',
      'profilePicUrl': profilePicUrl ?? '',
    };
  }

  /// Factory method to create AdminProfile from Firestore map with uid from doc ID
  factory AdminProfile.fromMap(String uid, Map<String, dynamic> map) {
    return AdminProfile(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: (map['phone'] as String?)?.isEmpty ?? true ? null : map['phone'],
      role: (map['role'] as String?)?.isEmpty ?? true ? null : map['role'],
      profilePicUrl: (map['profilePicUrl'] as String?)?.isEmpty ?? true ? null : map['profilePicUrl'],
    );
  }
}
