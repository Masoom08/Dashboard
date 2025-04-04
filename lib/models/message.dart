import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String messageId; // Firestore Document ID
  String chatId; // Parent Chat Room ID
  String sentBy; // User ID of the sender
  String message; // Text message content
  bool isAttachment; // True if the message contains a file/image
  bool isDeleted; // True if the message was deleted
  String status; // "sent", "delivered", "seen"
  DateTime sentAt; // Timestamp when message was sent
  DateTime? updatedAt; // Timestamp for edit/delete actions

  Message({
    required this.messageId,
    required this.chatId,
    required this.sentBy,
    required this.message,
    required this.isAttachment,
    required this.isDeleted,
    required this.status,
    required this.sentAt,
    this.updatedAt,
  });

  // Convert Firestore document to model
  factory Message.fromMap(Map<String, dynamic> data, String documentId, String chatId) {
    return Message(
      messageId: documentId,
      chatId: chatId,
      sentBy: data['sent_by'] ?? '',
      message: data['message'] ?? '',
      isAttachment: data['is_attachment'] ?? false,
      isDeleted: data['is_deleted'] ?? false,
      status: data['status'] ?? 'sent',
      sentAt: (data['sent_at'] as Timestamp).toDate(),
      updatedAt: data['updated_at'] != null ? (data['updated_at'] as Timestamp).toDate() : null,
    );
  }

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'sent_by': sentBy,
      'message': message,
      'is_attachment': isAttachment,
      'is_deleted': isDeleted,
      'status': status,
      'sent_at': sentAt,
      'updated_at': updatedAt,
    };
  }
}
