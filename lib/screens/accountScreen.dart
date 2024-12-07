import 'package:egywander/screens/accountsettingsScreen.dart';
import 'package:egywander/screens/loginScreen.dart';
import 'package:egywander/widgets/systembars.dart';
import 'package:flutter/material.dart';
import '/widgets/accountmenubtns.dart';
import 'aboutusScreen.dart'; // Import About Us screen

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CircleAvatar with Name and Email
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Jana Hani",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "janahani.nbis@gmail.com",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            // Buttons with rounded edges and gray background
            buildMenuButton(
              context,
              icon: Icons.person_add,
              text: "Login/Register",
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(), // Navigate to AboutUsScreen
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.settings,
              text: "Account Settings",
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountSettingsScreen(), // Navigate to AboutUsScreen
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.info,
              text: "About Us",
              onTap: () {
                // Show the splash effect first and then navigate
                Future.delayed(Duration(milliseconds: 100), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutUsScreen(), // Navigate to AboutUsScreen
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.logout,
              text: "Logout",
              onTap: () {
                // Add functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
