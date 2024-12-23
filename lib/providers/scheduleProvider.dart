import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> fetchPlaceName(String query) async {
  try {
    // Construct the Nominatim API URL
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=1',
    );

    // Send the HTTP request
    final response = await http.get(
      url,
      headers: {"User-Agent": "YourAppName (your.email@example.com)"},
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Extract the 'display_name' field from the response
      if (data.isNotEmpty) {
        final String placeName = data[0]['display_name'];
        print('Fetched Place Name: $placeName');
        return placeName;
      } else {
        print('No results found');
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
