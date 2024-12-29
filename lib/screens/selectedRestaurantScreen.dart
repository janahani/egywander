//package
import 'package:flutter/material.dart';

//widgets
import 'package:egywander/widgets/systembars.dart';
import 'package:egywander/widgets/customBtn.dart';

//screen
import 'package:egywander/screens/reservationPage.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantName = "Sizzler Stakehouse";
  final String location = "Maadi, Cairo";
  final double rating = 4.8;
  final String cuisineType = "Italian, International";
  final List<String> features = [
    "Wi-Fi",
    "AC",
    "Parking",
    "Outdoor Seating",
    "Live Music"
  ];
  final String imagePath = "assets/images/sizzlereg.jpeg";
  final String workingHours = "10:00 AM - 11:00 PM";

  RestaurantDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Restaurant Image with back navigation button
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath), // Use the asset image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            // Restaurant details
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 224, 224, 224),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurantName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(location,
                          style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cuisine Type
                  Text(
                    "Cuisine: $cuisineType",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Icon(Icons.access_time,
                          color: const Color.fromARGB(255, 85, 85, 85),
                          size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "$workingHours",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Features
                  const Text(
                    "Features",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: features.map((feature) {
                      return Chip(
                        label: Text(
                          feature,
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 152, 0),
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: const Color.fromARGB(255, 253, 177, 63)
                            .withOpacity(0.2),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Map Placeholder
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("Map Placeholder",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reserve Button using CustomButton
                  Center(
                    child: Container(
                      width: 180, // Adjust the width as needed
                      child: CustomButton(
                        text: "Reserve Now",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReservationPage()),
                          );
                        },
                      ),
                    ),
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
