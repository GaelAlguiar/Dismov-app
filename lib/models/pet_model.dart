import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  String id;
  String name;
  String type;
  String sex;
  int? ageInYears;
  String size;
  String breed;
  List<String> features;
  List<String> colors;
  List<String> imageURLs;
  String shelterId;
  String adoptionStatus;
  String? story;
  Timestamp publishedAt;
  bool isFavorited;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.sex,
    this.ageInYears,
    required this.size,
    required this.breed,
    required this.features,
    required this.colors,
    required this.imageURLs,
    required this.shelterId,
    required this.adoptionStatus,
    this.story,
    required this.publishedAt,
    this.isFavorited = false
  });

  // Método para convertir un objeto de mascota a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'sex': sex,
      'ageInYears': ageInYears,
      'size': size,
      'breed': breed,
      'features': features,
      'colors': colors,
      'imageURLs': imageURLs,
      'shelterId': shelterId,
      'adoptionStatus': adoptionStatus,
      'story': story,
      'publishedAt': publishedAt,
    };
  }

  // Método para crear un objeto de mascota desde un mapa
  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      sex: map['sex'],
      ageInYears: map['ageInYears'],
      size: map['size'],
      breed: map['breed'],
      features: List<String>.from(map['features']),
      colors: List<String>.from(map['colors']),
      imageURLs: List<String>.from(map['imageURLs']),
      shelterId: map['shelterId'],
      adoptionStatus: map['adoptionStatus'],
      story: map['story'],
      publishedAt: map['publishedAt'],
    );
  }
}
