import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePageActivity {
  final String id;
  final String name;
  final String location;
  final String? imageUrl;
  final double? rating;
  final int? userRatingsTotal;
  final String category; 
  

  HomePageActivity({
    required this.id,
    required this.name,
    required this.location,
    this.imageUrl,
    this.rating,
    this.userRatingsTotal,
    required this.category, 
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
    );
  }

   factory HomePageActivity.fromGooglePlace(Map<String, dynamic> place) {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    String category = 'Other';
    if (place['types'] != null) {
      final types = List<String>.from(place['types']);
      if (types.contains('restaurant') || types.contains('food')) {
        category = 'Food';
      } else if (types.contains('tourist_attraction') || types.contains('museum')) {
        category = 'Landmarks';
      } else if (types.contains('aquarium') || types.contains('spa') || types.contains('zoo') || types.contains('movie_theater')) {
        category = 'Entertainment';
      } else if (types.contains('beach') || types.contains('sea')) {
        category = 'Sea';
      }
    }

    return HomePageActivity(
      id: place['place_id'] ?? const Uuid().v4(),
      name: place['name'] ?? '',
      location: place['formatted_address'] ?? '',
      imageUrl: place['photos'] != null
          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['photos'][0]['photo_reference']}&key=$apiKey'
          : null,
      rating: (place['rating'] as num?)?.toDouble(),
      userRatingsTotal: place['user_ratings_total'] as int?,
      category: category, // Set inferred category
    );
  }
}
