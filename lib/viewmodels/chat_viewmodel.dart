import 'package:flutter/material.dart';
import '../repository/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();
  String? _chatRoomId;
  bool _isLoading = false;

  String? get chatRoomId => _chatRoomId;
  bool get isLoading => _isLoading;

  // Create or get existing chat room
  Future<void> getOrCreateChat(String userId, String doctorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _chatRoomId = await _repository.getOrCreateChat(userId, doctorId);
    } catch (e) {
      print("Error creating/getting chat: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Block chat
  Future<void> blockChat(String chatId, String userId) async {
    await _repository.blockChat(chatId, userId);
    notifyListeners();
  }

  // Unblock chat
  Future<void> unblockChat(String chatId) async {
    await _repository.unblockChat(chatId);
    notifyListeners();
  }

  // Delete chat
  Future<void> deleteChat(String chatId, String userId) async {
    await _repository.deleteChat(chatId, userId);
    notifyListeners();
  }
}
