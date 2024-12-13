import 'package:egywander/screens/admindashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/systembars.dart';
import 'requestDetailsScreen.dart';

class RestaurantManagementScreen extends StatefulWidget {
  @override
  _RestaurantManagementScreenState createState() =>
      _RestaurantManagementScreenState();
}

class _RestaurantManagementScreenState
    extends State<RestaurantManagementScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Fetch restaurant requests from Firestore based on acceptance status
  Future<List<Map<String, dynamic>>> _fetchRestaurantRequests(bool isAccepted) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('isAccepted', isEqualTo: isAccepted)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        } as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching restaurants: $e');
      throw e;
    }
  }

  // Filter restaurants based on the search query
  List<Map<String, dynamic>> _filterRestaurants(
      List<Map<String, dynamic>> restaurants, String query) {
    if (query.isEmpty) return restaurants;
    return restaurants
        .where((restaurant) => restaurant["restaurantName"]
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: adminAppbar(context),
        body: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Restaurant Requests',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by restaurant name",
                  prefixIcon: Icon(Icons.search, color: Colors.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey, width: 0.8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.orange, width: 1.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // TabBar
            TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              labelStyle: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(child: Text("Restaurants")),
                Tab(child: Text("Requests")),
              ],
            ),
            // Display the restaurant list using FutureBuilder
            Expanded(
              child: TabBarView(
                children: [
                  _buildRestaurantListView(true),
                  _buildRestaurantListView(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantListView(bool isAccepted) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchRestaurantRequests(isAccepted),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(isAccepted ? 'No accepted restaurants found.' : 'No rejected restaurants found.'));
        } else {
          List<Map<String, dynamic>> filteredRestaurants =
              _filterRestaurants(snapshot.data!, _searchQuery);
          return _buildRestaurantList(filteredRestaurants);
        }
      },
    );
  }

  Widget _buildRestaurantList(List<Map<String, dynamic>> restaurants) {
    if (restaurants.isEmpty) {
      return Center(
        child: Text(
          "No restaurant requests found.",
          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            title: Text(
              restaurant["restaurantName"],
              style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Owner: ${restaurant["ownerId"]}",
              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestDetailsScreen(
                      restaurant: restaurant
                          .map((key, value) => MapEntry(key, value.toString())),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'View Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
