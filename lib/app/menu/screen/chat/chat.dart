import 'package:dismov_app/app/menu/screen/chat/person_chat.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/shared/widgets/chat_item.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return getBody(context);
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
                builder: (context) => ChatsScreen(),
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

