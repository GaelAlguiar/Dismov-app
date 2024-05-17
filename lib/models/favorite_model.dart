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
  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      petId: map['petId'],
    );
  }
}
