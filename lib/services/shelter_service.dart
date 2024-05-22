import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/models/shelter_model.dart';
import 'package:geolocator/geolocator.dart';

import '../app/utils/location.dart'; // Asegúrate de importar el modelo aquí

class ShelterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener un refugio por su ID
  Future<ShelterModel?> getShelterById(String shelterId) async {
      DocumentSnapshot shelterSnapshot =
          await _firestore.collection('shelters').doc(shelterId).get();
      if (shelterSnapshot.exists) {
        return ShelterModel.fromFirebase(shelterSnapshot);
      } else {
        return null;
      }
  }

  // Método para agregar un nuevo refugio
  Future<String> addShelter(ShelterModel shelter) async {
    DocumentReference docRef = await _firestore.collection('shelters').add(shelter.toMap());
    // update the shelter with the id
    await _firestore.collection('shelters').doc(docRef.id).update({
      'uid': docRef.id,
    });
    return docRef.id;
  }

  // Método para actualizar la información de un refugio
  Future<void> updateShelter(ShelterModel shelter) async {
    await _firestore.collection('shelters').doc(shelter.uid).update(shelter.toMap());
  }

  // Método para eliminar un refugio
  Future<void> deleteShelter(String shelterId) async {
    await _firestore.collection('shelters').doc(shelterId).delete();
  }

  // Metodo para obtener todos los refugios
  Future<List<ShelterModel>> getAllShelters() async {
    QuerySnapshot sheltersSnapshot = await _firestore.collection('shelters').get();
    return sheltersSnapshot.docs.map((doc) => ShelterModel.fromFirebase(doc)).toList();
  }
  Future<List<ShelterModel>> getSheltersByPosition() async {
    Position ubication = await LocationUtils().getCurrentLocation();
    List<ShelterModel> sheltersList = await getAllShelters();
    sheltersList.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        ubication.latitude,
        ubication.longitude,
        a.latitude,
        a.longitude,
      );
      double distanceB = Geolocator.distanceBetween(
        ubication.latitude,
        ubication.longitude,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });
    return sheltersList;
  }

  // Método para buscar los refugios de acuerdo a la cercanía a una ubicación
  Future<List<ShelterModel>> getSheltersNearby(double latitude, double longitude, double radius) async {
    // Calcular los límites del cuadrado que contiene el círculo
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;

    double lowerLat = latitude - (lat * radius);
    double lowerLon = longitude - (lon * radius);

    double greaterLat = latitude + (lat * radius);
    double greaterLon = longitude + (lon * radius);

    // Realizar la consulta
    QuerySnapshot sheltersSnapshot = await _firestore.collection('shelters')
        .where('latitude', isGreaterThan: lowerLat)
        .where('latitude', isLessThan: greaterLat)
        .where('longitude', isGreaterThan: lowerLon)
        .where('longitude', isLessThan: greaterLon)
        .get();

    if (sheltersSnapshot.docs.isEmpty) {
      return [];
    }
    return sheltersSnapshot.docs.map((doc) => ShelterModel.fromFirebase(doc)).toList();
  }

  // 
}
