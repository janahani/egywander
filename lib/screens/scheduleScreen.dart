import 'package:egywander/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/providers/userProvider.dart'; // Replace with your UserProvider path
import '/widgets/systembars.dart';
import '/providers/scheduleProvider.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId;
    if (userProvider.isLoggedIn) {
      userId = userProvider.id!;
    }

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You should log in/register")),
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return Scaffold();
    }
    return Scaffold(
      appBar: appBar(context), // Custom AppBar
      bottomNavigationBar:
          bottomNavigationBar(context), // Bottom Navigation Bar
      body: Column(
        children: [
          // Custom Tabs
          Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.orange,
              labelStyle: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold), // Bigger font
              tabs: const [
                Tab(text: "History"),
                Tab(text: "Today"),
                Tab(text: "Upcoming"),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('schedule').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No schedules found."));
                }

                final schedules = snapshot.data!.docs;
                final now = DateTime.now();

                // Organize schedules into categories
                List<DocumentSnapshot> history = [];
                List<DocumentSnapshot> today = [];
                List<DocumentSnapshot> upcoming = [];

                for (var doc in schedules) {
                  final data = doc.data() as Map<String, dynamic>;
                  DateTime scheduleDate =
                      DateFormat('dd/MM/yyyy').parse(data['date']);
                  TimeOfDay endTime = _parseTimeOfDay(data['endingTime']);

                  if (scheduleDate.isAfter(now)) {
                    upcoming.add(doc);
                  } else if (scheduleDate.isAtSameMomentAs(
                      DateTime(now.year, now.month, now.day))) {
                    if (endTime.hour > now.hour ||
                        (endTime.hour == now.hour &&
                            endTime.minute > now.minute)) {
                      today.add(doc);
                    } else {
                      history.add(doc);
                    }
                  } else {
                    history.add(doc);
                  }
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    ScheduleTab(schedules: history, tabName: "History"),
                    ScheduleTab(schedules: today, tabName: "Today"),
                    ScheduleTab(schedules: upcoming, tabName: "Upcoming"),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

class ScheduleTab extends StatelessWidget {
  final List<DocumentSnapshot> schedules;
  final String tabName;

  ScheduleTab({required this.schedules, required this.tabName});

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return Center(child: Text("No schedules in $tabName."));
    }

    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final data = schedules[index].data() as Map<String, dynamic>;
        DateTime date = DateFormat('dd/MM/yyyy').parse(data['date']);
        String formattedDate = DateFormat('EEEE, d MMM y').format(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Display
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                formattedDate,
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Schedule Box
            Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                title: FutureBuilder<String?>(
                  future: fetchPlaceName(data['placeId']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text('Place name not found');
                    } else {
                      return Text(snapshot.data!);
                    }
                  },
                ),
                subtitle: Text(
                  "${data['startingTime']} - ${data['endingTime']}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editSchedule(context, schedules[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteSchedule(schedules[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteSchedule(DocumentSnapshot schedule) {
    FirebaseFirestore.instance.collection('schedule').doc(schedule.id).delete();
  }

  void _editSchedule(BuildContext context, DocumentSnapshot schedule) {
    final data = schedule.data() as Map<String, dynamic>;

    TextEditingController dateController =
        TextEditingController(text: data['date']);
    TextEditingController startTimeController =
        TextEditingController(text: data['startingTime']);
    TextEditingController endTimeController =
        TextEditingController(text: data['endingTime']);

    // Error states
    String? dateError;
    String? startTimeError;
    String? endTimeError;

    // Helper functions
    TimeOfDay _parseTimeOfDay(String time) {
      final parsed = DateFormat('HH:mm').parse(time);
      return TimeOfDay(hour: parsed.hour, minute: parsed.minute);
    }

    String? _validateStartTime() {
      final currentDateTime = DateTime.now();
      final parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
      final parsedStartTime =
          DateFormat('HH:mm').parse(startTimeController.text);
      final selectedDateTimeStart = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedStartTime.hour,
        parsedStartTime.minute,
      );

      if (selectedDateTimeStart.isBefore(currentDateTime)) {
        return 'Start time must be in the future';
      }
      return null;
    }

    String? _validateEndTime() {
      final parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
      final parsedStartTime =
          DateFormat('HH:mm').parse(startTimeController.text);
      final parsedEndTime = DateFormat('HH:mm').parse(endTimeController.text);

      final selectedDateTimeStart = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedStartTime.hour,
        parsedStartTime.minute,
      );

      final selectedDateTimeEnd = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedEndTime.hour,
        parsedEndTime.minute,
      );

      if (selectedDateTimeEnd.isBefore(selectedDateTimeStart)) {
        return 'End time must be after start time';
      }
      return null;
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      }
    }

    Future<void> _selectTime(
        BuildContext context, TextEditingController controller) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (picked != null) {
        final formattedTime = DateFormat('HH:mm').format(
          DateTime(0, 0, 0, picked.hour, picked.minute),
        );
        controller.text = formattedTime;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Edit Schedule"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: "Date (dd/MM/yyyy)",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      errorText: dateError,
                    ),
                  ),
                  TextField(
                    controller: startTimeController,
                    decoration: InputDecoration(
                      labelText: "Start Time (HH:mm)",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () =>
                            _selectTime(context, startTimeController),
                      ),
                      errorText: startTimeError,
                    ),
                  ),
                  TextField(
                    controller: endTimeController,
                    decoration: InputDecoration(
                      labelText: "End Time (HH:mm)",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () =>
                            _selectTime(context, endTimeController),
                      ),
                      errorText: endTimeError,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Reset error messages
                      dateError = null;
                      startTimeError = null;
                      endTimeError = null;

                      // Perform validations
                      if (dateController.text.isEmpty ||
                          startTimeController.text.isEmpty ||
                          endTimeController.text.isEmpty) {
                        dateError = 'All fields must be filled.';
                        startTimeError = 'All fields must be filled.';
                        endTimeError = 'All fields must be filled.';
                        return;
                      }

                      startTimeError = _validateStartTime();
                      endTimeError = _validateEndTime();

                      if (startTimeError != null || endTimeError != null) {
                        return; // Don't save if there are errors
                      }
                    });

                    // Save data if valid
                    if (startTimeError == null && endTimeError == null) {
                      FirebaseFirestore.instance
                          .collection('schedule')
                          .doc(schedule.id)
                          .update({
                        'date': dateController.text,
                        'startingTime': startTimeController.text,
                        'endingTime': endTimeController.text,
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
