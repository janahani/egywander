//package
import 'package:flutter/material.dart';

//model
import 'package:egywander/models/homepageActivities.dart';

//screen
import 'package:egywander/screens/activityScreen.dart';

class TravelCard extends StatelessWidget {
  final HomePageActivity homePageActivity;

  const TravelCard({
    super.key,
    required this.homePageActivity,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ActivityScreen(homePageActivity: homePageActivity),
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
                width: double.infinity,
                color: Colors.grey[300],
                child: Image.network(
                  homePageActivity.imageUrl,
                  fit: BoxFit.cover,
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              homePageActivity.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              homePageActivity.location,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.group, size: 16, color: Colors.black54),
                const SizedBox(width: 5),
                Text(homePageActivity.userRatingsTotal.toString(),
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
