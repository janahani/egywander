import 'package:flutter/material.dart';
import 'package:egywander/widgets/activityWidgets.dart'; // Import the updated widgets
import '../widgets/systembars.dart';
import './addActivityScreen.dart'; // Import the AddActivityScreen

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
                  SizedBox(height: 16),
                  DescriptionSection(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _openAddActivityDialog(context), // Open the AddActivity pop-up
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 242, 227, 194)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Add Activity",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
        InfoTile(icon: Icons.directions_walk, text: 'N/A'),
        InfoTile(icon: Icons.calendar_today, text: 'N/A'),
        InfoTile(icon: Icons.wb_sunny, text: 'N/A'),
      ],
    );
  }
}