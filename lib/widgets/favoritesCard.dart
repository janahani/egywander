//package
import 'package:flutter/material.dart';

//model
import 'package:egywander/models/homepageActivities.dart';

//screen
import 'package:egywander/screens/activityScreen.dart';

class FavoritesCard extends StatelessWidget {
  final VoidCallback remove;
  final HomePageActivity activity;

  const FavoritesCard(
      {super.key, required this.remove, required this.activity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        activity.category = ' ';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityScreen(homePageActivity: activity),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color(0x33000000),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Left image content
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  activity.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Right text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      activity.location,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 5),
                        Text(
                          activity.rating!.toStringAsFixed(1),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.favorite, color: Colors.orange),
                          onPressed: remove,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
