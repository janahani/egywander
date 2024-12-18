// Favorites Model
class FavoriteActivity {
  final String userId;
  final String placeId;
  final bool isFavorite;

  FavoriteActivity({
    required this.userId,
    required this.placeId,
    this.isFavorite = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'placeId': placeId,
      'isFavorite': isFavorite,
    };
  }

  factory FavoriteActivity.fromMap(Map<String, dynamic> map) {
    return FavoriteActivity(
      userId: map['userId'] ?? '',
      placeId: map['placeId'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
