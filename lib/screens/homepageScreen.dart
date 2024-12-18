import 'package:flutter/material.dart';
import '../widgets/categorychip.dart';
import '../widgets/travelcard.dart';
import '../widgets/systembars.dart';
import '../providers/restaurantProvider.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/homepageactivityprovider.dart';

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
                    onPressed: () =>
                        _fetchActivities(context, 'Luxor and Aswan'),
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
                height: 300,
                child: Consumer<Homepageactivityprovider>(
                  builder: (context, provider, child) {
                    final filteredActivities = provider.activities
                        .where(
                            (activity) => activity.category == selectedCategory)
                        .take(10)
                        .toList();
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
                        return TravelCard(
                          homePageActivity: activity,
                        );
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
