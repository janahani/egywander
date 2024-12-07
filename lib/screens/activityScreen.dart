import 'package:flutter/material.dart';
import '../widgets/systembars.dart';


class ActivityScreen extends StatelessWidget {
  final Map<String, dynamic> tourData = {
    'name': 'Pyramids Tour',
    'location': 'Giza Plateau',
    'rating': 4.8,
    'imageUrl':
        'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxweXJhbWlkc3xlbnwwfHx8fDE3MzM1MTMxMTJ8MA&ixlib=rb-4.0.3&q=80&w=400',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      backgroundColor: Colors.grey[100],
      body: Container(
        width: double.infinity,
        height: double.infinity, // Full height of the screen
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Top Image Section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        child: Image.network(
                          tourData['imageUrl'], // Dynamic Image
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.more_vert, color: Colors.black),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.favorite, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  // Content Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Section
                          Text(
                            tourData['name'], // Dynamic Name
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            tourData['location'], // Dynamic Location
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                          // Price and Ratings
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$1200/Person', // Example price
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange, // Price in orange
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < tourData['rating'].round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Info Tiles Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _infoTile(Icons.directions_walk, '5KM', context),
                              _infoTile(
                                  Icons.calendar_today, '2 Days', context),
                              _infoTile(
                                  Icons.wb_sunny, '32°C Sunny', context),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Description Section
                          Text(
                            'Experience the grandeur of the Pyramids of Giza, one of the Seven Wonders of the Ancient World. Explore the history, marvel at the architecture, and immerse yourself in ancient Egyptian culture.',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          Spacer(),
                          // Book Now Button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.orange, // Orange button
                            ),
                            child: Text(
                              'Book Now',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
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

  Widget _infoTile(IconData icon, String text, BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.orange), // Icon in orange
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
