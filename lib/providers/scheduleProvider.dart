import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> fetchPlaceName(String placeId) async {
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  try {
    // Construct the Place Details API URL
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name&key=$apiKey',
    );

    // Send the HTTP request
    final response = await http.get(url);

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Extract the 'name' field from the response
      if (data['status'] == 'OK' && data['result'] != null) {
        final String placeName = data['result']['name'];
        print('Fetched Place Name: $placeName');
        return placeName;
      } else {
        print('Error: ${data['status']}');
        return null;
      }
    } else {
      print('API call failed: ${response.statusCode} - ${response.body}');
      throw Exception('API call failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}