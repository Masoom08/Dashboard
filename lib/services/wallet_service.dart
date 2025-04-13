import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Wallet>> fetchAllWallets() async {
    final snapshot = await _firestore.collection('wallet').get();

    return snapshot.docs.map((doc) =>
        Wallet.fromMap(doc.data(), doc.id)
    ).toList();
  }
}
