// Enum for cuisine types
enum CuisineType { Egyptian, Italian, Chinese, Other }

// Restaurant model class
class Restaurant {
  final String ownerId; 
  final String name; 
  final String contactNumber; 
  final String location;
  final CuisineType cuisineType;
  final bool isFavorite; // New field to track if the restaurant is a favorite

  // Constructor
  Restaurant({
    required this.ownerId,
    required this.name,
    required this.contactNumber,
    required this.location,
    required this.cuisineType,
    this.isFavorite = false, // Default to false if not provided
  });

  // Method to convert CuisineType to string
  String get cuisineTypeAsString {
    return cuisineType.toString().split('.').last;
  }

  // Method to display restaurant details
  @override
  String toString() {
    return 'Restaurant Name: $name\n'
           'Owner ID: $ownerId\n'
           'Contact: $contactNumber\n'
           'Address: $location\n'
           'Cuisine Type: ${cuisineTypeAsString}\n'
           'Favorite: $isFavorite'; // Include isFavorite in toString
  }

  // Convert Restaurant object to Map<String, dynamic> (for saving in Firebase)
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'contactNumber': contactNumber,
      'address': location,
      'cuisineType': cuisineType.toString().split('.').last, // Store as a string
      'isFavorite': isFavorite, // Add isFavorite to the map
    };
  }

  // Create a Restaurant object from Map<String, dynamic> (when fetching from Firebase)
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      location: map['location'] ?? '',
      cuisineType: CuisineType.values.firstWhere(
        (type) => type.toString().split('.').last == map['cuisineType'],
        orElse: () => CuisineType.Other, // Default value if not found
      ),
      isFavorite: map['isFavorite'] ?? false, // Default to false if not found
    );
  }
}

