import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../widgets/systembars.dart'; // Assuming you have a custom appBar and bottomNavBar

class EditPlanScreen extends StatefulWidget {
  final String title;
  final String date;
  final String startTime;
  final String endTime;

  EditPlanScreen({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  @override
  _EditPlanScreenState createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.date);
    _startTimeController = TextEditingController(text: widget.startTime);
    _endTimeController = TextEditingController(text: widget.endTime);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  // Method to open the date picker and update the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').parse(widget.date),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Method to open the time picker for start and end times
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(controller.text.split(':')[0]),
        minute: int.parse(controller.text.split(':')[1]),
      ),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.format(context); // Set the time to the controller
      });
    }
  }

  // Method to save the changes and pass back the updated plan
  void _saveChanges() {
    // Create the updated plan object
    final updatedPlan = {
      "title": widget.title,  // Title remains unchanged
      "date": _dateController.text,
      "startTime": _startTimeController.text,
      "endTime": _endTimeController.text,
    };

    Navigator.pop(context, updatedPlan); // Pop back to ScheduleScreen with updated data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context), // Your custom AppBar
      bottomNavigationBar: bottomNavigationBar(context), // Your custom BottomNavBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the plan title as a header
            Text(
              widget.title, // Use the title passed from ScheduleScreen
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Date Picker TextField
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Date (dd/MM/yyyy)",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),

            // Start Time Picker TextField
            TextField(
              controller: _startTimeController,
              decoration: InputDecoration(
                labelText: "Start Time",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, _startTimeController),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),

            // End Time Picker TextField
            TextField(
              controller: _endTimeController,
              decoration: InputDecoration(
                labelText: "End Time",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, _endTimeController),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 40), // Added some space before the button

            // Save Changes Button (centered with white text and larger font)
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 18, color: Colors.white), // Larger font and white color
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), 
                  backgroundColor: Colors.orange, // Background color for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
