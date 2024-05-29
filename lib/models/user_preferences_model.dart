import 'package:cloud_firestore/cloud_firestore.dart';
class UserPreferencesModel {
  String? id;
  String? userId;
  String? type;
  String? sex;
  String? size;
  String? breed;
  List<String>? features;
  List<String>? colors;

  UserPreferencesModel({
    this.userId,
    this.id,
    this.type,
    this.sex,
    this.size,
    this.breed,
    this.features,
    this.colors,
  });

  // Método para convertir un objeto de preferencias de usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'sex': sex,
      'size': size,
      'breed': breed,
      'features': features,
      'colors': colors,
    };
  }

  // Método para crear un objeto de preferencias de usuario desde un mapa
  factory UserPreferencesModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserPreferencesModel(
      id: doc.id,
      userId: map['userId'],
      type: map['type'],
      sex: map['sex'],
      size: map['size'],
      breed: map['breed'] ,
      features: List<String>.from(map['features'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
    );
  }
}
