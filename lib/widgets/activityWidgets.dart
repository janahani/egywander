//packages
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//providers
import 'package:egywander/providers/userProvider.dart';
import 'package:egywander/providers/favoriteProvider.dart';

// Widget for Top Image Section
class TopImageSection extends StatelessWidget {
  final String imageUrl;

  const TopImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        fit: BoxFit.cover,
      ),
    );
  }
}

// Widget for Title and Location Section
class TitleAndLocation extends StatelessWidget {
  final String title;
  final String location;

  const TitleAndLocation({
    super.key,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          location,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// Widget for Category and Rating Section
class CategoryAndRatingSection extends StatelessWidget {
  final String category;
  final double rating;

  const CategoryAndRatingSection({
    super.key,
    required this.category,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < rating.round() ? Icons.star : Icons.star_border,
              size: 20,
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget for Info Tile (Used in Info Tiles Row)
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.orange),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[700],
          ),
        )
      ],
    );
  }
}

class FavoriteIcon extends StatelessWidget {
  final String placeId;

  const FavoriteIcon({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite =
        favoritesProvider.favorites.any((fav) => fav.placeId == placeId);

    return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 245, 245), // Background color
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite && userProvider.isLoggedIn
                ? Colors.orange
                : const Color.fromARGB(255, 112, 112, 112),
            size: 35,
          ),
          onPressed: () {
            if (userProvider.isLoggedIn) {
              favoritesProvider.toggleFavorite(
                userProvider.id!,
                placeId,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please log in to manage favorites.')),
              );
            }
          },
        ));
  }
}

class PlaceMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const PlaceMap({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId("place_location"),
              position: LatLng(latitude, longitude),
            ),
          },
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}

class Reviews extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;

  const Reviews({super.key, required this.reviews});

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reviews",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ],
        ),
        if (isExpanded)
          ...widget.reviews.map((review) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['author_name'] ?? 'Anonymous',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review['text'] ?? 'No review text available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }
}

class OpeningHours extends StatefulWidget {
  final List<String> openingHours;

  const OpeningHours({super.key, required this.openingHours});

  @override
  _OpeningHoursState createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Opening Hours",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ],
        ),
        if (isExpanded)
          ...widget.openingHours.map((hour) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                hour,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey[700],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}
