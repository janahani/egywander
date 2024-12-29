//packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//model
import 'package:egywander/models/favoriteActivity.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<FavoriteActivity> _favorites = [];

  List<FavoriteActivity> get favorites => _favorites;

  //Fetches the list of favorite activities for the specified user from Firestore
  Future<void> fetchFavorites(String userId) async {
    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();

    _favorites = snapshot.docs
        .map((doc) => FavoriteActivity.fromMap(doc.data()))
        .toList();
    notifyListeners();
  }

  // Toggles the favorite button of a specific place for the specified user in Firestore
  Future<void> toggleFavorite(String userId, String placeId) async {
    final docRef = _firestore.collection('favorites').doc('$userId-$placeId');
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.delete();
      _favorites.removeWhere((fav) => fav.placeId == placeId);
    } else {
      final favorite = FavoriteActivity(userId: userId, placeId: placeId);
      await docRef.set(favorite.toMap());
      _favorites.add(favorite);
    }
    notifyListeners();
  }
}
