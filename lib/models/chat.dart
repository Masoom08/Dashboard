import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  List<String> participants; // List of user IDs (User & Doctor)
  String createdBy; // ID of the user who initiated the chat
  String? blockedBy; // ID of the user who blocked (null if not blocked)
  String? deletedBy; // ID of user who deleted the chat (soft delete)
  bool isBlocked;
  bool isDeleted;
  DateTime createdAt;

  ChatRoom({
    required this.participants,
    required this.createdBy,
    this.blockedBy,
    this.deletedBy,
    required this.isBlocked,
    required this.isDeleted,
    required this.createdAt,
  });

  // Convert Firestore document to ChatRoom model
  factory ChatRoom.fromMap(Map<String, dynamic> data) {
    return ChatRoom(
      participants: List<String>.from(data['participants'] ?? []),
      createdBy: data['created_by'] ?? '',
      blockedBy: data['blocked_by'],
      deletedBy: data['deleted_by'],
      isBlocked: data['is_blocked'] ?? false,
      isDeleted: data['is_deleted'] ?? false,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  // Convert ChatRoom model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'created_by': createdBy,
      'blocked_by': blockedBy,
      'deleted_by': deletedBy,
      'is_blocked': isBlocked,
      'is_deleted': isDeleted,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
