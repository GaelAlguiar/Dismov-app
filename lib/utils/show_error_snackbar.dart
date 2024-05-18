import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
   SnackBar(
     content: Text(
       message,
       style: const TextStyle(
         fontSize: 15,
         fontWeight: FontWeight.w600,
       ),
     ),
     backgroundColor: Colors.red[600],
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10),
     ),
     behavior: SnackBarBehavior.floating,
     margin: const EdgeInsets.symmetric(
       horizontal: 10,
       vertical: 10,
     ),
   ),
  );
}