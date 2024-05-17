import 'package:dismov_app/app/menu/screen/chat/person_chat.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/shared/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../models/shelter_model.dart';
import '../../../../shared/widgets/custom_image.dart';

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
  final ShelterModel shelter;

  const ShelterDetailPage({Key? key, required this.shelter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shelter Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
              shelter.image,
              borderRadius: BorderRadius.circular(50),
              isShadow: true,
              width: 80,
              height: 80,
            ),
            Text(
              shelter.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${shelter.address}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${shelter.description}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${shelter.email}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${shelter.phone}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _launchURL(shelter.adoptionFormURL);
              },
              child: Text('Adoption Form'),
            ),
            // You can add more information here if needed
          ],
        ),
      ),
    );
  }
}

void _launchURL(String? url) async {
  if (url != null) {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }}