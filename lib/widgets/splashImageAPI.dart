import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UnsplashService {
  static const String _baseUrl = "https://api.unsplash.com/search/photos";

  static Future<String?> fetchImage(String query) async {
    try {
      final apiKey = dotenv.env['UNSPLASH_ACCESS_KEY'] ?? '';

      final url = Uri.parse("$_baseUrl?query=$query&client_id=$apiKey&per_page=10"); // Fetch 10 images
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final results = data['results'] as List;

          // Randomize selection
          final randomIndex = Random().nextInt(results.length);
          return results[randomIndex]['urls']['regular'];
        }
      } else {
        print("Failed to fetch images: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Unsplash image: $e");
    }

    // Fallback to a placeholder image if no result is found
    return 'https://via.placeholder.com/150';
  }
}
