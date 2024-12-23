import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/homepageActivities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/restaurant.dart';

class Homepageactivityprovider with ChangeNotifier {
  final Map<String, List<HomePageActivity>> _cache = {}; // Cache map

  List<HomePageActivity> _activities = [];
  List<HomePageActivity> _popularActivities = [];

  List<HomePageActivity> get activities => _activities;
  List<HomePageActivity> get popularActivities => _popularActivities;

  Future<bool> _checkRestaurantApproval(String restaurantName) async {
    if (restaurantName.isEmpty) return false;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('name', isEqualTo: restaurantName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final restaurant = Restaurant.fromMap(querySnapshot.docs.first.data());
        return restaurant.isAccepted;
      }
    } catch (e) {
      print('Error checking restaurant approval: $e');
    }
    return false; // Default to not approved
  }

  Future<void> fetchPlacesForCity(String city) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    final categories = {
      'Food': 'restaurants or food',
      'Entertainment': 'entertainment or activities',
      'Landmarks': 'landmarks or tourist attractions',
      'Sea': 'beaches or sea',
    };

    List<HomePageActivity> fetchedActivities = [];

    try {
      for (final category in categories.entries) {
        final cacheKey = '${city}_${category.key}';

        // Check the cache first
        if (_cache.containsKey(cacheKey)) {
          // Log cache usage
          print('Cache hit for $cacheKey');
          fetchedActivities.addAll(_cache[cacheKey]!);
          continue;
        } else {
          // Log cache miss
          print('Cache miss for $cacheKey');
        }

        // Fetch places from Google Places API
        final url = Uri.parse(
            "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent('${category.value} in $city')}&key=$apiKey&region=EG");

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['results'] != null && data['results'].isNotEmpty) {
            final categoryActivities = await Future.wait<HomePageActivity?>(
              data['results']
                  .take(2)
                  .map<Future<HomePageActivity?>>((place) async {
                final detailsUrl = Uri.parse(
                    "https://maps.googleapis.com/maps/api/place/details/json?place_id=${place['place_id']}&fields=place_id,name,rating,user_ratings_total,formatted_address,photos,types,opening_hours,reviews,geometry/location&key=$apiKey");

                final detailsResponse = await http.get(detailsUrl);

                if (detailsResponse.statusCode == 200) {
                  final details = json.decode(detailsResponse.body)['result'];
                  final restaurantName = details['name'] ?? '';

                  if (category.key == 'Food') {
                    bool isApproved =
                        await _checkRestaurantApproval(restaurantName);
                    if (isApproved) {
                      return HomePageActivity.fromGooglePlace(
                          details, category.key);
                    }
                  } else {
                    return HomePageActivity.fromGooglePlace(
                        details, category.key);
                  }
                }
                return null; // Skip unapproved or failed fetches
              }).toList(),
            );

            // Filter out nulls and add fetched activities to the cache
            final validActivities =
                categoryActivities.whereType<HomePageActivity>().toList();
            _cache[cacheKey] = validActivities;

            // Add to the overall fetched activities
            fetchedActivities.addAll(validActivities);
          }
        } else {
          throw Exception(
              'API call failed for ${category.key} with status: ${response.statusCode}');
        }
      }

      // Update the activities list
      _activities = fetchedActivities;
      // After adding data to the cache
      print('Cache size: ${_cache.length}');
    } catch (e, stackTrace) {
      _activities = [];
      print('Error fetching places: $e\n$stackTrace');
      rethrow;
    }

    notifyListeners();
  }

  Future<void> fetchPopularPlacesForCity(String city) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    final categories = {
      'Most Popular': 'places with high ratings',
    };

    List<HomePageActivity> fetchedPopularActivities = [];

    try {
      for (final category in categories.entries) {
        final cacheKey = '${city}_${category.key}';

        if (_cache.containsKey(cacheKey)) {
          fetchedPopularActivities.addAll(_cache[cacheKey]!);
          continue;
        }

        final url = Uri.parse(
            "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent('${category.value} in $city')}&key=$apiKey&region=EG");

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['results'] != null && data['results'].isNotEmpty) {
            final popularActivities = await Future.wait<HomePageActivity?>(
                data['results']
                    .take(3)
                    .map<Future<HomePageActivity?>>((place) async {
              final detailsUrl = Uri.parse(
                  "https://maps.googleapis.com/maps/api/place/details/json?place_id=${place['place_id']}&fields=place_id,name,rating,user_ratings_total,formatted_address,photos,types,opening_hours,reviews,geometry/location&key=$apiKey");

              final detailsResponse = await http.get(detailsUrl);

              if (detailsResponse.statusCode == 200) {
                final details = json.decode(detailsResponse.body)['result'];
                return HomePageActivity.fromGooglePlace(
                    details, 'Most Popular');
              }
              return null;
            }).toList());

            final validPopularActivities =
                popularActivities.whereType<HomePageActivity>().toList();
            _cache[cacheKey] = validPopularActivities;

            fetchedPopularActivities.addAll(validPopularActivities);
          }
        } else {
          throw Exception(
              'API call failed for ${category.key} with status: ${response.statusCode}');
        }
      }

      _popularActivities = fetchedPopularActivities;
    } catch (e, stackTrace) {
      _popularActivities = [];
      print('Error fetching popular places: $e\n$stackTrace');
      rethrow;
    }

    notifyListeners();
  }
}
