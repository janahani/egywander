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
        margin: const EdgeInsets.only(right: 16),
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 120, 
                width: double.infinity, // to match parent width
                color: Colors.grey[300], 
                child: Image.network(
                  image,
                  fit: BoxFit.cover, // Ensures uniform scaling
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ), // Fallback for broken images
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Handles long titles
            ),
            Text(
              location,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Handles long locations
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.group, size: 16, color: Colors.black54),
                const SizedBox(width: 5),
                Text(people, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
