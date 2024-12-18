import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePageActivity {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double? rating;
  final int? userRatingsTotal;
  final String category;
  final List<String> openingHours;
  final List<Map<String, dynamic>> reviews;

  HomePageActivity({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.rating,
    this.userRatingsTotal,
    required this.category,
    required this.openingHours,
    required this.reviews,
  });

  factory HomePageActivity.fromJson(Map<String, dynamic> json) {
    return HomePageActivity(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      location: json['location'] ?? 'Unknown',
      imageUrl: json['imageUrl'],
      rating: json['rating']?.toDouble(),
      userRatingsTotal: json['userRatingsTotal'],
      category: json['category'] ?? 'Unknown',
      openingHours: json['openingHours'] =
          List<String>.from(json['openingHours']),
      reviews: json['reviews'] =
          List<Map<String, dynamic>>.from(json['reviews']),
    );
  }

  factory HomePageActivity.fromGooglePlace(Map<String, dynamic> place) {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    String category = 'Other';
    if (place['types'] != null) {
      final types = List<String>.from(place['types']);
      if (types.contains('restaurant') || types.contains('food')) {
        category = 'Food';
      } else if (types.contains('tourist_attraction') ||
          types.contains('museum')) {
        category = 'Landmarks';
      } else if (types.contains('aquarium') ||
          types.contains('spa') ||
          types.contains('zoo') ||
          types.contains('movie_theater')) {
        category = 'Entertainment';
      } else if (types.contains('beach') || types.contains('sea')) {
        category = 'Sea';
      }
    }

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
      reviews: place['reviews'] != null
          ? List<Map<String, dynamic>>.from(place['reviews'])
          : [],
    );
  }
}
