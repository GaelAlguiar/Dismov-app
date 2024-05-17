class ShelterModel {
  String uid;
  String name;
  String phone;
  String? email;
  String? website;
  String description;
  String image;
  String address;
  String latitude;
  String longitude;
  String? adoptionFormURL;

  ShelterModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email,
    this.website,
    required this.description,
    required this.image,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.adoptionFormURL,
  });

  // Método para convertir un objeto de refugio a un mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name ?? '',
      'phone': phone ?? '',
      'email': email ?? '',
      'website': website ?? '',
      'description': description ?? '',
      'image': image ?? '',
      'uid': uid ?? '',
      'address': address ?? '',
      'latitude': latitude ?? '',
      'longitude': longitude ?? '',
      'adoptionFormURL': adoptionFormURL ?? '',
    };
  }

  // Método para crear un objeto de refugio desde un mapa
  factory ShelterModel.fromMap(Map<String, dynamic> map) {
    return ShelterModel(
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      website: map['website'],
      description: map['description'],
      image: map['imageURL'],
      uid: map['uid'],
      address: map['address'],
      latitude: map['latitude'].toString(),
      longitude: map['longitude'].toString(),
      adoptionFormURL: map['adoptionFormURL'],
    );
  }
}
