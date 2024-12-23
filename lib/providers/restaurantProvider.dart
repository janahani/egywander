import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/tableinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  Map<String, List<TableInfo>> _restaurantTables = {};
  Map<String, dynamic>? restaurantDetails;

  List<Restaurant> get restaurants => _restaurants;

  String? _restaurantId;
  String? _ownerId;
  String? _name;
  String? _contactNumber;
  String? _location;

  // Getters
  String? get restaurantId => _restaurantId;
  String? get ownerId => _ownerId;
  String? get name => _name;
  String? get contactNumber => _contactNumber;
  String? get location => _location;

  // Setters with notifyListeners to rebuild UI
  void setRestaurantId(String restaurantId) {
    _restaurantId = restaurantId;
    notifyListeners();
  }

  void setOwnerId(String ownerId) {
    _ownerId = ownerId;
    notifyListeners();
  }

  void setRestaurantData({
    required String restaurantId,
    required String ownerId,
    required String name,
    required String contactNumber,
    required String location,
  }) {
    _restaurantId = restaurantId;
    _ownerId = ownerId;
    _name = name;
    _contactNumber = contactNumber;
    _location = location;
    notifyListeners();
  }

  void clearRestaurantData() {
    _restaurantId = null;
    _ownerId = null;
    _name = null;
    _contactNumber = null;
    _location = null;
    notifyListeners();
  }

  // Add table info related to a specific restaurant
  void addTableInfo(String restaurantId, TableInfo tableInfo) {
    if (_restaurantTables.containsKey(restaurantId)) {
      _restaurantTables[restaurantId]?.add(tableInfo);
      notifyListeners();
    }
  }

  // Get table info for a specific restaurant
  List<TableInfo>? getTableInfo(String restaurantId) {
    return _restaurantTables[restaurantId];
  }

  // Fetch restaurant details using Nominatim API
  Future<void> fetchRestaurantDetailsUsingNominatim(String query) async {
    final baseUrl = "https://nominatim.openstreetmap.org/search";
    final url = Uri.parse(
        "$baseUrl?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=10");

    try {
      final response = await http.get(url, headers: {
        "User-Agent": "egywander (fatimahhatem3@gmail.com)"
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          // Extract details from the first result
          restaurantDetails = {
            "name": query,
            "latitude": data[0]["lat"],
            "longitude": data[0]["lon"],
            "address": data[0]["display_name"],
          };
          notifyListeners();
        } else {
          restaurantDetails = null; // No results found
          notifyListeners();
        }
      } else {
        throw Exception("Failed to fetch restaurant details");
      }
    } catch (e) {
      print("Error fetching restaurant details: $e");
      restaurantDetails = null;
      notifyListeners();
    }
  }

  // Example: Cache restaurant data in Firestore
  // Future<void> cacheRestaurantData(String restaurantId, Map<String, dynamic> data) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('restaurants')
  //         .doc(restaurantId)
  //         .set(data);
  //   } catch (e) {
  //     print("Error caching restaurant data: $e");
  //   }
  // }
  Future<Restaurant?> fetchRestaurantDetailsByOwnerId(String ownerId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('ownerId', isEqualTo: ownerId)
          .limit(1)
          .get();

      if (doc.docs.isNotEmpty) {
        return Restaurant.fromMap(doc.docs.first.data());
      } else {
        return null; // No restaurant found
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      return null;
    }
  }
  Future<Restaurant?> fetchRestaurantDetailsById(String restaurantId) async {
    try {
      // Fetch restaurant document by its ID
      var doc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId) // Use doc instead of where to search by ID
          .get();

      if (doc.exists) {
        // Ensure all fields are included in the Restaurant object
        return Restaurant.fromMap(
            doc.data()!); // Convert the document data to Restaurant object
      } else {
        return null; // Return null if the restaurant does not exist
      }
    } catch (e) {
      print('Error fetching restaurant: $e');
      return null;
    }
  }
  Future<String?> fetchRestaurantIdByOwnerId(String ownerId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('ownerId', isEqualTo: ownerId)
          .limit(1)
          .get();

      if (doc.docs.isNotEmpty) {
        return doc.docs.first.id; // Return the restaurant ID if found
      } else {
        return null; // Return null if no restaurant found
      }
    } catch (e) {
      print('Error fetching restaurant: $e');
      return null; // Return null on error
    }
  }
}
