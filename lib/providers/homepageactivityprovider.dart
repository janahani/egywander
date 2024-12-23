import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/homepageActivities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/restaurant.dart';

class Homepageactivityprovider with ChangeNotifier {
  List<HomePageActivity> _activities = [];
  final Map<String, List<HomePageActivity>> _cache = {};  // Cache map

  List<HomePageActivity> get activities => _activities;

  Future<bool> _checkRestaurantApproval(String restaurantId) async {
    try {
      final restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .get();

      if (restaurantDoc.exists) {
        final restaurant = Restaurant.fromMap(restaurantDoc.data()!);
        return restaurant.isAccepted; 
      }
    } catch (e) {
      print('Error checking restaurant approval: $e');
    }
    return false; 
  }


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
      final cacheKey = '${city}_${category.key}';

      // Check the cache first
      if (_cache.containsKey(cacheKey)) {
        fetchedActivities.addAll(_cache[cacheKey]!);
        continue; 
      }

      // Fetch places from Google Places API
      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent('${category.value} in $city')}&key=$apiKey&region=EG");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final categoryActivities = await Future.wait<HomePageActivity>(
            data['results']
                .take(2) 
                .map<Future<HomePageActivity>>((place) async {
              final detailsUrl = Uri.parse(
                  "https://maps.googleapis.com/maps/api/place/details/json?place_id=${place['place_id']}&fields=place_id,name,rating,user_ratings_total,formatted_address,photos,types,opening_hours,reviews,geometry/location&key=$apiKey");

              final detailsResponse = await http.get(detailsUrl);

              if (detailsResponse.statusCode == 200) {
                final details = json.decode(detailsResponse.body)['result'];
                final restaurant = Restaurant.fromGooglePlace(details);

                if (category.key == 'Food') {
                  bool isApproved = await _checkRestaurantApproval(restaurant.id);
                  if (isApproved) {
                    return HomePageActivity.fromGooglePlace(details, category.key);
                  }
                } else {
                  return HomePageActivity.fromGooglePlace(details, category.key);
                }
              }
              return HomePageActivity.fromGooglePlace(place, category.key);
            }).toList(),
          );

          // Add fetched activities to the cache
          _cache[cacheKey] = categoryActivities;

          // Add to the overall fetched activities
          fetchedActivities.addAll(categoryActivities);
        }
      } else {
        throw Exception('API call failed for ${category.key} with status: ${response.statusCode}');
      }
    }

    // Update the activities list
    _activities = fetchedActivities;
  } catch (e, stackTrace) {
    _activities = [];
    print('Error fetching places: $e\n$stackTrace');
    rethrow;
  }

  notifyListeners();
}


  
}
