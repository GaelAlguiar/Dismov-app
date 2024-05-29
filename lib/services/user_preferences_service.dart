import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/models/user_preferences_model.dart'; // Asegúrate de importar el modelo aquí

class UserPreferencesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener las preferencias de usuario por su ID
  Future<UserPreferencesModel?> getUserPreferencesById(String userId) async {
    print('getUserPreferencesById');
    print(userId);

    // get the document
    DocumentSnapshot userPreferencesDoc = await _firestore.collection('preferences').doc(userId).get();

    if (userPreferencesDoc.exists) {
      return UserPreferencesModel.fromFirebase(userPreferencesDoc);
    } else {
      return null;
    }
  }

  // Método para agregar nuevas preferencias de usuario
  Future<void> addUserPreferences(UserPreferencesModel userPreferences) async {
    await _firestore.collection('preferences').doc(userPreferences.userId).set(userPreferences.toMap());
  }

  // Método para actualizar las preferencias de usuario
  Future<void> updateUserPreferences(UserPreferencesModel userPreferences) async {
    await _firestore.collection('preferences').doc(userPreferences.userId).update(userPreferences.toMap());
  }
}
