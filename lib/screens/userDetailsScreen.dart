import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/systembars.dart';

class UserDetailScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  UserDetailScreen({required this.user});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _firstnameController =
        TextEditingController(text: widget.user["firstname"]);
    _lastnameController = TextEditingController(text: widget.user["lastname"]);
    _emailController = TextEditingController(text: widget.user["email"]);
    _ageController = TextEditingController(text: widget.user["age"].toString());
    _genderController = TextEditingController(text: widget.user["gender"]);
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _updateUserDetails() async {
    try {
      // Update user in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user["id"]) // Use the user's document ID
          .update({
        "firstname": _firstnameController.text,
        "lastname": _lastnameController.text,
        "email": _emailController.text,
        "age": int.parse(_ageController.text), // Ensure age is an integer
        "gender": _genderController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showUpdateConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update User'),
          content:
              Text('Are you sure you want to update ${widget.user["firstname"]}?'),
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
                Navigator.pop(context); // Close the dialog
                _updateUserDetails(); // Call the update function
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
      backgroundColor: Colors.grey[100],
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
              controller: _firstnameController,
              decoration: customInputDecoration('First Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _lastnameController,
              decoration: customInputDecoration('Last Name'),
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
              keyboardType: TextInputType.number,
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
