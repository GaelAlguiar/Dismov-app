import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../app/utils/location.dart';

class LocationModel {
  Position? ubicacion;
  LocationModel({
    required this.ubicacion, // Puede ser nulo
  });

  // Método para convertir un objeto de ubicacion a un mapa
  Map<String, dynamic> toMap() {
    return {
      'ubicacionUsuario': ubicacion,// No es necesario establecer un valor predeterminado
    };
  }

  // Método para crear un objeto de usuario desde un mapa
  factory LocationModel.fromGPS(Position? location)  {


    return LocationModel(
      ubicacion: location ?? null,
    );
  }
}