import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../widgets/systembars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _restaurantNameController = TextEditingController();
  TextEditingController _restaurantLocationController = TextEditingController();
  TextEditingController _restaurantPhoneController = TextEditingController();

  // Gender and User Type selections
  String _selectedGender = 'Female';
  final List<String> genders = ['Male', 'Female', 'Other'];

  String _selectedUserType = 'Admin';
  final List<String> userTypes = ['Admin', 'Wanderer', 'Owner'];

  // Cuisine selection
  String? _selectedCuisine;
  final List<String> cuisines = ['Egyptian', 'Italian', 'Chinese', 'Other'];

  // Function to hash the password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final hashedPassword = _hashPassword(_passwordController.text.trim());

      final userData = {
        'firstname': _firstnameController.text.trim(),
        'lastname': _lastnameController.text.trim(),
        'email': _emailController.text.trim().toLowerCase(),
        'age': int.parse(_ageController.text.trim()),
        'gender': _selectedGender,
        'password': hashedPassword,
        'usertype': _selectedUserType,
      };
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('users').add(userData);

      // Retrieve the auto-generated document ID
      String userId = docRef.id;

      if (_selectedUserType == 'Owner') {
        final restaurantData = {
          'ownerId': userId,
          'restaurantName': _restaurantNameController.text.trim(),
          'restaurantLocation': _restaurantLocationController.text.trim(),
          'cuisineType': _selectedCuisine,
          'restaurantPhoneNumber': _restaurantPhoneController.text.trim(),
        };
        await FirebaseFirestore.instance
            .collection('restaurants')
            .add(restaurantData);

        print('Restaurant Data: $restaurantData');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedGender = 'Female';
        _selectedUserType = 'Admin';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: adminAppbar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add User',
                style:
                    GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // First Name
              TextFormField(
                controller: _firstnameController,
                decoration: customInputDecoration('First Name'),
              ),
              SizedBox(height: 20),

              // Last Name
              TextFormField(
                controller: _lastnameController,
                decoration: customInputDecoration('Last Name'),
              ),
              SizedBox(height: 20),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: customInputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: customInputDecoration('Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: genders.map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                decoration: customInputDecoration('Gender'),
              ),
              SizedBox(height: 20),

              // User Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                items: userTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value!;
                  });
                },
                decoration: customInputDecoration('User Type'),
              ),
              SizedBox(height: 20),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: customInputDecoration('Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Additional Fields for Owner
              if (_selectedUserType == 'Owner') ...[
                TextFormField(
                  controller: _restaurantNameController,
                  decoration: customInputDecoration('Restaurant Name'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _restaurantLocationController,
                  decoration: customInputDecoration('Restaurant Location'),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCuisine,
                  items: cuisines.map((cuisine) {
                    return DropdownMenuItem(
                        value: cuisine, child: Text(cuisine));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCuisine = value!;
                    });
                  },
                  decoration: customInputDecoration('Cuisine Type'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _restaurantPhoneController,
                  decoration: customInputDecoration('Restaurant Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
              ],

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add User',
                    style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration customInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.orange, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}
