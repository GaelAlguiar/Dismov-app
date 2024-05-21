import 'package:flutter/material.dart';

Future<bool> askConfirmationToContinue(BuildContext context, String message) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('¿Estás seguro?'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sí'),
        ),
      ],
    ),
  );
}