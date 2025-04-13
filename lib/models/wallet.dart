import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String walletId; // Firestore Document ID
  final String userId;   // User/Doctor ID
  final double balance;
  final double lastTransactionAmount;
  final String lastTransactionStatus; // "Success", "Failed", "Pending"
  final String lastTransactionType;   // "Credit", "Debit"
  final int totalTransactions;
  final bool walletActive;
  final DateTime walletCreatedAt;

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
      balance: (data['balance'] is int)
          ? (data['balance'] as int).toDouble()
          : (data['balance'] ?? 0.0).toDouble(),
      lastTransactionAmount: (data['last_transaction_amount'] is int)
          ? (data['last_transaction_amount'] as int).toDouble()
          : (data['last_transaction_amount'] ?? 0.0).toDouble(),
      lastTransactionStatus: data['last_transaction_status'] ?? '',
      lastTransactionType: data['last_transaction_type'] ?? '',
      totalTransactions: data['total_transactions'] ?? 0,
      walletActive: data['wallet_active'] ?? false,
      walletCreatedAt: (data['wallet_created_at'] as Timestamp?)?.toDate() ?? DateTime(1970),
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
      'wallet_created_at': Timestamp.fromDate(walletCreatedAt),
    };
  }
}
