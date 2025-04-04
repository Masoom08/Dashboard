import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';

/*
class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference walletsCollection =
  FirebaseFirestore.instance.collection('wallets');

  // Fetch user wallet
  Future<Wallet?> getUserWallet(String userId) async {
    try {
      QuerySnapshot snapshot =
      await walletsCollection.where('user_id', isEqualTo: userId).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return Wallet.fromMap(snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching wallet: $e");
    }
  }

  // Fetch transactions for a wallet
  Future<List<Transaction>> getTransactions(String walletId) async {
    try {
      QuerySnapshot snapshot = await walletsCollection
          .doc(walletId)
          .collection('transactions')
          .orderBy('created_at', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error fetching transactions: $e");
    }
  }

  // Add a new transaction (Credit or Debit)
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final walletRef = walletsCollection.doc(transaction.walletId);
      final transactionRef = walletRef.collection('transactions').doc();

      await _firestore.runTransaction((transactionBatch) async {
        DocumentSnapshot walletSnapshot = await walletRef.get();
        if (!walletSnapshot.exists) {
          throw Exception("Wallet not found");
        }

        Wallet wallet = Wallet.fromMap(walletSnapshot.data() as Map<String, dynamic>,
            walletSnapshot.id);

        double newBalance = transaction.transactionType == "Credit"
            ? wallet.balance + transaction.amount
            : wallet.balance - transaction.amount;

        await transactionRef.set(transaction.toMap());
        await walletRef.update({
          'balance': newBalance,
          'last_transaction_amount': transaction.amount,
          'last_transaction_status': transaction.status,
          'last_transaction_type': transaction.transactionType,
          'total_transactions': wallet.totalTransactions + 1,
        });
      });
    } catch (e) {
      throw Exception("Error adding transaction: $e");
    }
  }

  // Soft delete a wallet (Deactivate it)
  Future<void> deactivateWallet(String walletId) async {
    try {
      await walletsCollection.doc(walletId).update({'wallet_active': false});
    } catch (e) {
      throw Exception("Error deactivating wallet: $e");
    }
  }
}

 */
