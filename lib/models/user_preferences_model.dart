class UserPreferencesModel {
  String? userId;
  String? type;
  String? sex;
  String? size;
  String? breed;
  List<String>? features;
  List<String>? colors;

  UserPreferencesModel({
    this.userId,
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
  factory UserPreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserPreferencesModel(
      userId: map['userId'],
      type: map['type'],
      sex: map['sex'],
      size: map['size'],
      breed: map['breed'],
      features: List<String>.from(map['features']),
      colors: List<String>.from(map['colors']),
    );
  }
}
