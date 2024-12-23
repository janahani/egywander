import 'package:egywander/notificationsDbHelper.dart';
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
  String popularCategory = 'Most Popular';

  void _fetchActivities(BuildContext context, String city) async {
  final provider = Provider.of<Homepageactivityprovider>(context, listen: false);

  try {
    // Fetch places and popular places concurrently
    await Future.wait([
      provider.fetchPlacesForCity(city),
      provider.fetchPopularPlacesForCity(city),
    ]);
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
                  GestureDetector(
                    onTap: () => _fetchActivities(context, 'Cairo'),
                    child: Container(
                      width: 182,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('assets/images/pyramids.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Orange Overlay
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Cairo',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _fetchActivities(context, 'Luxor and Aswan'),
                    child: Container(
                      width: 182,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('assets/images/welcomescreen.jpg'), 
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Orange Overlay
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Luxor & Aswan',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    isSelected: selectedCategory == 'Entertainment',
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Entertainment';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Food',
                    color: const Color.fromARGB(255, 158, 158, 158),
                    isSelected: selectedCategory == 'Food',
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Food';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Landmarks',
                    color: Colors.grey,
                    isSelected: selectedCategory == 'Landmarks',
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Landmarks';
                      });
                    },
                  ),
                  CategoryChip(
                    label: 'Sea',
                    color: Colors.grey,
                    isSelected: selectedCategory == 'Sea',
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    // Filter activities for the selected category ("Available Places")
                    final filteredActivities = provider.activities
                        .where((activity) => activity.category == selectedCategory)
                        .toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
                        return TravelCard(homePageActivity: activity);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 35),
              // New section for "Most Popular"
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Most Popular Places',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300,
                child: Consumer<Homepageactivityprovider>(
                  builder: (context, provider, child) {
                    // Filter activities for the "Most Popular" category
                    final popularActivities = provider.activities
                        .where((activity) => activity.category == 'Most Popular')
                        .toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularActivities.length,
                      itemBuilder: (context, index) {
                        final activity = popularActivities[index];
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
