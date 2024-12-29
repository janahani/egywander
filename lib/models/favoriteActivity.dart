class FavoriteActivity {
  final String userId;
  final String placeId;
  final bool isFavorite;

  FavoriteActivity({
    required this.userId,
    required this.placeId,
    this.isFavorite = true,
  });

  // Convert favorite activity object in to map from firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'placeId': placeId,
      'isFavorite': isFavorite,
    };
  }

  // Convert map to favorite activity object from firestore
  factory FavoriteActivity.fromMap(Map<String, dynamic> map) {
    return FavoriteActivity(
      userId: map['userId'] ?? '',
      placeId: map['placeId'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
