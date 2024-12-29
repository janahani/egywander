//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//model
import 'package:egywander/models/homepageActivities.dart';

//screens
import 'package:egywander/screens/loginScreen.dart';
import 'package:egywander/screens/addActivityScreen.dart';

//widgets
import 'package:egywander/widgets/activityWidgets.dart';
import 'package:egywander/widgets/customBtn.dart';
import 'package:egywander/widgets/systembars.dart';

//provider
import 'package:egywander/providers/userProvider.dart';

class ActivityScreen extends StatefulWidget {
  final HomePageActivity homePageActivity;

  const ActivityScreen({
    super.key,
    required this.homePageActivity,
  });

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  void _openAddActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddActivityScreen(
            activityTitle: widget.homePageActivity.name,
            activityId: widget.homePageActivity.id);
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
      _openAddActivityDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have to register/log in first."),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void update() {
    setState(() {});
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
                TopImageSection(imageUrl: widget.homePageActivity.imageUrl),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FavoriteIcon(placeId: widget.homePageActivity.id),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndLocation(
                      title: widget.homePageActivity.name,
                      location: widget.homePageActivity.location),
                  const SizedBox(height: 16),
                  CategoryAndRatingSection(
                      category: widget.homePageActivity.category,
                      rating: widget.homePageActivity.rating!.toDouble()),
                  const SizedBox(height: 16),
                  _InfoTilesRow(),
                  const SizedBox(height: 30),
                  if (widget.homePageActivity.latitude != null &&
                      widget.homePageActivity.longitude != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            widget.homePageActivity.latitude!,
                            widget.homePageActivity.longitude!,
                          ),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(widget.homePageActivity.id),
                            position: LatLng(
                              widget.homePageActivity.latitude!,
                              widget.homePageActivity.longitude!,
                            ),
                            infoWindow: InfoWindow(
                              title: widget.homePageActivity.name,
                              snippet: widget.homePageActivity.location,
                            ),
                          ),
                        },
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          "Location not available",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  OpeningHours(
                      openingHours: widget.homePageActivity.openingHours),
                  const SizedBox(height: 20),
                  Reviews(reviews: widget.homePageActivity.reviews),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 180,
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
        InfoTile(
            icon: Icons.star, text: widget.homePageActivity.rating.toString()),
        InfoTile(
            icon: Icons.person,
            text: widget.homePageActivity.userRatingsTotal.toString()),
        InfoTile(
            icon: widget.homePageActivity.isOpened == true
                ? Icons.meeting_room
                : Icons.door_front_door,
            text: widget.homePageActivity.isOpened == true
                ? "Opened Now"
                : "Closed Now"),
      ],
    );
  }
}
