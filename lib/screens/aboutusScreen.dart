//packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//widget
import 'package:egywander/widgets/systembars.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section with Image
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome to EgyWanders!',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'EgyWanders is here to help you explore the best of Egypt! Once you sign up, you can easily discover a variety of exciting places, from cultural landmarks to the best restaurants and malls. Whether you’re looking for adventure or a relaxing day out, we’ve got you covered.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Key Features Section with Icons
            Text(
              'Key Features',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.orange),
                  title: Text(
                    'Detailed Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Get detailed information about each location, including opening hours, reviews, and photos.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.filter_alt, color: Colors.orange),
                  title: Text(
                    'Smart Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Filter activities based on type, budget, ratings, and proximity.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.schedule, color: Colors.orange),
                  title: Text(
                    'Personalized Schedules',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Create your personalized schedules and receive reminders to keep you on track.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.orange),
                  title: Text(
                    'Live Alerts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Get weather alerts or disruptions so you can adjust your plans accordingly.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.phone_android, color: Colors.orange),
                  title: Text(
                    'User-Friendly Interface',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Our app ensures that discovering Egypt is both easy and enjoyable.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Closing Statement Section with Divider
            Divider(color: Colors.grey.shade400, thickness: 1),
            const SizedBox(height: 20),
            Text(
              'We hope you enjoy every moment of your adventures with EgyWanders!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.orange,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //     ),
            //     child: const Text(
            //       'Back to Home',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
