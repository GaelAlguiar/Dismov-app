import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String uid;
  String? profilePicURL; // Tipo puede ser nulo

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    this.profilePicURL, // Puede ser nulo
  });

  // Método para convertir un objeto de usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'profilePicURL': profilePicURL, // No es necesario establecer un valor predeterminado
    };
  }

  // Método para crear un objeto de usuario desde un mapa
  factory UserModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: doc.id,
      profilePicURL: map['profilePicURL'], // Puede ser nulo
    );
  }
}

