import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to messages subcollection inside a specific chat
  CollectionReference _messagesCollection(String chatId) {
    return _firestore.collection('chats').doc(chatId).collection('messages');
  }

  // Send a new message
  Future<void> sendMessage(Message message) async {
    try {
      final messageRef = _messagesCollection(message.chatId).doc();
      await messageRef.set(message.toMap());
    } catch (e) {
      throw Exception("Error sending message: $e");
    }
  }

  // Fetch messages from a chat room (real-time)
  Stream<List<Message>> getMessages(String chatId) {
    return _messagesCollection(chatId)
        .orderBy('sent_at', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data() as Map<String, dynamic>, doc.id, chatId);
      }).toList();
    });
  }

  // Update message status (delivered, seen)
  Future<void> updateMessageStatus(String chatId, String messageId, String status) async {
    try {
      await _messagesCollection(chatId).doc(messageId).update({'status': status});
    } catch (e) {
      throw Exception("Error updating message status: $e");
    }
  }

  // Delete a message (soft delete)
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _messagesCollection(chatId).doc(messageId).update({'is_deleted': true});
    } catch (e) {
      throw Exception("Error deleting message: $e");
    }
  }
}
