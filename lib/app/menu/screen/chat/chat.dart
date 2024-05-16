import 'package:dismov_app/app/menu/screen/chat/chat_detail.dart';
import 'package:dismov_app/app/menu/screen/chat/person_chat.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/shared/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dismov_app/services/chat_service.dart';
import 'package:dismov_app/models/chat_model.dart';
import 'package:dismov_app/app/menu/screen/chat/chat_detail.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // instance of chat serviice
  final ChatService _chatService = ChatService(); 
  List<ChatModel> chats = [];

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user found"),
        ),
      );
    }
    return StreamBuilder(stream: _chatService.getChatsByUserIdStream(currentUser.uid), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasError) {
        return const Center(
          child: Text("Error cargando los chats del usuario"),
        );
      }
      chats = snapshot.data as List<ChatModel>;
      return Scaffold(
        body: getBody(context),
      );
    });
  }

  getBody(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildChats(context),
        ],
      ),
    );
  }

  _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15, 60, 15, 5),
      child: Column(
        children: [
          Text(
            "Chats",
            style: TextStyle(
              fontSize: 28,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          CustomTextBox(
            hint: "Buscar",
            prefix: Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  _buildChats(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      children: List.generate(
        chats.length,
        (index) => ChatItem(
          chats[index],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatDetailPage(chatData: chats[index]),
              )
            );
          },
        ),
      ),
    );
  }
}


class ShelterDetailPage extends StatelessWidget {
  final Map shelter;

  const ShelterDetailPage({super.key, required this.shelter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shelter['name']),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Image.network(shelter['image']),
                const SizedBox(height: 20),
                Text(
                  shelter['name'],
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

