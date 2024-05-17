import 'package:flutter/material.dart';

class HerMessageBubble extends StatelessWidget {
  const HerMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration:  BoxDecoration(
            color: const Color.fromARGB(255, 90, 99, 107),
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
            child: Text('Hola Mundo', style: TextStyle( color: Colors.white ),),
          ),
        ),

        const SizedBox( height: 5, ),

        



      ],
    );
  }
}
