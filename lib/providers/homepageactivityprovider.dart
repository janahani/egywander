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

    try {
      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent('top places in $city')}&key=$apiKey&region=EG");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          _activities =
              await Future.wait(data['results'].map<Future<HomePageActivity>>(
            (place) async {
              final detailsUrl = Uri.parse(
                  "https://maps.googleapis.com/maps/api/place/details/json?place_id=${place['place_id']}&fields=place_id,name,rating,user_ratings_total,formatted_address,photos,types,opening_hours,reviews,geometry/location&key=$apiKey");

              final detailsResponse = await http.get(detailsUrl);
              if (detailsResponse.statusCode == 200) {
                final details = json.decode(detailsResponse.body)['result'];
                return HomePageActivity.fromGooglePlace(details);
              } else {
                return HomePageActivity.fromGooglePlace(place);
              }
            },
          ).toList());
        } else {
          _activities = [];
        }
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _activities = [];
      print('Error fetching places: $e\n$stackTrace');
      rethrow;
    }
  }
}
