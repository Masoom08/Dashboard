class DoctorService {
  String serviceId; // Firestore Document ID
  String doctorId;
  String doctorName;
  String doctorProfilePic;
  String aboutDoctor;
  String department;
  String hospitalName;
  String contactNumber;
  int experience;
  String gender;
  bool isSurgeon;
  List<String> languages;
  List<String> docUrls;
  List<String> specializationDoc;
  List<String> additionalAddresses;
  String city;
  String state;
  String locality;
  String landmark;
  String meetingAddress;
  bool isCallEnabled;
  bool isChatEnabled;
  bool isDeleted;
  double appointmentFee;
  double callFees;
  double chatFees;
  double totalCallFees;
  double totalChatFees;
  String status;
  Map<String, List<String>> workingTimings; // Morning, Afternoon, Evening, Night shifts
  List<String> workingDays;

  DoctorService({
    required this.serviceId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorProfilePic,
    required this.aboutDoctor,
    required this.department,
    required this.hospitalName,
    required this.contactNumber,
    required this.experience,
    required this.gender,
    required this.isSurgeon,
    required this.languages,
    required this.docUrls,
    required this.specializationDoc,
    required this.additionalAddresses,
    required this.city,
    required this.state,
    required this.locality,
    required this.landmark,
    required this.meetingAddress,
    required this.isCallEnabled,
    required this.isChatEnabled,
    required this.isDeleted,
    required this.appointmentFee,
    required this.callFees,
    required this.chatFees,
    required this.totalCallFees,
    required this.totalChatFees,
    required this.status,
    required this.workingTimings,
    required this.workingDays,
  });

  // Convert Firestore document to model
  factory DoctorService.fromMap(Map<String, dynamic> data, String documentId) {
    return DoctorService(
      serviceId: documentId,
      doctorId: data['doctor_id'] ?? '',
      doctorName: data['doctorName'] ?? '',
      doctorProfilePic: data['doctorProfilePic'] ?? '',
      aboutDoctor: data['aboutDoctor'] ?? '',
      department: data['department'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      experience: data['experience'] ?? 0,
      gender: data['gender'] ?? '',
      isSurgeon: data['isSurgeon'] ?? false,
      languages: List<String>.from(data['languages'] ?? []),
      docUrls: List<String>.from(data['docUrls'] ?? []),
      specializationDoc: List<String>.from(data['specializationDoc'] ?? []),
      additionalAddresses: List<String>.from(data['additionalAddresses'] ?? []),
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      locality: data['locality'] ?? '',
      landmark: data['landmark'] ?? '',
      meetingAddress: data['meetingAddress'] ?? '',
      isCallEnabled: data['isCallEnabled'] ?? false,
      isChatEnabled: data['isChatEnabled'] ?? false,
      isDeleted: data['isDeleted'] ?? false,
      appointmentFee: (data['appointmentFee'] ?? 0.0).toDouble(),
      callFees: (data['callFees'] ?? 0.0).toDouble(),
      chatFees: (data['chatFees'] ?? 0.0).toDouble(),
      totalCallFees: (data['totalCallFees'] ?? 0.0).toDouble(),
      totalChatFees: (data['totalChatFees'] ?? 0.0).toDouble(),
      status: data['status'] ?? '',
      workingTimings: Map<String, List<String>>.from(data['workingTimings'] ?? {}),
      workingDays: List<String>.from(data['workingDays'] ?? []),
    );
  }

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'doctor_id': doctorId,
      'doctorName': doctorName,
      'doctorProfilePic': doctorProfilePic,
      'aboutDoctor': aboutDoctor,
      'department': department,
      'hospitalName': hospitalName,
      'contactNumber': contactNumber,
      'experience': experience,
      'gender': gender,
      'isSurgeon': isSurgeon,
      'languages': languages,
      'docUrls': docUrls,
      'specializationDoc': specializationDoc,
      'additionalAddresses': additionalAddresses,
      'city': city,
      'state': state,
      'locality': locality,
      'landmark': landmark,
      'meetingAddress': meetingAddress,
      'isCallEnabled': isCallEnabled,
      'isChatEnabled': isChatEnabled,
      'isDeleted': isDeleted,
      'appointmentFee': appointmentFee,
      'callFees': callFees,
      'chatFees': chatFees,
      'totalCallFees': totalCallFees,
      'totalChatFees': totalChatFees,
      'status': status,
      'workingTimings': workingTimings,
      'workingDays': workingDays,
    };
  }
}
