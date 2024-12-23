import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/splashImageAPI.dart';

class HomePageActivity {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double? rating;
  final int? userRatingsTotal;
  final String category;
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
  factory HomePageActivity.fromJson(
      Map<String, dynamic> json, String imageUrl) {
    final address = json['address'] ?? {};

    return HomePageActivity(
      id: json['place_id']?.toString() ?? const Uuid().v4(),
      name: json['name'] ?? address['road'] ?? 'Unknown',
      location: json['display_name'] ?? 'Unknown Location',
      imageUrl: imageUrl,
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      userRatingsTotal: json['userRatingsTotal'] as int? ?? null,
      category: json['category'] ?? 'Unknown',
      openingHours: json['openingHours'] != null
          ? List<String>.from(json['openingHours'])
          : [],
      isOpened: json['isOpened'] ?? false,
      reviews: json['reviews'] != null
          ? List<Map<String, dynamic>>.from(json['reviews'])
          : [],
      latitude: double.tryParse(json['lat']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['lon']?.toString() ?? '') ?? 0.0,
    );
  }

  // Asynchronous method to create an instance
  static Future<HomePageActivity> fromJsonAsync(
      Map<String, dynamic> json) async {
    // Fetch the name for the Unsplash query
    final name = json['name'] ?? json['display_name'] ?? 'restaurant';

    // Fetch the image URL based on the name
    final imageUrl = await UnsplashService.fetchImage(name);
    // Use the synchronous constructor to return the final object
    return HomePageActivity.fromJson(
        json, imageUrl ?? 'https://via.placeholder.com/150');
  }

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
