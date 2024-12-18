import 'package:egywander/models/homepageActivities.dart';
import 'package:egywander/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egywander/widgets/activityWidgets.dart';
import '../widgets/systembars.dart';
import './addActivityScreen.dart';
import '../widgets/customBtn.dart';
import '../providers/userProvider.dart';

class ActivityScreen extends StatelessWidget {
  final HomePageActivity homePageActivity;

  const ActivityScreen({
    required this.homePageActivity,
  });

  void _openAddActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddActivityScreen(
            activityTitle: homePageActivity.name,
            activityId: homePageActivity.id);
      },
    ).then((result) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Activity added: \${result['homePageActivity.name']}")),
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
                TopImageSection(imageUrl: homePageActivity.imageUrl),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FavoriteIcon(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndLocation(
                      title: homePageActivity.name,
                      location: homePageActivity.location),
                  const SizedBox(height: 16),
                  CategoryAndRatingSection(
                      category: homePageActivity.category,
                      rating: homePageActivity.rating!.toDouble()),
                  const SizedBox(height: 16),
                  _InfoTilesRow(),
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
                  // Opening Hours Section
                  OpeningHours(openingHours: homePageActivity.openingHours),
                  const SizedBox(height: 20),
                  // Reviews Section
                  Reviews(reviews: homePageActivity.reviews),
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
        InfoTile(icon: Icons.star, text: homePageActivity.rating.toString()),
        InfoTile(
            icon: Icons.person,
            text: homePageActivity.userRatingsTotal.toString()),
        InfoTile(
            icon: homePageActivity.isOpened == true
                ? Icons.meeting_room
                : Icons.door_front_door,
            text: homePageActivity.isOpened == true
                ? "Opened Now"
                : "Closed Now"),
      ],
    );
  }
}
