import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      bottomNavigationBar: bottomNavigationBar(context),
      body: Stack(
        children: [
          // Gradient Circle Background
          Positioned(
            top: -250,
            left: 0,
            right: 0,
            child: Container(
              width: 500, // Adjust size for the circle
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.orange.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // User Greeting
                    Text(
                      "Hello, Fatimah",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "fatimah@gmail.com",
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Profile Avatar
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color.fromARGB(255, 255, 237, 209),
                      child: const Icon(
                        Icons.person,
                        color: Colors.orange,
                        size: 60,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Menu Buttons
                    const SizedBox(height: 10),
                    buildMenuButton(
                      context,
                      icon: Icons.supervised_user_circle,
                      text: "Add a User",
                      onTap: () {
                      },
                    ),
                    const SizedBox(height: 10),
                    buildMenuButton(
                      context,
                      icon: Icons.restaurant,
                      text: "Accept/Reject Restaurant Requests",
                      onTap: () {
                      },
                    ),
                    const SizedBox(height: 10),
                    buildMenuButton(
                      context,
                      icon: Icons.group_add,
                      text: "View Users",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsersManagementScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    buildMenuButton(
                      context,
                      icon: Icons.logout,
                      text: "Logout",
                      onTap: () {
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}