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
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int numberOfPeople = 1;
  bool isIndoorSeating = true;
  String? selectedTable;

  final List<String> tables = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5',
  ];

  // temp dummy restaurant working hours
  final TimeOfDay openingTime = TimeOfDay(hour: 10, minute: 0); // 10:00 AM
  final TimeOfDay closingTime = TimeOfDay(hour: 22, minute: 0); // 10:00 PM

  Future<void> _pickTime(
      {required BuildContext context,
      required String title,
      required TimeOfDay startLimit,
      required TimeOfDay endLimit,
      required Function(TimeOfDay) onTimePicked}) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: startLimit,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null &&
        (pickedTime.hour > startLimit.hour ||
            (pickedTime.hour == startLimit.hour &&
                pickedTime.minute >= startLimit.minute)) &&
        (pickedTime.hour <= endLimit.hour ||
            (pickedTime.hour == endLimit.hour &&
                pickedTime.minute <= endLimit.minute))) {
      onTimePicked(pickedTime);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reservation time must not exceed 2 hours."),
        ),
      );
    }
  }

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

            // Start Time Picker
            const Text("Select Start Time:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickTime(
                context: context,
                title: "Select Start Time",
                startLimit: openingTime,
                endLimit: closingTime,
                onTimePicked: (picked) => setState(() => startTime = picked),
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  startTime != null
                      ? startTime!.format(context)
                      : "Tap to select start time",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // End Time Picker
            const Text("Select End Time:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickTime(
                context: context,
                title: "Select End Time",
                startLimit: startTime ?? openingTime,
                endLimit: TimeOfDay(
                  hour: (startTime?.hour ?? openingTime.hour) + 2,
                  minute: startTime?.minute ?? openingTime.minute,
                ),
                onTimePicked: (picked) => setState(() => endTime = picked),
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  endTime != null
                      ? endTime!.format(context)
                      : "Tap to select end time",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
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
                        startTime != null &&
                        endTime != null &&
                        selectedTable != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Reservation confirmed for $numberOfPeople people on "
                            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} "
                            "from ${startTime!.format(context)} to ${endTime!.format(context)}, "
                            "${isIndoorSeating ? "Indoor" : "Outdoor"}, "
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
