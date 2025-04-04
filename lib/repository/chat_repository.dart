import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference chatsCollection =
  FirebaseFirestore.instance.collection('chats');

  // Create or fetch an existing chat room
  Future<String> getOrCreateChat(String userId, String doctorId) async {
    try {
      QuerySnapshot query = await chatsCollection
          .where('participants', arrayContains: userId)
          .get();

      // Check if a chat room already exists
      for (var doc in query.docs) {
        List<String> participants = List<String>.from(doc['participants']);
        if (participants.contains(doctorId)) {
          return doc.id; // Return existing chat room ID
        }
      }

      // If no chat room exists, create a new one
      DocumentReference newChatRef = await chatsCollection.add({
        'participants': [userId, doctorId],
        'created_by': userId,
        'blocked_by': null,
        'deleted_by': null,
        'is_blocked': false,
        'is_deleted': false,
        'created_at': Timestamp.now(),
      });

      return newChatRef.id; // Return new chat room ID
    } catch (e) {
      throw Exception("Failed to create or get chat room: $e");
    }
  }

  // Block a chat room
  Future<void> blockChat(String chatId, String userId) async {
    await chatsCollection.doc(chatId).update({
      'is_blocked': true,
      'blocked_by': userId,
    });
  }

  // Unblock a chat room
  Future<void> unblockChat(String chatId) async {
    await chatsCollection.doc(chatId).update({
      'is_blocked': false,
      'blocked_by': null,
    });
  }

  // Soft delete a chat
  Future<void> deleteChat(String chatId, String userId) async {
    await chatsCollection.doc(chatId).update({
      'is_deleted': true,
      'deleted_by': userId,
    });
  }
}
