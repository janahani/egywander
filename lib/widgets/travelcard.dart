import 'package:flutter/material.dart';
import 'package:egywander/screens/activityScreen.dart';

class TravelCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String people;
  final double rating;

  const TravelCard({
    required this.image,
    required this.title,
    required this.location,
    required this.people,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the ActivityScreen and pass all relevant data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityScreen(
              title: title,
              location: location,
              imageUrl: image,
              price: '0',
              rating: rating,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network( // Use Image.network for the image URL
                image, 
                height: 120, 
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              location,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.group, size: 16, color: Colors.black54),
                SizedBox(width: 5),
                Text(people, style: TextStyle(color: Colors.black54)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
