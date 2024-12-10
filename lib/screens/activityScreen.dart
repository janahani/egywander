import 'package:flutter/material.dart';
import 'package:egywander/widgets/activityWidgets.dart'; // Import the updated widgets
import '../widgets/systembars.dart';
import './addActivityScreen.dart'; // Import the AddActivityScreen
import '../widgets/customBtn.dart'; // Import the CustomButton widget

class ActivityScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final double rating;

  const ActivityScreen({
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
        return AddActivityScreen(activityTitle: title);
      },
    ).then((result) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Activity added: ${result['title']}")),
        );
      }
    });
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
                  SizedBox(height: 16),
                  PriceAndRatingSection(price: price, rating: rating),
                  SizedBox(height: 16),
                  _InfoTilesRow(),
                  SizedBox(height: 25),
                  DescriptionSection(),
                  SizedBox(height: 30),
                  
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

                  SizedBox(height: 30),

                  Center(
                    child: Container(
                      width: 180, // Adjust the width as needed
                      child: CustomButton(
                        text: "Reserve Now",
                        onPressed: () {
                          _openAddActivityDialog(context);
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
