import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:dismov_app/utils/snackbar.dart'; 

Future<File?> pickImage(context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path); 
    }
  } catch (e) {
    if (!context.mounted) return null;
    showErrorSnackbar(context, "No hay una imagen seleccionada");
    return null;
  }
  return image;
}