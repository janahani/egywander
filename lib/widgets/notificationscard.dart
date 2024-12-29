import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String date;
  final String location;
  final String time;
  final String
      formattedNotificationMessage; // Added for the notification message

  const ReminderCard({
    super.key,
    required this.date,
    required this.location,
    required this.time,
    required this.formattedNotificationMessage, // Accepting formatted notification message
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // Adjusted padding
      child: Container(
        width: double.infinity, // Full width for the card
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the card
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color(0x33000000),
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification message at the top
              Text(
                formattedNotificationMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10), // Space between message and time
              // Time row with the starting and ending time
              Row(
                children: [
                  Icon(Icons.access_time,
                      color: Colors.black, size: 18), // Time icon
                  SizedBox(width: 6), // Space between icon and time text
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
