import 'package:cloud_firestore/cloud_firestore.dart';

class Withdrawal {
  String withdrawalId; // Firestore Document ID
  String doctorId; // Requested by (Doctor's User ID)
  double amount; // Amount requested
  double balance; // Wallet balance at the time of withdrawal
  String paymentId; // Payment Gateway Transaction ID (if completed)
  String paymentMethod; // "UPI", "Bank Transfer", etc.
  DateTime requestedOn; // Timestamp when the request was made
  String status; // "Pending", "Processing", "Completed", "Failed"

  Withdrawal({
    required this.withdrawalId,
    required this.doctorId,
    required this.amount,
    required this.balance,
    required this.paymentId,
    required this.paymentMethod,
    required this.requestedOn,
    required this.status,
  });

  // Convert Firestore document to model
  factory Withdrawal.fromMap(Map<String, dynamic> data, String documentId) {
    return Withdrawal(
      withdrawalId: documentId,
      doctorId: data['requested_by'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      balance: (data['balance'] ?? 0.0).toDouble(),
      paymentId: data['payment_id'] ?? '',
      paymentMethod: data['payment_method'] ?? '',
      requestedOn: (data['requested_on'] as Timestamp).toDate(),
      status: data['status'] ?? '',
    );
  }

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'requested_by': doctorId,
      'amount': amount,
      'balance': balance,
      'payment_id': paymentId,
      'payment_method': paymentMethod,
      'requested_on': requestedOn,
      'status': status,
    };
  }
}
