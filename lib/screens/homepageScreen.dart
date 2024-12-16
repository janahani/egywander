import 'package:flutter/material.dart';
import '../widgets/categorychip.dart';
import '../widgets/travelcard.dart';
import '../widgets/systembars.dart';
import '../providers/restaurantProvider.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';

class HomeScreen extends StatelessWidget {
  
 void _fetchPlaces(BuildContext context, String city) async {
  final provider = Provider.of<RestaurantProvider>(context, listen: false);
  
  try {
    await provider.fetchPlacesForCity(city);

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch places for $city: $e')),
      
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
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Schedule your',
                  style: TextStyle(fontSize: 24, color: Colors.black54),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'trip to Egypt!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
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
                  onPressed: () => _fetchPlaces(context, 'Cairo'),
                  child: Text('Cairo'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _fetchPlaces(context, 'Luxor and Aswan'),
                  child: Text('Luxor and Aswan'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryChip(
                    label: 'Entertainment',
                    color: const Color.fromARGB(255, 255, 152, 0)),
                CategoryChip(
                    label: 'Food',
                    color: const Color.fromARGB(255, 158, 158, 158)),
                CategoryChip(label: 'Desert', color: Colors.grey),
                CategoryChip(label: 'Sea', color: Colors.grey),
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
            Expanded(
              child: Consumer<RestaurantProvider>(
                builder: (context, provider, child) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: provider.restaurants
                        .map(
                          (place) => TravelCard(
                            
                            image: place.imageUrl ??
                                'https://via.placeholder.com/150', // Default image URL
                            title: place.name.isNotEmpty
                                ? place.name
                                : 'Unknown Restaurant', // Default title
                            location: place.location.isNotEmpty
                                ? place.location
                                : 'Unknown Location', // Default location
                            people: place.userRatingsTotal != null
                                ? '+${place.userRatingsTotal}'
                                : '+0', // Default people count
                            rating: place.rating ?? 0.0, // Default rating
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
