import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String date;
  final String location;
  final String time;
  final String formattedNotificationMessage;

  const ReminderCard({
    super.key,
    required this.date,
    required this.location,
    required this.time,
    required this.formattedNotificationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification message at the top
              Text(
                formattedNotificationMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),

              SizedBox(height: 10),
              // Time row with the starting and ending time
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.black, size: 18),
                  SizedBox(width: 6),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
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
