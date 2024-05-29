import "package:cloud_firestore/cloud_firestore.dart";
import "package:dismov_app/models/pet_model.dart";
import "package:dismov_app/models/user_preferences_model.dart";
import "package:dismov_app/provider/recommendations_api.dart";
import "package:flutter/material.dart";

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener una mascota por su ID
  Future<PetModel?> getPetById(String petId) async {
    DocumentSnapshot petSnapshot =
        await _firestore.collection('pets').doc(petId).get();

    if (petSnapshot.exists) {
      return PetModel.fromFirebase(petSnapshot);
    } else {
      return null;
    }
  }

  // Método para obtener las recomendaciones de mascotas para un usuario que escucha los cambios en las preferencias del usuario
  Stream<List<PetModel>> getStreamRecommendations(String userId) {
    return _firestore
        .collection('preferences')
        .doc(userId)
        .snapshots()
        .asyncMap((preferencesSnap) async {
      print('Preferences snapshot: $preferencesSnap' );
      print(preferencesSnap.exists);
      if (preferencesSnap.exists) {
        List<PetModel> recommendations =
            await RecommendationsApi.getRecommendations(userId);
        print('Recommendations: $recommendations');
        return recommendations;
      } else {
        return [];
      }
    });
  }

  // Método para agregar una nueva mascota
  Future<void> addPet(PetModel pet) async {
    await _firestore.collection('pets').doc().set(pet.toMap());
  }

  // Método para actualizar la información de una mascota
  Future<void> updatePet(PetModel pet) async {
    await _firestore.collection('pets').doc(pet.id).update(pet.toMap());
  }

  // Método para eliminar una mascota
  Future<void> deletePet(String petId) async {
    await _firestore.collection('pets').doc(petId).delete();
  }

  Future<List<PetModel>> getAllPets() async {
    QuerySnapshot petsSnapshot = await _firestore.collection('pets').get();
    return petsSnapshot.docs.map((doc) => PetModel.fromFirebase(doc)).toList();
  }

  // Método para buscar las mascotas de acuerdo a la cercanía a una ubicación
  Future<List<PetModel>> getPetsNearby(double latitude, double longitude, double radius) async {
    // Calcular los límites del cuadrado que contiene el círculo
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;

    double lowerLat = latitude - (lat * radius);
    double lowerLon = longitude - (lon * radius);

    double greaterLat = latitude + (lat * radius);
    double greaterLon = longitude + (lon * radius);

    // Realizar la consulta de los refugios cercanos
    QuerySnapshot sheltersSnapshot = await _firestore.collection('shelters')
        .where('latitude', isGreaterThan: lowerLat)
        .where('latitude', isLessThan: greaterLat)
        .where('longitude', isGreaterThan: lowerLon)
        .where('longitude', isLessThan: greaterLon)
        .get();

    // Obtener los IDs de los refugios cercanos
    List<String> shelterIds = sheltersSnapshot.docs.map((doc) => doc.id).toList();

    // Realizar la consulta de las mascotas que pertenecen a los refugios cercanos
    QuerySnapshot petsSnapshot = await _firestore.collection('pets')
        .where('shelterId', whereIn: shelterIds)
        .get();

    if (petsSnapshot.docs.isEmpty) return [];
    return petsSnapshot.docs.map((doc) => PetModel.fromFirebase(doc)).toList();
  }

  // Método para obtener las mascotas adoptadas
  Future<List<PetModel>> getAdoptedPets() async {
    QuerySnapshot petsSnapshot = await _firestore.collection('pets').where('adoptionStatus', isEqualTo: 'adopted').get();
    return petsSnapshot.docs.map((doc) => PetModel.fromFirebase(doc)).toList();
  }

  // Método para obtener todas las mascotas disponibles
  Future<List<PetModel>> getAvailablePets() async {
    QuerySnapshot petsSnapshot = await _firestore.collection('pets').where('adoptionStatus', isEqualTo: 'available').get();
    return petsSnapshot.docs.map((doc) => PetModel.fromFirebase(doc)).toList();
  }

  // Método para cancelar la adopción de una mascota
  Future<void> cancelAdoption(String petId) async {
    await _firestore.collection('pets').doc(petId).update({
      'adoptionStatus': 'available',
    });
  }

  // Método para adoptar una mascota
  Future<void> adoptPet(String petId) async {
    await _firestore.collection('pets').doc(petId).update({
      'adoptionStatus': 'adopted',
    });
  }

  // Método para archivar una mascota
  Future<void> archivePet(String petId) async {
    await _firestore.collection('pets').doc(petId).update({
      'adoptionStatus': 'archived',
    });
  }
  Future<List<PetModel>> getPetsByShelterId(String shelterId) async {
    try {
      // Realiza una consulta a tu fuente de datos (base de datos, API, etc.)
      // para obtener las mascotas que pertenecen al refugio con el ID dado
      // Supongamos que tienes una función llamada fetchPetsFromDatabase que hace esto
      List<PetModel> pets = await PetService().getAllPets(); // Esta función debería recuperar las mascotas de la base de datos filtrando por el shelterId
      // Filtra las mascotas por el shelterId
      List<PetModel> filteredPets = pets.where((pet) => pet.shelterId == shelterId).toList();
      // Devuelve las mascotas filtradas
      return filteredPets;
    } catch (error) {
      // Maneja cualquier error que pueda ocurrir durante la recuperación de las mascotas
      throw Exception('Error retrieving pets by shelter ID: $error');
    }
  }

}
