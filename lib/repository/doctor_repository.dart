import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all doctors from Firestore and include wallet balance + phone
  Future<List<Doctor>> fetchDoctorsFromFirestore() async {
    final snapshot = await _firestore.collection('doctors').get();

    List<Doctor> doctors = [];

    await Future.forEach(snapshot.docs, (DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;
      final doctorId = doc.id;

      // Fetch wallet balance
      final walletDoc = await _firestore.collection('wallets').doc(doctorId).get();
      final balance = walletDoc.exists ? walletDoc['balance'] ?? 0.0 : 0.0;

      // Fetch phone from users collection
      final userDoc = await _firestore.collection('users').doc(doctorId).get();
      final phone = userDoc.exists ? userDoc['phone'] ?? '' : '';

      // Inject phone into doctor data before parsing
      data['phone'] = phone;

      // Create Doctor instance
      doctors.add(Doctor.fromMap(data, balance: balance));
    });

    return doctors;
  }

  // Fetch a specific doctor by ID
  Future<Doctor?> fetchDoctorById(String doctorId) async {
    final doc = await _firestore.collection('doctors').doc(doctorId).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;

      final walletDoc = await _firestore.collection('wallets').doc(doctorId).get();
      final balance = walletDoc.exists ? walletDoc['balance'] ?? 0.0 : 0.0;

      final userDoc = await _firestore.collection('users').doc(doctorId).get();
      final phone = userDoc.exists ? userDoc['phone'] ?? '' : '';

      data['phone'] = phone;

      return Doctor.fromMap(data, balance: balance);
    } else {
      return null;
    }
  }

  Future<void> updateDoctorServiceAgreedStatus(String doctorId) async {
    await _firestore.collection('doctors').doc(doctorId).update({
      'service_agreed': true,
    });
  }

  Future<List<Doctor>> fetchDoctorsByServiceAgreed({required bool isAgreed}) async {
    final snapshot = await _firestore
        .collection('doctors')
        .where('service_agreed', isEqualTo: isAgreed)
        .get();

    List<Doctor> doctors = [];

    await Future.forEach(snapshot.docs, (DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;
      final doctorId = doc.id;

      final walletDoc = await _firestore.collection('wallets').doc(doctorId).get();
      final balance = walletDoc.exists ? walletDoc['balance'] ?? 0.0 : 0.0;

      final userDoc = await _firestore.collection('users').doc(doctorId).get();
      final phone = userDoc.exists ? userDoc['phone'] ?? '' : '';

      data['phone'] = phone;

      doctors.add(Doctor.fromMap(data, balance: balance));
    });

    return doctors;
  }

  Future<double> fetchWalletBalanceByDoctorId(String doctorId) async {
    try {
      final walletDoc = await _firestore.collection('wallets').doc(doctorId).get();
      return walletDoc.exists ? walletDoc['balance'] ?? 0.0 : 0.0;
    } catch (e) {
      print('Error fetching wallet balance for doctor $doctorId: $e');
      return 0.0;
    }
  }
}
