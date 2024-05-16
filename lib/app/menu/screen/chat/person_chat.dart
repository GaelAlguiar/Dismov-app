import 'package:dismov_app/app/menu/screen/chat/widgets/chats/her_message_bubble.dart';
import 'package:dismov_app/app/menu/screen/chat/widgets/chats/message_field_box.dart';
import 'package:dismov_app/app/menu/screen/chat/widgets/chats/my_message_bubble.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://beta.dopple.ai/_next/image?url=https%3A%2F%2Fimagedelivery.net%2FLBWXYQ-XnKSYxbZ-NuYGqQ%2Fde222e62-a7c9-40ec-5902-b496c2874b00%2Favatarhd&w=256&q=75'),
              ),
            ),
          ],
        ),
        title: const Text('Asosiacion asociada'),
        centerTitle: true,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          
          children: [
            const SizedBox( height: 10, ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ( index % 2 == 0 )
                  ? const HerMessageBubble()
                  : MyMessageBubble();
                },
              ),
            ),
        
            ///Caja de texto
            const MessageFieldBox(),

            const SizedBox( height: 10, )
          ],
        ),
      ),
    );
  }
}