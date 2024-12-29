//packages
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//model
import 'package:egywander/models/homepageActivities.dart';

class SearchProvider with ChangeNotifier {
  Timer? _debounce;
  List<HomePageActivity> _searchResults = [];
  bool _isLoading = false;

  List<HomePageActivity> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  Future<void> searchPlaces(String query) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    final normalizedQuery = query.trim().toLowerCase();

    // Egypt's approximate central coordinates
    final egyptLat = 26.8206;
    final egyptLng = 30.8025;

    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(query)}&key=$apiKey&region=EG&location=$egyptLat,$egyptLng");

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null) {
          _searchResults = data['results']
              .where((place) {
                final placeName =
                    (place['name'] ?? '').toString().toLowerCase();
                return placeName.contains(normalizedQuery);
              })
              .map<HomePageActivity>((place) {
                final normalizedPlace = place;
                normalizedPlace['name'] = _capitalize(place['name'] ?? '');
                return HomePageActivity.fromGooglePlace(
                    normalizedPlace, 'Search Result');
              })
              .take(3)
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching search results: $e');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void debounceSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchPlaces(query);
    });
  }
}
