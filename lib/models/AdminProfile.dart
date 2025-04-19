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
    this.profilePicUrl, // Allowing profilePicUrl to be nullable
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone ?? '', // Providing default empty string for null phone
      'role': role ?? '', // Providing default empty string for null role
      'profilePicUrl': profilePicUrl ?? '', // Providing default empty string for null profilePicUrl
    };
  }

  factory AdminProfile.fromMap(Map<String, dynamic> map) {
    return AdminProfile(
      uid: map['uid'] ?? '', // Default to empty string if missing
      email: map['email'] ?? '', // Default to empty string if missing
      name: map['name'] ?? '', // Default to empty string if missing
      phone: map['phone'], // Null if missing
      role: map['role'], // Null if missing
      profilePicUrl: map['profilePicUrl'], // Null if missing
    );
  }
}
