import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({super.key});

  @override
  Widget build(BuildContext context) {

    final textController = TextEditingController();

    final OutlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide( color: Colors.transparent ),
      borderRadius: BorderRadius.circular(40)
    );

    final inputDecoration = InputDecoration(
        enabledBorder: OutlineInputBorder,
        focusedBorder: OutlineInputBorder,
        filled: true,
        fillColor: const Color.fromARGB(255, 215, 215, 215),
        suffixIcon: IconButton(
          icon: const Icon( Icons.send_outlined ),
          onPressed: () {
            print('Valor de la caja de texto');
          },
        ),
      );

    return TextFormField(
      controller: textController,
      decoration: inputDecoration,
      onFieldSubmitted:(value) {
        print('Submit value $value');
        textController.clear();
      },


    );
  }
}