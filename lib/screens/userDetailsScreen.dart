import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/systembars.dart';

class UserDetailScreen extends StatefulWidget {
  final Map<String, String> user;

  UserDetailScreen({required this.user});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user["name"]);
    _emailController = TextEditingController(text: widget.user["email"]);
    _ageController = TextEditingController(text: widget.user["age"]);
    _addressController = TextEditingController(text: widget.user["address"]);
    _genderController = TextEditingController(text: widget.user["gender"]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _showUpdateConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update User'),
          content:
              Text('Are you sure you want to update ${widget.user["name"]}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform update logic here

                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User updated successfully!'),
                    backgroundColor: Colors.black,
                  ),
                );
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit User Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: customInputDecoration('Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: customInputDecoration('Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: customInputDecoration('Age'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _genderController,
              decoration: customInputDecoration('Gender'),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _showUpdateConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Update User',
                  style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration customInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: GoogleFonts.lato(
      color: Colors.grey,
      fontSize: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        color: Colors.orange,
        width: 2,
      ),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}
