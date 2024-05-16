import "package:cloud_firestore/cloud_firestore.dart";
import "package:dismov_app/models/favorite_model.dart";

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // favorites are in users/{userId}/favorites/{favoriteId}

  // Method to get all favorites of a user
  Future<List<String>> getFavoritesByUserId(String userId) async {
    QuerySnapshot favoritesSnapshot = await _firestore.collection("users").doc(userId).collection("favorites").get();
    return favoritesSnapshot.docs.map((doc) => doc.id).toList();
  }

  // Method to add a new favorite to a user
  Future<void> addFavorite(String userId, FavoriteModel favorite) async {
    await _firestore.collection("users").doc(userId).collection("favorites").doc(favorite.id).set(favorite.toMap());
  }

  // Method to remove a favorite from a user
  Future<void> removeFavorite(String userId, String favoriteId) async {
    await _firestore.collection("users").doc(userId).collection("favorites").doc(favoriteId).delete();
  }
}