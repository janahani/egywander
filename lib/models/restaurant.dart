import 'package:uuid/uuid.dart';

// Enum for cuisine types
enum CuisineType { Egyptian, Italian, Chinese, Other }

// Restaurant model class
class Restaurant {
  final String id;
  final String ownerId;
  final String name;
  final String contactNumber;
  final String location;
  final CuisineType cuisineType;
  final bool isAccepted;
  final bool isReservationAvailable;
  final String? imageUrl; // New optional field for image URL
  final double? rating; // New optional field for rating
  final int? userRatingsTotal; // New optional field for total user ratings

  // Constructor
  Restaurant({
    String? id,
    required this.ownerId,
    required this.name,
    required this.contactNumber,
    required this.location,
    required this.cuisineType,
    this.isAccepted = false,
    this.isReservationAvailable = false,
    this.imageUrl,
    this.rating,
    this.userRatingsTotal,
  }) : id = id ?? const Uuid().v4();

  // Convert CuisineType to string
  String get cuisineTypeAsString => cuisineType.toString().split('.').last;

  // Convert Restaurant object to Map<String, dynamic> (for saving in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'contactNumber': contactNumber,
      'location': location,
      'cuisineType': cuisineTypeAsString,
      'isAccepted': isAccepted,
      'isReservationAvailable': isReservationAvailable,
      'imageUrl': imageUrl,
      'rating': rating,
      'userRatingsTotal': userRatingsTotal,
    };
  }

  // Create a Restaurant object from Map<String, dynamic> (Firestore schema)
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] ?? const Uuid().v4(),
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      location: map['location'] ?? '',
      cuisineType: _cuisineTypeFromString(map['cuisineType']),
      isAccepted: map['isAccepted'] ?? false,
      isReservationAvailable: map['isReservationAvailable'] ?? false,
      imageUrl: map['imageUrl'],
      rating: (map['rating'] as num?)?.toDouble(),
      userRatingsTotal: map['userRatingsTotal'] as int?,
    );
  }

  // Create a Restaurant object from Google Places API response
  factory Restaurant.fromGooglePlace(Map<String, dynamic> place) {
    return Restaurant(
      id: place['place_id'] ?? const Uuid().v4(),
      ownerId: '', // Google Places does not have this
      name: place['name'] ?? '',
      contactNumber: '', // Google Places does not have this
      location: place['formatted_address'] ?? '',
      cuisineType: CuisineType.Other, // Assuming API doesn't provide cuisine type
      isAccepted: true,
      isReservationAvailable: false,
      imageUrl: place['photos'] != null
          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['photos'][0]['photo_reference']}&key=YOUR_API_KEY'
          : null,
      rating: (place['rating'] as num?)?.toDouble(),
      userRatingsTotal: place['user_ratings_total'] as int?,
    );
  }

  // Helper method to parse CuisineType from string
  static CuisineType _cuisineTypeFromString(String? value) {
    if (value == null) return CuisineType.Other;
    return CuisineType.values.firstWhere(
      (type) => type.toString().split('.').last == value,
      orElse: () => CuisineType.Other,
    );
  }

  // Method to get the status of the request
  String get status => isAccepted ? "Accepted" : "Pending";
}
