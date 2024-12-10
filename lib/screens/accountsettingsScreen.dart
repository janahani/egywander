import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../widgets/systembars.dart';
import 'package:egywander/providers/userProvider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Editable fields
  String firstName = '';
  String lastName = '';
  String gender = '';
  String age = '';
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String location = '';
  String cuisineType = '';
  String contactNumber = '';
  bool isAccepted = false;

  final List<String> genders = ["Male", "Female"];
  final List<String> cuisines = ["Egyptian", "Italian", "Chinese", "Other"];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  Future<void> _initializeFields() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Initialize user fields
      setState(() {
        firstName = userProvider.firstName ?? '';
        lastName = userProvider.lastName ?? '';
        gender = userProvider.gender ?? '';
        age = userProvider.age?.toString() ?? '';
        username = userProvider.username ?? '';
        email = userProvider.email ?? '';
      });

      // Fetch restaurant details if user is an owner
      if (userProvider.userType == 'owner') {
        final restaurantDoc = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('userId', isEqualTo: userProvider.id)
            .get();

        if (restaurantDoc.docs.isNotEmpty) {
          final restaurantData = restaurantDoc.docs.first.data();
          setState(() {
            isAccepted = restaurantData['isAccepted'] ?? false;
            if (isAccepted) {
              name = restaurantData['name'] ?? '';
              location = restaurantData['location'] ?? '';
              cuisineType = restaurantData['cuisineType'] ?? '';
              contactNumber = restaurantData['contactNumber'] ?? '';
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error initializing fields: $e");
    }
  }

  /// Hash the password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Prepare the data for update
        final Map<String, dynamic> updateData = {
          'firstname': firstName,
          'lastname': lastName,
          'gender': gender,
          'age': int.tryParse(age) ?? 0,
          'username': username,
          'email': email,
        };

        // If the password is not empty, hash it and include it in the update
        if (password.isNotEmpty) {
          updateData['password'] = hashPassword(password);
        }

        // Update user information in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.id)
            .update(updateData);

        // Update restaurant information if user is an owner and restaurant is accepted
        if (userProvider.userType == 'owner' && isAccepted) {
          final restaurantDoc = await FirebaseFirestore.instance
              .collection('restaurants')
              .where('userId', isEqualTo: userProvider.id)
              .get();

          if (restaurantDoc.docs.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection('restaurants')
                .doc(restaurantDoc.docs.first.id)
                .update({
              'name': name,
              'location': location,
              'cuisineType': cuisineType,
              'restaurantPhoneNumber': contactNumber,
            });
          }
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully!')),
        );
      } catch (e) {
        debugPrint("Error saving changes: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save changes.')),
        );
      }
    }
  }

  // Validation functions
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value != null && value.isNotEmpty && value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != null && value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r"^\d{5}$").hasMatch(value) &&
        !RegExp(r"^0\d{10}$").hasMatch(value)) {
      return 'Phone number must be either a 5-digit hotline or an 11-digit number starting with 0';
    }
    return null;
  }

  // Build text field with validation
  Widget _buildTextField(String labelText,
      {String initialValue = "",
      bool readOnly = false,
      bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Function(String)? onChanged,
      String? Function(String?)? validator}) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("First Name",
                  initialValue: firstName, onChanged: null, readOnly: true),
              const SizedBox(height: 20),
              _buildTextField("Last Name",
                  initialValue: lastName, onChanged: null, readOnly: true),
              const SizedBox(height: 20),
              _buildTextField("Gender",
                  initialValue: gender, onChanged: null, readOnly: true),
              const SizedBox(height: 20),
              _buildTextField("Age",
                  initialValue: age,
                  onChanged: null,
                  keyboardType: TextInputType.number,
                  readOnly: true),
              const SizedBox(height: 20),
              _buildTextField("Username",
                  initialValue: username,
                  onChanged: (value) => username = value,
                  validator: (value) => validateRequired(value, "Username")),
              const SizedBox(height: 20),
              _buildTextField("Email",
                  initialValue: email,
                  onChanged: (value) => email = value,
                  validator: (value) => validateEmail(value)),
              const SizedBox(height: 20),
              _buildTextField("Password",
                  obscureText: true,
                  onChanged: (value) => password = value,
                  validator: validatePassword),
              const SizedBox(height: 20),
              _buildTextField("Confirm Password",
                  obscureText: true,
                  onChanged: (value) => confirmPassword = value,
                  validator: validateConfirmPassword),
              const SizedBox(height: 20),
              if (userProvider.userType == 'owner' && isAccepted) ...[
                _buildTextField("Restaurant Name",
                    initialValue: name,
                    onChanged: (value) => name = value,
                    validator: (value) =>
                        validateRequired(value, "Restaurant Name")),
                const SizedBox(height: 20),
                _buildTextField("Restaurant Location",
                    initialValue: location,
                    onChanged: (value) => location = value,
                    validator: (value) =>
                        validateRequired(value, "Restaurant Location")),
                const SizedBox(height: 20),
                _buildTextField("Cuisine Type",
                    initialValue: cuisineType,
                    onChanged: (value) => cuisineType = value),
                const SizedBox(height: 20),
                _buildTextField("Restaurant Phone Number",
                    initialValue: contactNumber,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => contactNumber = value,
                    validator: validatePhoneNumber),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 242, 227, 194)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
