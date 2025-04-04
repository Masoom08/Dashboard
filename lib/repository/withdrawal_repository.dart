import '../models/withdrawal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference withdrawalsCollection =
  FirebaseFirestore.instance.collection('withdrawals');

  // Fetch withdrawal requests for a doctor
  Future<List<Withdrawal>> getDoctorWithdrawals(String doctorId) async {
    try {
      QuerySnapshot snapshot = await withdrawalsCollection
          .where('requested_by', isEqualTo: doctorId)
          .orderBy('requested_on', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Withdrawal.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error fetching withdrawals: $e");
    }
  }

  // Request a withdrawal
  Future<void> requestWithdrawal(Withdrawal withdrawal) async {
    try {
      final withdrawalRef = withdrawalsCollection.doc();
      await withdrawalRef.set(withdrawal.toMap());
    } catch (e) {
      throw Exception("Error requesting withdrawal: $e");
    }
  }

  // Update withdrawal status
  Future<void> updateWithdrawalStatus(String withdrawalId, String status) async {
    try {
      await withdrawalsCollection.doc(withdrawalId).update({'status': status});
    } catch (e) {
      throw Exception("Error updating status: $e");
    }
  }
}
