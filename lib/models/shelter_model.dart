import 'package:cloud_firestore/cloud_firestore.dart';

class ShelterModel {
  String uid;
  String name;
  String phone;
  String? email;
  String? website;
  String description;
  String imageURL;
  String address;
  double latitude;
  double longitude;
  String? adoptionFormURL;

  ShelterModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email,
    this.website,
    required this.description,
    required this.imageURL,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.adoptionFormURL,
  });

  // Método para convertir un objeto de refugio a un mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'website': website,
      'description': description,
      'image': imageURL,
      'uid': uid,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'adoptionFormURL': adoptionFormURL,
    };
  }

  // Método para crear un objeto de refugio desde un mapa
  factory ShelterModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;  
    return ShelterModel(
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      website: map['website'],
      description: map['description'],
      imageURL: map['imageURL'],
      uid: doc.id,
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      adoptionFormURL: map['adoptionFormURL'],
    );
  }
}


