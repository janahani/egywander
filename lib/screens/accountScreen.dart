import 'package:egywander/widgets/systembars.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Container(
        color: Colors.grey[100],
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
            _buildMenuButton(
              context,
              icon: Icons.person_add,
              text: "Register",
              onTap: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),
            _buildMenuButton(
              context,
              icon: Icons.settings,
              text: "Account Settings",
              onTap: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),
            _buildMenuButton(
              context,
              icon: Icons.info,
              text: "About Us",
              onTap: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),
            _buildMenuButton(
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

  // Helper function to build buttons
  Widget _buildMenuButton(BuildContext context,
      {required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300], // Light gray background
          borderRadius: BorderRadius.circular(12), // Rounded edges
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
