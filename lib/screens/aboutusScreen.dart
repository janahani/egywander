import 'package:flutter/material.dart';
import 'package:egywander/widgets/systembars.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: SingleChildScrollView(  // Wrap the content in a SingleChildScrollView to make it scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              'Welcome to EgyWanders!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Description Section
            Text(
              'EgyWanders is here to help you explore the best of Egypt! Once you sign up, you can easily discover a variety of exciting places, from cultural landmarks to the best restaurants and malls. Whether you’re looking for adventure or a relaxing day out, we’ve got you covered.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 15),

            // Key Features Section
            Text(
              'Here’s what you can look forward to:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // Key Features List
            Text(
              'You’ll get detailed information about each location, including opening hours, reviews, and photos.\n\n'
              'Need help making decisions? You can filter activities based on type, budget, ratings, and proximity.\n\n'
              'Create your personalized schedules and receive reminders to keep you on track.\n\n'
              'If the weather changes or there are any disruptions, you’ll be alerted so you can adjust your plans.\n\n'
              'Our user-friendly interface ensures that discovering Egypt is both easy and enjoyable.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),

            // Closing Statement Section
            Text(
              'We hope you enjoy every moment of your adventures with EgyWanders!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
