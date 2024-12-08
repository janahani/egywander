class FavoriteActivity {
  final String placeId; // Unique ID of the place
  final bool isFavorite; // Indicates if the place is marked as favorite

  // Constructor
  FavoriteActivity({
    required this.placeId,
    this.isFavorite = false, // Default to false if not specified
  });

  // Convert FavoriteActivity object to Map<String, dynamic> (for saving in Firebase)
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'isFavorite': isFavorite,
    };
  }

  // Create a FavoriteActivity object from Map<String, dynamic> (for fetching from Firebase)
  factory FavoriteActivity.fromMap(Map<String, dynamic> map) {
    return FavoriteActivity(
      placeId: map['placeId'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  @override
  String toString() {
    return 'FavoriteActivity(placeId: $placeId, isFavorite: $isFavorite)';
  }
}
