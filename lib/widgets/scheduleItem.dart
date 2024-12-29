//packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//provider
import 'package:egywander/providers/scheduleProvider.dart';

//screen
import 'package:egywander/screens/scheduleScreen.dart';

class ScheduleItem extends StatelessWidget {
  final List<DocumentSnapshot> schedules;
  final String tabName;
  final bool allowEditDelete;

  const ScheduleItem(
      {super.key,
      required this.schedules,
      required this.tabName,
      required this.allowEditDelete});

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

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              onTap: () {},
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
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey[600],
                ),
              ),
              trailing: allowEditDelete
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            editSchedule(context, schedules[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteSchedule(schedules[index]);
                          },
                        ),
                      ],
                    )
                  : null,
            ),
          )
        ]);
      },
    );
  }
}
