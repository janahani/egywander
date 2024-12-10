import 'package:flutter/material.dart';
import 'package:egywander/screens/accountsettingsScreen.dart';
import 'package:egywander/widgets/systembars.dart';
import '/widgets/accountmenubtns.dart';
import 'userManagementScreen.dart';
import 'aboutusScreen.dart';

class AdminDashboardScreen extends StatelessWidget {
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
              "Fatimah Hatem",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "fatimah@gmail.com",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),

            // Buttons for different admin tasks
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.supervised_user_circle,
              text: "View Customers",
              onTap: () {
                // Navigate to Customers page
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.restaurant,
              text: "Accept/Reject Restaurant Requests",
              onTap: () {
                // Navigate to Restaurant Owner Requests page
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.group_add,
              text: "Add Users",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersManagementScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.settings,
              text: "Account Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountSettingsScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.info,
              text: "About Us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            buildMenuButton(
              context,
              icon: Icons.logout,
              text: "Logout",
              onTap: () {
                // Add functionality for logout
              },
            ),
          ],
        ),
      ),
    );
  }
}