
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dismov_app/models/chat_model.dart';
import 'package:dismov_app/models/message_model.dart';
import 'package:dismov_app/services/chat_service.dart';
import 'package:dismov_app/services/pet_service.dart'; 
import 'package:dismov_app/shared/widgets/custom_image.dart';


class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.chatData});

  final ChatModel chatData;
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ChatService chatService = ChatService();
  final PetService petService = PetService();
  final TextEditingController _messageController = TextEditingController();

  List<MessageModel> _messages = [];
  ChatModel? _chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<MessageModel>>(
        stream: chatService.getMessagesByChatIdStream(widget.chatData.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _messages = snapshot.data!;
            return getBody(context);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  getMessages() async {
    List<MessageModel> messages = await chatService.getMessagesByChatId(widget.chatData.id);
    setState(() {
      _messages = messages;
    });
  }

  Widget _buildTopBar() {
    return AppBar(
      title: Text(widget.chatData.petName),
      // show the pet image in the appbar and also the back button without overflow
      leadingWidth: 90,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        
        children: [
          IconButton(
            iconSize: 30,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CustomImage(
            widget.chatData.petImageURL,
            width: 42,
            height: 42,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      

    );
  }
  getBody(context) {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(_messages[index]);
            },
          ),
        ),
        _buildInput(),
      ],
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    // if the message is from the current user, align it to the right
    if (isMessageFromCurrentUser(message)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.content,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.content,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    }
  }

  bool isMessageFromCurrentUser(MessageModel message) {
    return message.senderId == FirebaseAuth.instance.currentUser!.uid;
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, 
              ),
              controller: _messageController,
              decoration: const InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
                hintText: 'Escribe un mensaje...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  _sendMessage() async {
    FirebaseAuth.instance.currentUser!.updateDisplayName('Patitas Suaves');
    if (_messageController.text.isNotEmpty) {
      MessageModel message = MessageModel(
        id: '',
        content: _messageController.text,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderName: FirebaseAuth.instance.currentUser!.displayName!,
        time: DateTime.now().millisecondsSinceEpoch,
      );
      await chatService.addMessageToChat(widget.chatData.id, message);
      _messageController.clear();
      getMessages();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}


