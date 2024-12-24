import 'package:egywander/notificationsDbHelper.dart';
import 'package:egywander/screens/accountScreen.dart';
import 'package:egywander/screens/favoritesScreen.dart';
import 'package:egywander/screens/homepageScreen.dart';
import 'package:egywander/screens/scheduleScreen.dart';
import 'package:egywander/screens/adminDashScreen.dart';
import 'package:flutter/material.dart';
import '../screens/notificationsScreen.dart';
import 'package:provider/provider.dart';
import 'package:egywander/providers/userProvider.dart';

final NotificationDbHelper _db = NotificationDbHelper.instance;

List<Map<String, dynamic>> allNotifications = [];

Future<void> fetchNotifications() async {
  allNotifications = await _db.getNotificationsForToday();
}

// Function to calculate the notification count for today
int calculateNotificationCount() {
  DateTime now = DateTime.now();
  DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  return allNotifications.where((notification) {
    DateTime notificationTime =
        DateTime.parse(notification['notificationsTime']);
    return now.isAfter(notificationTime) && now.isBefore(endOfDay);
  }).length;
}

// Function to mark notifications as viewed
void markNotificationsAsViewed() {
  allNotifications.clear(); // Clear notifications after viewing
  print("Notifications marked as viewed.");
}

AppBar appBar(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: const Text(
      "EGYWANDERS",
      style: TextStyle(
        color: Colors.orange,
        fontSize: 20,
        letterSpacing: 2.0,
        fontFamily: 'egy',
      ),
    ),
    centerTitle: true,
    actions: [
      FutureBuilder(
        future: fetchNotifications(), // Load notifications
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: null, // Disable button while loading
            );
          }

          int notificationCount = calculateNotificationCount();

          return Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(
                        onViewedNotifications: () {
                          markNotificationsAsViewed();
                          (context as Element).markNeedsBuild();
                        },
                      ),
                    ),
                  );
                },
              ),
              if (notificationCount > 0 && userProvider.isLoggedIn)
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}


BottomNavigationBar bottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
    unselectedItemColor: const Color.fromARGB(255, 189, 189, 189),
    onTap: (index) {
      // Handling tap for different indexes
      if (index == 0) {
        // Account tab index
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScheduleScreen()),
        );
      } else if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountScreen()),
        );
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

AppBar adminAppbar(context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.orange),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    elevation: 0,
    actions: [
      Stack(
        children: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),
            onPressed: () {},
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
