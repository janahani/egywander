//packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//model
import 'package:egywander/models/homepageActivities.dart';

class Homepageactivityprovider with ChangeNotifier {
  final Map<String, List<HomePageActivity>> _cache = {};

  List<HomePageActivity> _activities = [];
  List<HomePageActivity> _popularActivities = [];

  List<HomePageActivity> get activities => _activities;
  List<HomePageActivity> get popularActivities => _popularActivities;

  Future<List<String>> _getApprovedRestaurantNames() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('isAccepted', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => (doc.data()['restaurantName'] as String).toLowerCase())
          .toList();
    } catch (e) {
      print('Error fetching approved restaurants: $e');
      return [];
    }
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

        if (_cache.containsKey(cacheKey)) {
          print('Cache hit for $cacheKey');
          fetchedActivities.addAll(_cache[cacheKey]!);
          continue;
        } else {
          print('Cache miss for $cacheKey');
        }

        if (category.key == 'Food') {
          final approvedRestaurants = await FirebaseFirestore.instance
              .collection('restaurants')
              .where('isAccepted', isEqualTo: true)
              .get();

          for (var doc in approvedRestaurants.docs) {
            final restaurantName = doc['restaurantName'] ?? '';
            final url = Uri.parse(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent('$restaurantName in $city')}&key=$apiKey&region=EG");

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
                      final details =
                          json.decode(detailsResponse.body)['result'];
                      return HomePageActivity.fromGooglePlace(
                          details, category.key);
                    }
                    return null; // Skip failed fetches
                  }).toList(),
                );

                final validActivities =
                    categoryActivities.whereType<HomePageActivity>().toList();
                _cache[cacheKey] = validActivities;

                fetchedActivities.addAll(validActivities);
              }
            } else {
              throw Exception(
                  'API call failed for Food category with status: ${response.statusCode}');
            }
          }
        } else {
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
                    return HomePageActivity.fromGooglePlace(
                        details, category.key);
                  }
                  return null; // Skip failed fetches
                }).toList(),
              );

              final validActivities =
                  categoryActivities.whereType<HomePageActivity>().toList();
              _cache[cacheKey] = validActivities;

              fetchedActivities.addAll(validActivities);
            }
          } else {
            throw Exception(
                'API call failed for ${category.key} with status: ${response.statusCode}');
          }
        }
      }

      _activities = fetchedActivities;
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

  Future<HomePageActivity?> fetchActivityById(String placeId) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    try {
      final detailsUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=place_id,name,rating,user_ratings_total,formatted_address,photos,types,opening_hours,reviews,geometry/location&key=$apiKey");
      final response = await http.get(detailsUrl);
      if (response.statusCode == 200) {
        final details = json.decode(response.body)['result'];
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