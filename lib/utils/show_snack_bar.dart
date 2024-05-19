import 'package:flutter/material.dart';
import 'package:dismov_app/config/theme/color.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
   SnackBar(
     content: Text(
       message,
       style: const TextStyle(
         fontSize: 15,
         fontWeight: FontWeight.w600,
       ),
     ),
     backgroundColor: AppColor.blue,
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