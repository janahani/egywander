import 'package:flutter/material.dart';
import '/widgets/notificationscard.dart';
import '../widgets/systembars.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Back button icon
            onPressed: () {
              Navigator.of(context).pop(); // Pop the current screen off the stack
            },
          ),
          title: Text(
            'Reminders',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontFamily: 'Inter Tight',
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        bottomNavigationBar: bottomNavigationBar(),
        body: SafeArea(
          top: true,
          child: ListView(
            children: [
              // ReminderCard for Pyramids with isHighlighted set to true
              ReminderCard(
                date: 'Today, 06/12/2024',
                location: 'Pyramids of Giza',
                time: '3-5 pm',
                imageUrl:
                    'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxweXJhbWlkc3xlbnwwfHx8fDE3MzM1MTMxMTJ8MA&ixlib=rb-4.0.3&q=80&w=400',
                isHighlighted: true, // Highlighted card
              ),
              // ReminderCard for Khan El Khalili without highlight
              ReminderCard(
                date: 'Yesterday, 05/12/2024',
                location: 'Khan El Khalili',
                time: '5-7 pm',
                imageUrl:
                    'https://images.unsplash.com/photo-1729956816147-92d4d2ef48ac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxraGFuJTIwZWwlMjBraGFsaWxpfGVufDB8fHx8MTczMzUxNDQ1NXww&ixlib=rb-4.0.3&q=80&w=1080',
                isHighlighted: false, // Default (not highlighted)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
