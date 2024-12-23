import 'package:egywander/models/homepageActivities.dart';
import 'package:egywander/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:egywander/widgets/activityWidgets.dart';
import '../widgets/systembars.dart';
import './addActivityScreen.dart';
import '../widgets/customBtn.dart';
import '../providers/userProvider.dart';
import 'package:latlong2/latlong.dart';

class ActivityScreen extends StatefulWidget {
  final HomePageActivity homePageActivity;

  const ActivityScreen({
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
                TopImageSection(
                    imageUrl: widget.homePageActivity.imageUrl), // Main Image
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Icon(Icons.favorite, color: Colors.red,),
                  // FavoriteIcon(
                  //     placeId: widget.homePageActivity.id),
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
                    location: widget.homePageActivity.location,
                  ),
                  const SizedBox(height: 16),
                  CategoryAndRatingSection(
                    category: widget.homePageActivity.category,
                    rating: widget.homePageActivity.rating?.toDouble() ??
                        0.0, // Default to 0.0
                  ),
                  const SizedBox(height: 16),
                  _InfoTilesRow(),
                  const SizedBox(height: 30),
                   if (widget.homePageActivity.latitude != null &&
                      widget.homePageActivity.longitude != null)
                    Container(
                        height: 200,
                        width: double.infinity,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                                widget.homePageActivity.latitude ?? 0,
                                widget.homePageActivity.longitude ?? 0),
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                      widget.homePageActivity.latitude ?? 0,
                                      widget.homePageActivity.longitude ?? 0),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
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
                      openingHours: widget.homePageActivity.openingHours ?? []),
                  const SizedBox(height: 20),
                  Reviews(reviews: widget.homePageActivity.reviews ?? []),
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
          icon: Icons.star,
          text: widget.homePageActivity.rating?.toStringAsFixed(1) ?? "N/A",
        ),
        InfoTile(
          icon: Icons.person,
          text: widget.homePageActivity.userRatingsTotal?.toString() ?? "0",
        ),
        InfoTile(
          icon: widget.homePageActivity.isOpened == true
              ? Icons.meeting_room
              : Icons.door_front_door,
          text: widget.homePageActivity.isOpened == true
              ? "Opened Now"
              : "Closed Now",
        ),
      ],
    );
  }
}
