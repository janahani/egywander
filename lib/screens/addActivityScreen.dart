import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; 
import '/models/schedule.dart'; 
import '/providers/userProvider.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class AddActivityScreen extends StatefulWidget {
  final String activityTitle;
  final String activityId;

  const AddActivityScreen({required this.activityTitle, required this.activityId});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activityTitle);
    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

   Future<void> _addActivityToSchedule() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.id!;

         try {
      // Parsing the date with the format dd/MM/yyyy
      final parsedDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);

      // Parsing the start and end times with the format HH:mm (24-hour format)
      final parsedStartTime = DateFormat('HH:mm').parse(_startTimeController.text);
      final parsedEndTime = DateFormat('HH:mm').parse(_endTimeController.text);

      // Creating the new schedule object
      final newSchedule = Schedule(
        userId: userId,
        placeId: widget.activityId,
        date: parsedDate,
        startingTime: DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parsedStartTime.hour, parsedStartTime.minute),
        endingTime: DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parsedEndTime.hour, parsedEndTime.minute),
      );

      // Add the new schedule to Firestore
      await FirebaseFirestore.instance
          .collection('schedule')
          .add(newSchedule.toMap());

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activity added to schedule successfully!')),
      );

      // Close the dialog after adding
      Navigator.pop(context); 
    } catch (e) {
      // Show an error message if something fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add activity: $e')),
      );
    }
  }
}

  InputDecoration _buildInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Activity to Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: _buildInputDecoration("Activity Title"),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: _buildInputDecoration(
                    "Date (dd/MM/yyyy)",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a date";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _startTimeController,
                  decoration: _buildInputDecoration(
                    "Start Time",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, _startTimeController),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a start time";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _endTimeController,
                  decoration: _buildInputDecoration(
                    "End Time",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, _endTimeController),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select an end time";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _addActivityToSchedule,
                  child: Text(
                    "Add Activity",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
