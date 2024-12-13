import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egywander/screens/accountsettingsScreen.dart';
import 'package:egywander/widgets/systembars.dart';
import '/widgets/accountmenubtns.dart';
import 'userManagementScreen.dart';
import 'aboutusScreen.dart';
import 'restaurantManagementScreen.dart';
import 'addUserScreen.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    var screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: bottomNavigationBar(context),
      body: Stack(
        children: [
          // Gradient Circle Background
          Positioned(
            top: spacing(-250),
            left: 0,
            right: 0,
            child: Container(
              width: spacing(500), // Adjust size for the circle
              height: spacing(500),
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
                padding:
                     EdgeInsets.symmetric(horizontal: spacing(16), vertical: spacing(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     SizedBox(height: spacing(40)),

                    // User Greeting
                    Text(
                      "Hello, Fatimah",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: fontSize(28),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                     SizedBox(height: spacing(5)),
                    Text(
                      "fatimah@gmail.com",
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                     SizedBox(height: spacing(30)),

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUserScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    buildMenuButton(
                      context,
                      icon: Icons.restaurant,
                      text: "Restaurant Management",
                      onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantManagementScreen(),
                          ),);},
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
                      onTap: () {},
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
