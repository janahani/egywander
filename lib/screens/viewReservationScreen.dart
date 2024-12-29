//packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

//widgets
import 'package:egywander/widgets/systembars.dart';
import 'package:egywander/widgets/customBtn.dart';

class ViewReservationsScreen extends StatefulWidget {
  const ViewReservationsScreen({super.key});

  @override
  _ViewReservationsScreenState createState() => _ViewReservationsScreenState();
}

class _ViewReservationsScreenState extends State<ViewReservationsScreen> {
  // Sample data to display; you can replace this with your actual data source
  final List<Map<String, dynamic>> reservations = List.generate(
    5,
    (index) => {
      'tableNumber': index + 1,
      'reservationTime': DateTime.now()
          .add(Duration(hours: index)), // Adjust time for sample data
      'reservationDate': DateTime.now()
          .add(Duration(days: index)), // Adjust date for sample data
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Table Number: ${reservation['tableNumber']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(reservation['reservationDate'])}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Time: ${DateFormat('HH:mm').format(reservation['reservationTime'])}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        text: "View Details",
                        onPressed: () {
                          // Implement navigation or logic for viewing detailed reservation info
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Details for Table ${reservation['tableNumber']}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
