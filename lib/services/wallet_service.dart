import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wallet.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all wallets from Firestore
  Future<List<Wallet>> fetchAllWallets() async {
    final snapshot = await _firestore.collection('wallets').get();

    return snapshot.docs.map((doc) => Wallet.fromMap(doc.data(), doc.id)).toList();
  }

  /// Calculate total earnings (5% of wallet balance) between given dates for the current user
  Future<double> calculateEarningsBetweenDates({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final walletRef = _firestore.collection('wallets');

    final startTimestamp = Timestamp.fromDate(startDate);
    final endTimestamp = Timestamp.fromDate(endDate);

    final querySnapshot = await walletRef
        .where('uid', isEqualTo: currentUser!.uid)
        .where('createdAt', isGreaterThanOrEqualTo: startTimestamp)
        .where('createdAt', isLessThanOrEqualTo: endTimestamp)
        .get();

    double totalEarnings = 0.0;

    for (final doc in querySnapshot.docs) {
      final walletBalance = doc['wallet'] ?? 0.0;
      final earning = 0.05 * (walletBalance is int ? walletBalance.toDouble() : walletBalance);
      totalEarnings += earning;
    }

    return totalEarnings;
  }
}
