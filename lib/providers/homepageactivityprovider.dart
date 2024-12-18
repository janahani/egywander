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
      "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent('top places in $city')}&key=$apiKey&region=EG",
    );

    final response = await http.get(url);

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Decoded Data: $data');

      if (data['results'] != null && data['results'].isNotEmpty) {
        print('Fetched places: ${data['results']}');
        _activities = data['results']
            .map<HomePageActivity>((place) =>
                HomePageActivity.fromGooglePlace(place))
            .toList();
      } else {
        print('No results found.');
        _activities = [];
      }
    } else {
      print('API call failed: ${response.statusCode} - ${response.body}');
      throw Exception('API call failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    _activities = [];
    rethrow;
  } finally {
    notifyListeners();
  }
}
}
