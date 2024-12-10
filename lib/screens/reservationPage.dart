import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../widgets/systembars.dart';
import 'editplanScreen.dart'; // Import if you need to use it in this screen
import '../widgets/customBtn.dart';
class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  int numberOfPeople = 1;
  bool isIndoorSeating = true;
  String? selectedTable;

  final List<String> timeSlots = [
    '12:00 PM - 1:00 PM',
    '1:00 PM - 2:00 PM',
    '6:00 PM - 7:00 PM',
    '7:00 PM - 8:00 PM',
    '8:00 PM - 9:00 PM',
  ];

  final List<String> tables = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            const Text("Select Date:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "Tap to select a date",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Slot Dropdown
            const Text("Select Time Slot:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              value: selectedTimeSlot,
              items: timeSlots.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTimeSlot = value;
                });
              },
              hint: const Text("Select a time slot"),
            ),
            const SizedBox(height: 20),

            // Seating Preference
            const Text("Seating Preference:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Indoor"),
                    value: true,
                    groupValue: isIndoorSeating,
                    onChanged: (value) {
                      setState(() {
                        isIndoorSeating = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Outdoor"),
                    value: false,
                    groupValue: isIndoorSeating,
                    onChanged: (value) {
                      setState(() {
                        isIndoorSeating = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Table Selection
            const Text("Select Table:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              value: selectedTable,
              items: tables.map((table) {
                return DropdownMenuItem(
                  value: table,
                  child: Text(table),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTable = value;
                });
              },
              hint: const Text("Select a table"),
            ),
            const SizedBox(height: 30),

            Center(
              child: Container(
                width: 200,
                child: CustomButton(
                  text: "Confirm Reservation",
                  onPressed: () {
                    if (selectedDate != null &&
                        selectedTimeSlot != null &&
                        selectedTable != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Reservation confirmed for $numberOfPeople people on "
                            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} "
                            "at $selectedTimeSlot, ${isIndoorSeating ? "Indoor" : "Outdoor"}, "
                            "Table: $selectedTable.",
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please complete all fields.")),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
