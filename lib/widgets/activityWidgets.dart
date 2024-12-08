import 'package:flutter/material.dart';

// Widget for Top Image Section
class TopImageSection extends StatelessWidget {
  final String imageUrl;

  const TopImageSection({required this.imageUrl});

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
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          location,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// Widget for Price and Rating Section
class PriceAndRatingSection extends StatelessWidget {
  final String price;
  final double rating;

  const PriceAndRatingSection({
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          price,
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

  const InfoTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.orange),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

// Widget for Description Section
class DescriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Description Unavailable', // Placeholder
      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
    );
  }
}

// Widget for Heart Icon with Snackbar
class FavoriteIcon extends StatefulWidget {
  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });

    // Show snackbar when the heart is pressed
    final snackBar = SnackBar(
      content: Text(isFavorited ? 'Added to Favorites' : 'Removed from Favorites'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: CircleAvatar(
        radius: 24, // Adjust size
        backgroundColor: Colors.white.withOpacity(1), // Light transparent background
        child: Icon(
          Icons.favorite,
          color: isFavorited ? Colors.orange : Colors.grey[400], // Icon color changes
          size: 28, // Icon size
        ),
      ),
    );
  }
}

// Widget for Book Now Button
class BookNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Book Now',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
