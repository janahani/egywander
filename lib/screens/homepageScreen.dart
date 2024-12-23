import 'package:flutter/material.dart';
import '../widgets/categorychip.dart';
import '../widgets/travelcard.dart';
import '../widgets/systembars.dart';
import '../providers/restaurantProvider.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/homepageactivityprovider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Entertainment'; // Default category
  void _fetchActivities(BuildContext context, String city) async {
    final provider =
        Provider.of<Homepageactivityprovider>(context, listen: false);

    try {
      await provider.fetchPlacesForCity(city);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch activities for $city: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchActivities(context, 'Cairo'); // Example: Fetch for Cairo on load
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Schedule your',
                    style: TextStyle(fontSize: 24, color: Colors.black54),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'trip to Egypt!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search places',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _fetchActivities(context, 'Cairo'),
                    child: Text('Cairo'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _fetchActivities(context, 'Luxor'),
                    child: Text('Luxor and Aswan'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryChip(
                    label: 'Entertainment',
                    color: const Color.fromARGB(255, 158, 158, 158),
                    isSelected: selectedCategory ==
                        'Entertainment', // Check if this category is selected
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Entertainment';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Food',
                    color: const Color.fromARGB(255, 158, 158, 158),
                    isSelected: selectedCategory ==
                        'Food', // Check if this category is selected
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Food';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Landmarks',
                    color: Colors.grey,
                    isSelected: selectedCategory ==
                        'Landmarks', // Check if this category is selected
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Landmarks';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Sea',
                    color: Colors.grey,
                    isSelected: selectedCategory ==
                        'Sea', // Check if this category is selected
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Sea';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Places',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300, // Optional: Remove height for a scrollable grid
                child: Consumer<Homepageactivityprovider>(
                  builder: (context, provider, child) {
                    final activities = provider.activities;

                    if (activities.isEmpty) {
                      return const Center(
                        child: Text(
                          'No activities found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            2 / 3, // Adjust ratio to allow more height
                      ),
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return TravelCard(homePageActivity: activity);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
