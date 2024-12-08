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
        appBar: appBar(context),
        bottomNavigationBar: bottomNavigationBar(context),
        body: SafeArea(
          top: true,
          child: ListView(
            children: [
              // Increased padding for ReminderCard
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add more padding
                child: ReminderCard(
                  date: 'Today, 06/12/2024',
                  location: 'Pyramids of Giza',
                  time: '3-5 pm',
                  imageUrl:
                      'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxweXJhbWlkc3xlbnwwfHx8fDE3MzM1MTMxMTJ8MA&ixlib=rb-4.0.3&q=80&w=400',
                  isHighlighted: true, // Highlighted card
                ),
              ),
              SizedBox(height: 10), // Space between cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add more padding
                child: ReminderCard(
                  date: 'Yesterday, 05/12/2024',
                  location: 'Khan El Khalili',
                  time: '5-7 pm',
                  imageUrl:
                      'https://images.unsplash.com/photo-1729956816147-92d4d2ef48ac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxraGFuJTIwZWwlMjBraGFsaWxpfGVufDB8fHx8MTczMzUxNDQ1NXww&ixlib=rb-4.0.3&q=80&w=1080',
                  isHighlighted: false, // Default (not highlighted)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
