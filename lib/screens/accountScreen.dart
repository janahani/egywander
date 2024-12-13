import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egywander/providers/userProvider.dart';
import 'loginScreen.dart';
import 'accountsettingsScreen.dart';
import 'aboutusScreen.dart';
import '../widgets/systembars.dart';
import 'package:egywander/widgets/accountmenubtns.dart';
import 'OwnerReservationInfoForm.dart';
import 'viewReservationScreen.dart';
import '../screens/requestStatusOwner.dart';
class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        print("User Type in AccountScreen: ${userProvider.userType}");

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: appBar(context),
          bottomNavigationBar: bottomNavigationBar(context),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: userProvider.isLoggedIn
                ? SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // User Avatar and Info
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.orange,
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${userProvider.firstName} ${userProvider.lastName}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userProvider.email ?? "",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        // Common Buttons for All Users
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
                        if (userProvider.userType == "Owner") ...[
                          buildMenuButton(
                            context,
                            icon: Icons.assignment,
                            text: "View Request Status",
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RequestStatusOwner(),
                              ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          buildMenuButton(
                            context,
                            icon: Icons.table_chart,
                            text: "Submit Reservation Info",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OwnerReservationInfoForm(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          buildMenuButton(
                            context,
                            icon: Icons.calendar_today,
                            text: "View Reservations",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewReservationsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 20),
                        buildMenuButton(
                          context,
                          icon: Icons.logout,
                          text: "Logout",
                          onTap: () {
                            userProvider.logout();
                          },
                        ),
                      ],
                    ),
                )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "You are not logged in!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Log in or register to get started",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 97, 97, 97)),
                      ),
                      const SizedBox(height: 20),
                      buildMenuButton(
                        context,
                        icon: Icons.login,
                        text: "Login/Register",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
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
                    ],
                  ),
          ),
        );
      },
    );
  }
}
