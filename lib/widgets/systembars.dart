import 'package:egywander/screens/accountScreen.dart';
import 'package:flutter/material.dart';
import '../screens/notificationsScreen.dart';

AppBar appBar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: const Text(
      "EgyWanders",
      style: TextStyle(
          color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    actions: [
      Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
             onPressed: () {
                    // Navigate to NotificationsScreen when the IconButton is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
          ),
          const Positioned(
            right: 10,
            top: 10,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: Text(
                '2',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          )
        ],
      )
    ],
  );
}

BottomNavigationBar bottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Colors.orange,
    selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
    unselectedItemColor: const Color.fromARGB(255, 231, 231, 231),
    onTap: (index) {
      // Handling tap for different indexes
      if (index == 3) { // Account tab index
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountScreen()),
        );
      } else {
        // Handle navigation for other items (Home, Favorites, Schedule)
        // You can add code for navigation here if needed for other items
      }
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: 'Schedule',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_box),
        label: 'Account',
      ),
    ],
    type: BottomNavigationBarType.fixed,
  );
}

