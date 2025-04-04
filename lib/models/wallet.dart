import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  String walletId; // Firestore Document ID
  String userId; // User/Doctor ID
  double balance;
  double lastTransactionAmount;
  String lastTransactionStatus; // "Success", "Failed", "Pending"
  String lastTransactionType; // "Credit", "Debit"
  int totalTransactions;
  bool walletActive;
  DateTime walletCreatedAt;

  Wallet({
    required this.walletId,
    required this.userId,
    required this.balance,
    required this.lastTransactionAmount,
    required this.lastTransactionStatus,
    required this.lastTransactionType,
    required this.totalTransactions,
    required this.walletActive,
    required this.walletCreatedAt,
  });

  // Convert Firestore document to model
  factory Wallet.fromMap(Map<String, dynamic> data, String documentId) {
    return Wallet(
      walletId: documentId,
      userId: data['user_id'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      lastTransactionAmount: (data['last_transaction_amount'] ?? 0.0).toDouble(),
      lastTransactionStatus: data['last_transaction_status'] ?? '',
      lastTransactionType: data['last_transaction_type'] ?? '',
      totalTransactions: data['total_transactions'] ?? 0,
      walletActive: data['wallet_active'] ?? false,
      walletCreatedAt: (data['wallet_created_at'] as Timestamp).toDate(),
    );
  }

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'balance': balance,
      'last_transaction_amount': lastTransactionAmount,
      'last_transaction_status': lastTransactionStatus,
      'last_transaction_type': lastTransactionType,
      'total_transactions': totalTransactions,
      'wallet_active': walletActive,
      'wallet_created_at': walletCreatedAt,
    };
  }
}
