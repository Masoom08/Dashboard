import 'package:flutter/material.dart';

import '../../viewmodels/chat_viewmodel.dart';

/*
class ChatScreen extends StatelessWidget {
  final String userId;
  final String doctorId;

  const ChatScreen({Key? key, required this.userId, required this.doctorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Center(
        child: chatViewModel.isLoading
            ? CircularProgressIndicator()
            : chatViewModel.chatRoomId != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Chat Room ID: ${chatViewModel.chatRoomId}"),
            ElevatedButton(
              onPressed: () => chatViewModel.blockChat(chatViewModel.chatRoomId!, userId),
              child: Text("Block Chat"),
            ),
            ElevatedButton(
              onPressed: () => chatViewModel.unblockChat(chatViewModel.chatRoomId!),
              child: Text("Unblock Chat"),
            ),
            ElevatedButton(
              onPressed: () => chatViewModel.deleteChat(chatViewModel.chatRoomId!, userId),
              child: Text("Delete Chat"),
            ),
          ],
        )
            : Text("No Chat Room"),
      ),
    );
  }
}
*/