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

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedCategory = 'Entertainment'; // Default category
  double selectedRating = 3.0; // Default rating
  String selectedPlace = 'All'; // Default place
  List<String> cities = ['All', 'Cairo', 'Luxor and Aswan', 'Hurghada'];

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

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Activities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: [
                  ...['Entertainment', 'Food', 'Sea', 'Landmarks'].map(
                    (category) => ChoiceChip(
                      side: BorderSide.none,
                      backgroundColor: Color.fromARGB(255, 242, 227, 194),
                      selectedColor: Color.fromARGB(255, 242, 227, 194),
                      label: Text(category, style: TextStyle(color: const Color.fromARGB(255, 162, 98, 1)),),
                      selected: selectedCategory == category,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory =
                              selected ? category : selectedCategory;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'City',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedPlace,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPlace = newValue!;
                  });
                },
                items: cities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Rating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Slider(
                thumbColor: Colors.orange,
                activeColor: Colors.orange,
                value: selectedRating,
                min: 1,
                max: 5,
                divisions: 4,
                label: selectedRating.toString(),
                onChanged: (double value) {
                  setState(() {
                    selectedRating = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    Navigator.pop(context);
                    // Logic to apply filters
                    _applyFilters();
                  },
                  child: const Text('Apply Filters', style: TextStyle(fontSize: 16,color: Colors.white),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    //still figuring it out XD
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
              SizedBox(
                height: 10,
              ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _openFilterSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: Colors.grey[700],
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
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
