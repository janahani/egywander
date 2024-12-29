import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePageActivity {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double? rating;
  final int? userRatingsTotal;
  String category;
  final List<String> openingHours;
  final bool isOpened;
  final List<Map<String, dynamic>> reviews;
  final double? latitude;
  final double? longitude;

  HomePageActivity({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.rating,
    this.userRatingsTotal,
    required this.category,
    required this.openingHours,
    required this.isOpened,
    required this.reviews,
    this.latitude,
    this.longitude,
  });

  // Create a HomePageActivity object from a JSON map
  factory HomePageActivity.fromJson(Map<String, dynamic> json) {
    return HomePageActivity(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      location: json['location'] ?? 'Unknown',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      userRatingsTotal: json['userRatingsTotal'] as int? ?? 0,
      category: json['category'] ?? 'Unknown',
      openingHours: json['openingHours'] != null
          ? List<String>.from(json['openingHours'])
          : [],
      isOpened: json['isOpened'] ?? false,
      reviews: json['reviews'] != null
          ? List<Map<String, dynamic>>.from(json['reviews'])
          : [],
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Create a HomePageActivity object from Google Place API
  factory HomePageActivity.fromGooglePlace(
      Map<String, dynamic> place, String category) {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    return HomePageActivity(
      id: place['place_id'] ?? const Uuid().v4(),
      name: place['name'] ?? 'Unknown',
      location: place['formatted_address'] ?? 'Unknown Location',
      imageUrl: place['photos'] != null && place['photos'].isNotEmpty
          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['photos'][0]['photo_reference']}&key=$apiKey'
          : 'https://via.placeholder.com/150',
      rating: (place['rating'] as num?)?.toDouble() ?? 0.0,
      userRatingsTotal: place['user_ratings_total'] as int? ?? 0,
      category: category,
      openingHours: place['opening_hours']?['weekday_text'] != null
          ? List<String>.from(place['opening_hours']['weekday_text'])
          : [],
      isOpened: place['opening_hours']?['open_now'] ?? false,
      reviews: place['reviews'] != null
          ? List<Map<String, dynamic>>.from(place['reviews'])
          : [],
      latitude:
          (place['geometry']['location']['lat'] as num?)?.toDouble() ?? 0.0,
      longitude:
          (place['geometry']['location']['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
