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
  final bool isAccepted; // Track if the restaurant request is accepted
  final bool isReservationAvailable;

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
  }) : id = id ?? const Uuid().v4();

  // Convert CuisineType to string
  String get cuisineTypeAsString {
    return cuisineType.toString().split('.').last;
  }

  // Convert Restaurant object to Map<String, dynamic> (for saving in Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'contactNumber': contactNumber,
      'location': location,
      'cuisineType': cuisineType.toString().split('.').last, // Store as a string
      'isAccepted': isAccepted,
      'isReservationAvailable': isReservationAvailable,
    };
  }

  // Create a Restaurant object from Map<String, dynamic> (when fetching from Firebase)
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['restaurantName'] ?? '',  
      contactNumber: map['restaurantPhoneNumber'] ?? '',  
      location: map['restaurantLocation'] ?? '',  
      cuisineType: CuisineType.values.firstWhere(
        (type) => type.toString().split('.').last == map['cuisineType'],
        orElse: () => CuisineType.Other,
      ),
      isAccepted: map['isAccepted'] ?? false,
      isReservationAvailable: map['isReservationAvailable'] ?? false,
    );
  }

  // Method to get the status of the request
  String get status {
    if (isAccepted) {
      return "Accepted";
    } else {
      return "Pending";
    }
  }
}
