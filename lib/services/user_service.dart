import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/models/user_model.dart'; // Asegúrate de importar el modelo aquí

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener un usuario por su UID
  Future<UserModel?> getUserByUid(String uid) async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      return UserModel.fromFirebase(userSnapshot);
    } else {
      return null;
    }
  }

  // Método para agregar un nuevo usuario
  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // Método para actualizar la información de un usuario
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

}
