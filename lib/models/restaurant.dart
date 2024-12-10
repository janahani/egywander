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
  final bool isAccepted; // New field to track if the restaurant is a favorite

  // Constructor
  Restaurant({
    String? id,
    required this.ownerId,
    required this.name,
    required this.contactNumber,
    required this.location,
    required this.cuisineType,
    this.isAccepted = false, // Default to false if not provided
  }) : id = id ?? const Uuid().v4();

  // Method to convert CuisineType to string
  String get cuisineTypeAsString {
    return cuisineType.toString().split('.').last;
  }

  // Method to display restaurant details
  @override
  String toString() {
    return 'id: $id\n'
          'Restaurant Name: $name\n'
           'Owner ID: $ownerId\n'
           'Contact: $contactNumber\n'
           'Address: $location\n'
           'Cuisine Type: ${cuisineTypeAsString}\n'
           'Accepted: $isAccepted'; // Include isFavorite in toString
  }

  // Convert Restaurant object to Map<String, dynamic> (for saving in Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'contactNumber': contactNumber,
      'address': location,
      'cuisineType': cuisineType.toString().split('.').last, // Store as a string
      'isAccepted': isAccepted, // Add isFavorite to the map
    };
  }

  // Create a Restaurant object from Map<String, dynamic> (when fetching from Firebase)
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      location: map['location'] ?? '',
      cuisineType: CuisineType.values.firstWhere(
        (type) => type.toString().split('.').last == map['cuisineType'],
        orElse: () => CuisineType.Other, // Default value if not found
      ),
      isAccepted: map['isAccepted'] ?? false, // Default to false if not found
    );
  }

    // Method to determine status based on isAccepted
  String get status {
    if (isAccepted) {
      return "Accepted";
    } else {
      return "Pending";
    }
  }
}

