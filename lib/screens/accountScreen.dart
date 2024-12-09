import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egywander/providers/userProvider.dart';
import 'loginScreen.dart';
import 'accountsettingsScreen.dart';
import 'aboutusScreen.dart';
import '../widgets/systembars.dart';
import 'package:egywander/widgets/accountmenubtns.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: userProvider.isLoggedIn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${userProvider.firstName} ${userProvider.lastName}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userProvider.email ?? "",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
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
                      userProvider.logout();
                    },
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You are not logged in!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Log in or register to get started",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                  buildMenuButton(
                    context,
                    icon: Icons.settings,
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
                ],
              )
      ),
    );
  }
}
