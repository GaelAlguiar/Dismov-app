import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_preferences_model.dart'; // Asegúrate de importar el modelo aquí

class UserPreferencesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener las preferencias de usuario por su ID
  Future<UserPreferencesModel?> getUserPreferencesById(String userId) async {
    DocumentSnapshot userPreferencesSnapshot =
        await _firestore.collection('user_preferences').doc(userId).get();

    if (userPreferencesSnapshot.exists) {
      return UserPreferencesModel.fromMap(userPreferencesSnapshot.data()! as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Método para agregar nuevas preferencias de usuario
  Future<void> addUserPreferences(UserPreferencesModel userPreferences) async {
    await _firestore.collection('user_preferences').doc(userPreferences.userId).set(userPreferences.toMap());
  }

  // Método para actualizar las preferencias de usuario
  Future<void> updateUserPreferences(UserPreferencesModel userPreferences) async {
    await _firestore.collection('user_preferences').doc(userPreferences.userId).update(userPreferences.toMap());
  }
}
