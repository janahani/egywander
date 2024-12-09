import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String date;
  final String location;
  final String time;
  final String imageUrl;
  final bool isHighlighted;

  const ReminderCard({
    Key? key,
    required this.date,
    required this.location,
    required this.time,
    required this.imageUrl,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 393,
        height: 131,
        decoration: BoxDecoration(
          color: isHighlighted ? const Color.fromARGB(255, 242, 227, 194): Colors.white, // Highlighted card gets grey background
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color(0x33000000),
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Left text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15), // Consistent padding for left and right
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date row with icon and text
                    Row(
                      children: [
                        Icon(Icons.date_range, color: Colors.black, size: 18), // Black icon for date
                        SizedBox(width: 6), // Space between icon and date text
                        Text(
                          date,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontFamily: 'Inter Tight',
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Spacing between date and location
                    // Location text
                    Text(
                      location,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: 10), // Spacing between location and time
                    // Time row with icon and styled text
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.black, size: 18), // Black icon for time
                        SizedBox(width: 6), // Space between icon and time text
                        Text(
                          time,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontFamily: 'Inter Tight',
                                fontSize: 16,
                                color: Colors.black54, // Custom color for time
                                fontWeight: FontWeight.bold, // Better font weight
                                fontStyle: FontStyle.normal,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Right image content
            Padding(
              padding: const EdgeInsets.only(right: 15), // Consistent right padding
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 153,
                  height: 100,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
