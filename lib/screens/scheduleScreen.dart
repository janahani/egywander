import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../widgets/systembars.dart';
import 'editplanScreen.dart'; // Import EditPlanScreen for navigation

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Three tabs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Column(
        children: [
          // Custom Tabs
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.orange,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Bigger font
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Today"),
                Tab(text: "History"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                UpcomingTab(),
                TodayTab(),
                HistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Upcoming Tab
class UpcomingTab extends StatefulWidget {
  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {
  List<Map<String, dynamic>> upcomingPlans = [
    {"date": "Friday, 8 Dec 2024", "plans": [{"place": "Meeting", "time": "10:00 - 12:00"}]},
    {"date": "Saturday, 9 Dec 2024", "plans": [{"place": "Workshop", "time": "14:00 - 16:00"}]},
  ];

  void _deletePlan(int parentIndex, int planIndex) {
    setState(() {
      upcomingPlans[parentIndex]["plans"].removeAt(planIndex);
      if (upcomingPlans[parentIndex]["plans"].isEmpty) {
        upcomingPlans.removeAt(parentIndex); // Remove date section if no plans
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: upcomingPlans.map((section) {
          String date = section["date"];
          List<Map<String, String>> plans = List<Map<String, String>>.from(section["plans"]);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16), // Adjusted padding
                child: Text(
                  date,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
              ...plans.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> plan = entry.value;
                return upcomingPlanCard(plan["place"]!, plan["time"]!, () => _deletePlan(upcomingPlans.indexOf(section), index), () {
                  _navigateToEditPlan(
                    context,
                    plan["place"]!,
                    date,
                    plan["time"]!.split(" - ")[0],
                    plan["time"]!.split(" - ")[1],
                  );
                });
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget upcomingPlanCard(String place, String time, VoidCallback onDelete, VoidCallback onEdit) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Place and Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Edit and Delete Icons
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit, // Navigate to EditPlanScreen
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToEditPlan(
    BuildContext context,
    String place,
    String date,
    String startTime,
    String endTime,
  ) async {
    final updatedPlan = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlanScreen(
          title: place,
          date: DateFormat('dd/MM/yyyy').format(DateFormat('EEEE, d MMM yyyy').parse(date)),
          startTime: startTime,
          endTime: endTime,
        ),
      ),
    );

    if (updatedPlan != null) {
      setState(() {
        // Replace old plan with updated data
        int parentIndex = upcomingPlans.indexWhere((section) => section["date"] == date);
        if (parentIndex != -1) {
          int planIndex = upcomingPlans[parentIndex]["plans"].indexWhere((plan) => plan["place"] == place);
          if (planIndex != -1) {
            upcomingPlans[parentIndex]["plans"][planIndex] = {
              "place": updatedPlan["title"],
              "time": "${updatedPlan["startTime"]} - ${updatedPlan["endTime"]}",
            };
          }
        }
      });
    }
  }
}

// Today Tab
class TodayTab extends StatefulWidget {
  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  List<Map<String, String>> plans = [
    {"place": "Fly in", "time": "16:30 - 19:15"},
    {"place": "Dinner at Snack!", "time": "21:00 - 23:00"},
    {"place": "Concert", "time": "00:00 - 04:00"},
  ];

  void _deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date in a format suitable for the EditPlanScreen
    String todayDate = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: plans
            .asMap()
            .entries
            .map((entry) => planCard(entry.value["place"]!, entry.value["time"]!, entry.key, todayDate))
            .toList(),
      ),
    );
  }

  Widget planCard(String place, String time, int index, String date) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Place and Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Edit and Delete Icons
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  _navigateToEditPlan(
                    context,
                    place,
                    date,  // Pass the actual date
                    time.split(" - ")[0],
                    time.split(" - ")[1],
                  );
                }, // Navigate to EditPlanScreen
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletePlan(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToEditPlan(
    BuildContext context,
    String place,
    String date,
    String startTime,
    String endTime,
  ) async {
    final updatedPlan = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlanScreen(
          title: place,
          date: DateFormat('dd/MM/yyyy').format(DateFormat('EEEE, d MMM yyyy').parse(date)),
          startTime: startTime,
          endTime: endTime,
        ),
      ),
    );

    if (updatedPlan != null) {
      setState(() {
        // Replace old plan with updated data
        plans[plans.indexWhere((plan) => plan["place"] == place && plan["time"] == "$startTime - $endTime")] = {
          "place": updatedPlan["title"],
          "time": "${updatedPlan["startTime"]} - ${updatedPlan["endTime"]}",
        };
      });
    }
  }
}

// History Tab (unchanged)
class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          scheduleForDay("Tuesday, 24 Feb 2024", [
            {"place": "Fly in", "time": "16:30 - 19:15"},
            {"place": "Dinner at Snack!", "time": "21:00 - 23:00"},
          ]),
          scheduleForDay("Wednesday, 25 Feb 2024", [
            {"place": "Concert", "time": "00:00 - 04:00"},
          ]),
        ],
      ),
    );
  }

  Widget scheduleForDay(String date, List<Map<String, String>> plans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16),
          child: Text(
            date,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ),
        ...plans.map((plan) => planCard(plan["place"]!, plan["time"]!)).toList(),
      ],
    );
  }

  Widget planCard(String place, String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
