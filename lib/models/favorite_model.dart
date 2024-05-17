import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  String id;
  String petId;

  FavoriteModel({
    required this.id,
    required this.petId,
  });

  // Método para convertir un objeto de favoritos del usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
    };
  }

  // Método para crear un objeto de favoritos del usuario desde un mapa
  factory FavoriteModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return FavoriteModel(
      id: doc.id,
      petId: map['petId'],
    );
  }
}
