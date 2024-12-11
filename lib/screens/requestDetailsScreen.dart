import 'package:flutter/material.dart';
import '../widgets/systembars.dart';

class RequestDetailsScreen extends StatelessWidget {
  final Map<String, String> restaurant;

  RequestDetailsScreen({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Restaurant Image

            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/sizzlereg.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Restaurant Details Section
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Text(
                    restaurant["Restaurant"]!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Owner: ${restaurant["Owner"]}"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Email: ${restaurant["Email"]}"),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Additional Details Section
                  const Text(
                    "Additional Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Cuisine Type: Italian, International",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Location: Maadi, Cairo",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Working Hours: 10:00 AM - 11:00 PM",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),

                  // Features Section
                  const Text(
                    "Features",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text("Wi-Fi"),
                        backgroundColor: Colors.grey[200],
                      ),
                      Chip(
                        label: Text("Outdoor Seating"),
                        backgroundColor: Colors.grey[200],
                      ),
                      Chip(
                        label: Text("Live Music"),
                        backgroundColor: Colors.grey[200],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Accept/Reject Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Show confirmation dialog for Accept
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Accept Request'),
                                content: Text(
                                    "Are you sure you want to accept ${restaurant["Restaurant"]}'s request?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // Perform Accept Logic
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          "Accept",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Show confirmation dialog for Reject
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Reject Request'),
                                content: Text(
                                    "Are you sure you want to reject ${restaurant["Restaurant"]}'s request?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // Perform Reject Logic
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          "Reject",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
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
