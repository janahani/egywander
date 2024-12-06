import 'package:flutter/material.dart';
import '../widgets/categorychip.dart';
import '../widgets/travelcard.dart';
import '../widgets/systembars.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(),
      bottomNavigationBar: bottomNavigationBar(),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryChip(label: 'Entertainment', color: Colors.orange),
                CategoryChip(label: 'Food', color: Colors.grey),
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
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),),
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TravelCard(
                    image: 'assets/images/welcomescreen.jpg',
                    title: 'Aswan Temple',
                    location: 'Aswan, Egypt',
                    people: '+15',
                  ),
                  TravelCard(
                    image: 'assets/images/pyramids.jpg',
                    title: 'Pyramids of Giza',
                    location: 'Giza, Egypt',
                    people: '+20',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
