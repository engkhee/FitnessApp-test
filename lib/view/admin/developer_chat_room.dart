import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DeveloperChatRoom extends StatefulWidget {
  static String routeName = "/DeveloperChatRoom";

  @override
  _DeveloperChatRoomState createState() => _DeveloperChatRoomState();
}

class _DeveloperChatRoomState extends State<DeveloperChatRoom> {
  final List<ChatMessage> _messages = [];

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        backgroundColor: AppColors.adminpageColor2,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index].sender),
                  subtitle: Text(_messages[index].text),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildMessageInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _messageController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      _messageController.clear();
      ChatMessage message = ChatMessage(sender: 'You (Admin)', text: text);
      setState(() {
        _messages.add(message);
      });
    }
  }
}

class ChatMessage {
  final String sender;
  final String text;

  ChatMessage({required this.sender, required this.text});
}
