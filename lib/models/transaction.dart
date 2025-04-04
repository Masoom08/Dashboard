import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String transactionId; // Firestore Document ID
  String walletId; // Parent Wallet ID
  String source; // Payment gateway (Razorpay)
  double balance; // User's balance after transaction
  double transactionAmount; // Amount transacted
  DateTime transactionAt; // Timestamp of transaction
  String payee; // Receiver's user_id
  String payer; // Sender's user_id
  String transactionStatus; // "pending", "successful", "failed"
  String type; // "credit" or "debit"

  Transaction({
    required this.transactionId,
    required this.walletId,
    required this.source,
    required this.balance,
    required this.transactionAmount,
    required this.transactionAt,
    required this.payee,
    required this.payer,
    required this.transactionStatus,
    required this.type,
  });

  // Convert Firestore document to model
  factory Transaction.fromMap(Map<String, dynamic> data, String documentId, String walletId) {
    return Transaction(
      transactionId: documentId,
      walletId: walletId,
      source: data['source'] ?? 'Razorpay',
      balance: (data['balance'] as num).toDouble(),
      transactionAmount: (data['transaction_amount'] as num).toDouble(),
      transactionAt: (data['transaction_at'] as Timestamp).toDate(),
      payee: data['transaction_between']['payee'] ?? '',
      payer: data['transaction_between']['payer'] ?? '',
      transactionStatus: data['transaction_status'] ?? 'pending',
      type: data['type'] ?? 'debit',
    );
  }

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'source': source,
      'balance': balance,
      'transaction_amount': transactionAmount,
      'transaction_at': transactionAt,
      'transaction_between': {
        'payee': payee,
        'payer': payer,
      },
      'transaction_status': transactionStatus,
      'type': type,
    };
  }
}
