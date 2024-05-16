import 'package:flutter/material.dart';

class MyMessageBubble extends StatelessWidget {
  const MyMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration:  BoxDecoration(
            color: const Color.fromARGB(255, 38, 121, 177),
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
            child: Text('Dloreeem', style: TextStyle( color: Colors.white ),),
          ),
        ),

        const SizedBox( height: 10, )
      ],
    );
  }
}