import 'package:egywander/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import '/widgets/notificationscard.dart';
import '../widgets/systembars.dart';
import 'package:provider/provider.dart';
import 'package:egywander/providers/userProvider.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:egywander/notificationsDbHelper.dart'; // Import the database helper


class NotificationsScreen extends StatefulWidget {
  final Function onViewedNotifications; // Callback to notify the AppBar

  const NotificationsScreen({required this.onViewedNotifications, Key? key})
      : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final NotificationDbHelper _db = NotificationDbHelper.instance;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _removeExpiredNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onViewedNotifications(); // Notify the AppBar
    });
  }

  Future<void> _deleteAllNotificationsOnce() async {
    await _db.clearAllNotifications();
  }

  Future<void> _loadNotifications() async {
    List<Map<String, dynamic>> allNotifications =
        await _db.getNotificationsForToday();
    DateTime now = DateTime.now();

    setState(() {
      _notifications = allNotifications.where((notification) {
        DateTime notificationTime =
            DateTime.parse(notification['notificationsTime']);
        DateTime endOfDay = DateTime(
            now.year, now.month, now.day, 23, 59, 59); // Today's end time

        // Include notifications if notification time has passed and today hasn't ended
        return now.isAfter(notificationTime) && now.isBefore(endOfDay);
      }).toList();
    });
  }

  Future<void> _removeExpiredNotifications() async {
    DateTime now = DateTime.now();
    // Remove notifications from previous days
    await _db.removeExpiredNotifications();
  }

  String _formatDuration(Duration duration) {
    // Format the duration as "X hours Y minutes"
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;

    if(hours>0 && minutes>0)
    {
      return '$hours.$minutes hours';
    }
    else if(hours>0 && minutes==0)
    {
      return '$hours hours';
    }
    else if(hours==0 && minutes>0)
    {
      return '$minutes minutes';
    }

    return '0';
    
  }

  String _formatNotificationMessage(Map<String, dynamic> notification) {
    String placeName = notification['placename'];
    DateTime tripStartTime = DateTime.parse(notification['startingTime']);
    DateTime tripEndTime = DateTime.parse(notification['endingTime']);

    // Calculate the duration between start and end time
    Duration duration = tripEndTime.difference(tripStartTime);

    // Format the duration and generate the message
    String formattedDuration = _formatDuration(duration);

    // Calculate the exact time the user should be at the place
    String formattedStartTime = DateFormat('HH:mm').format(tripStartTime);

    return 'Your trip to $placeName today starts at $formattedStartTime. Be there on time and get ready as soon as possible for your $formattedDuration long trip!';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
     if (!userProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You should log in/register")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return Scaffold();
    }


    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: appBar(context),
        bottomNavigationBar: bottomNavigationBar(context),
        body: SafeArea(
          top: true,
          child: ListView(
            children: [
              // Display notifications dynamically
              for (var notification in _notifications)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ReminderCard(
                    date: DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(notification['date'])),
                    location: notification['placename'],
                    // Format the start and end times
                    time:
                        '${DateFormat('HH:mm').format(DateTime.parse(notification['startingTime']))} - ${DateFormat('HH:mm').format(DateTime.parse(notification['endingTime']))}',
                    // Pass the formatted notification message with the duration
                    formattedNotificationMessage:
                        _formatNotificationMessage(notification),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
