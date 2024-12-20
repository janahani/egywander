<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import '../models/homepageActivities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Homepageactivityprovider with ChangeNotifier {
  List<HomePageActivity> _activities = [];

  List<HomePageActivity> get activities => _activities;

  Future<void> fetchPlacesForCity(String city) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    final categories = {
      'Food': 'restaurants or food',
      'Entertainment': 'entertainment or activities',
      'Landmarks': 'landmarks or tourist attractions',
      'Sea': 'beaches or sea'
    };

    List<HomePageActivity> fetchedActivities = [];

    try {
      for (final category in categories.entries) {
        final url = Uri.parse(
            "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent('${category.value} in $city')}&key=$apiKey&region=EG");

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['results'] != null && data['results'].isNotEmpty) {
            final categoryActivities = await Future.wait<HomePageActivity>(
              data['results'].map<Future<HomePageActivity>>((place) async {
                final detailsUrl = Uri.parse(
                    "https://maps.googleapis.com/maps/api/place/details/json?place_id=${place['place_id']}&fields=place_id,name,rating,user_ratings_total,formatted_address,photos,types,opening_hours,reviews,geometry/location&key=$apiKey");

                final detailsResponse = await http.get(detailsUrl);

                if (detailsResponse.statusCode == 200) {
                  final details = json.decode(detailsResponse.body)['result'];
                  return HomePageActivity.fromGooglePlace(
                      details, category.key);
                } else {
                  return HomePageActivity.fromGooglePlace(place, category.key);
                }
              }).toList(),
            );

            fetchedActivities.addAll(categoryActivities);
          }
        } else {
          throw Exception(
              'API call failed for ${category.key} with status: ${response.statusCode}');
        }
      }

      _activities = fetchedActivities;
    } catch (e, stackTrace) {
      _activities = [];
      print('Error fetching places: $e\n$stackTrace');
      rethrow;
    }

    notifyListeners();
  }

  Future<HomePageActivity?> fetchActivityById(String placeId) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    try {
      final detailsUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=place_id,name,rating,user_ratings_total,formatted_address,photos,types,opening_hours,reviews,geometry/location&key=$apiKey");

      final response = await http.get(detailsUrl);

      if (response.statusCode == 200) {
        final details = json.decode(response.body)['result'];

        // Assuming you have a method to parse the details into a HomePageActivity object
        return HomePageActivity.fromGooglePlace(details, 'Unknown');
      } else {
        throw Exception(
            'Failed to fetch details for placeId $placeId with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching activity by placeId: $e\n$stackTrace');
      return null;
    }
  }
}
=======
>>>>>>> Stashed changes
