import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/homepageActivities.dart';

class Homepageactivityprovider with ChangeNotifier {
  List<HomePageActivity> _activities = [];
  final Map<String, List<HomePageActivity>> _cache = {}; // Cache map

  List<HomePageActivity> get activities => _activities;
  Future<void> fetchPlacesForCity(String city) async {
    // Categories mapping for Nominatim queries
    final categories = {
      'Food': 'restaurant',
      'Entertainment': 'entertainment',
      'Landmarks': 'landmark',
      'Sea': 'beach',
    };

    List<HomePageActivity> fetchedActivities = [];

    try {
      for (final category in categories.entries) {
        // Cache key is a combination of city and category
        final cacheKey = '${city}_${category.key}';

        // Check if the result is already in cache
        if (_cache.containsKey(cacheKey)) {
          fetchedActivities.addAll(_cache[cacheKey]!);
          continue; // Skip API call if results are cached
        }

        // Build the API URL
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(city)}%20${category.value}&format=json&addressdetails=1&limit=10',
        );

        // Send the API request
        final response = await http.get(
          url,
          headers: {"User-Agent": "egywander (egywander@gmail.com)"},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          final categoryActivities = await Future.wait(
              data.map<Future<HomePageActivity>>((place) async {
            final placeWithCategory = (place as Map<String, dynamic>)
              ..['category'] = category.key;
            return HomePageActivity.fromJsonAsync(placeWithCategory);
          }).toList());

          fetchedActivities.addAll(categoryActivities);

          // Cache the results for this city and category
          // _cache[cacheKey] = categoryActivities;
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
}
