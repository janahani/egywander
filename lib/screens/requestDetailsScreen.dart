import 'package:flutter/material.dart';
import '../widgets/systembars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  RequestDetailsScreen({required this.restaurant});

  // Accept request function
  Future<void> _acceptRequest(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurant["id"])
          .update({"isAccepted": true});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request has been accepted!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Reject request function
  Future<void> _rejectRequest(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurant["id"])
          .update({"isAccepted": false});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request has been rejected!'),
          backgroundColor: Colors.red,
        ),
      );

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reject request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                  // Restaurant Name
                  Text(
                    restaurant["restaurantName"] ?? 'Unknown Restaurant',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Owner Info
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Owner ID: ${restaurant["ownerId"] ?? 'N/A'}"),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Phone: ${restaurant["restaurantPhoneNumber"] ?? 'N/A'}"),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cuisine Type
                  Text(
                    "Cuisine Type: ${restaurant["cuisineType"] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  Text(
                    "Location: ${restaurant["restaurantLocation"] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),

                  // Working Hours
                  Text(
                    "Working Hours: 10:00 AM - 11:00 PM",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),

                  // Accept/Reject Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _acceptRequest(context);
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
                          _rejectRequest(context);
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
