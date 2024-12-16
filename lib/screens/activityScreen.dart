import 'package:egywander/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:egywander/widgets/activityWidgets.dart'; // Import the updated widgets
import '../widgets/systembars.dart';
import './addActivityScreen.dart'; // Import the AddActivityScreen
import '../widgets/customBtn.dart'; // Import the CustomButton widget
import '../providers/userProvider.dart'; // Import UserProvider

class ActivityScreen extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final double rating;

  const ActivityScreen({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
  });

  void _openAddActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddActivityScreen(activityTitle: title, activityId: id);
      },
    ).then((result) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Activity added: ${result['title']}")),
        );
      }
    });
  }

  void _handleAddToSchedule(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.isLoggedIn) {
      // User is logged in
      _openAddActivityDialog(context);
    } else {
      // User is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have to register/log in first."),
        ),
      );
      // Redirect to login screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                TopImageSection(imageUrl: imageUrl),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FavoriteIcon(), // Use the reusable FavoriteIcon widget
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndLocation(title: title, location: location),
                  const SizedBox(height: 16),
                  PriceAndRatingSection(price: price, rating: rating),
                  const SizedBox(height: 16),
                  _InfoTilesRow(),
                  const SizedBox(height: 25),
                  DescriptionSection(),
                  const SizedBox(height: 30),

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

                  Center(
                    child: SizedBox(
                      width: 180, // Adjust the width as needed
                      child: CustomButton(
                        text: "Add to Schedule",
                        onPressed: () {
                          _handleAddToSchedule(context);
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

  Widget _InfoTilesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InfoTile(icon: Icons.directions_walk, text: '45 mins'),
        InfoTile(icon: Icons.calendar_today, text: '10/12/2024'),
        InfoTile(icon: Icons.wb_sunny, text: '35°C'),
      ],
    );
  }
}
