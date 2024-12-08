// Enum for cuisine types
enum CuisineType { Egyptian, Italian, Chinese, Other }

// Restaurant model class
class Restaurant {
  final String ownerId; 
  final String name; 
  final String contactNumber; 
  final String address;
  final CuisineType cuisineType;

  Restaurant({
    required this.ownerId,
    required this.name,
    required this.contactNumber,
    required this.address,
    required this.cuisineType,
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
           'Address: $address\n'
           'Cuisine Type: ${cuisineTypeAsString}';
  }

    // Convert Restaurant object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'contactNumber': contactNumber,
      'address': address,
      'cuisineType': cuisineType.toString().split('.').last, // Store as a string
    };
  }

  // Create a Restaurant object from Map<String, dynamic>
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      address: map['address'] ?? '',
      cuisineType: CuisineType.values.firstWhere(
        (type) => type.toString().split('.').last == map['cuisineType'],
        orElse: () => CuisineType.Other, // Default value
      ),
    );
  }
}
