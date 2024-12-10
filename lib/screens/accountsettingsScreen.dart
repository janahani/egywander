import 'package:egywander/screens/accountScreen.dart';
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
  String restaurantName = '';
  String restaurantLocation = '';
  String cuisineType = '';
  String restaurantPhoneNumber = '';
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
      if (userProvider.userType == 'Owner') {
        final restaurantDoc = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('ownerId', isEqualTo: userProvider.id)
            .get();

        print('Restaurant Data: ${restaurantDoc.docs.first.data()}');
        if (restaurantDoc.docs.isNotEmpty) {
          final restaurantData = restaurantDoc.docs.first.data();
          setState(() {
            isAccepted = restaurantData['isAccepted'] ?? false;
            if (isAccepted) {
              restaurantName = restaurantData['restaurantName'] ?? '';
              restaurantLocation = restaurantData['restaurantLocation'] ?? '';
              cuisineType = restaurantData['cuisineType'] ?? '';
              restaurantPhoneNumber =
                  restaurantData['restaurantPhoneNumber'] ?? '';
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

        if (userProvider.userType == 'Owner' && isAccepted) {
          final restaurantDoc = await FirebaseFirestore.instance
              .collection('restaurants')
              .where('ownerId', isEqualTo: userProvider.id)
              .get();

          if (restaurantDoc.docs.isNotEmpty) {
            final docId = restaurantDoc.docs.first.id;
            print('Updating restaurant with ID: $docId');
            try {
              await FirebaseFirestore.instance
                  .collection('restaurants')
                  .doc(docId)
                  .update({
                'restaurantName': restaurantName,
                'restaurantLocation': restaurantLocation,
                'cuisineType': cuisineType,
                'restaurantPhoneNumber': restaurantPhoneNumber,
              });
              print('Update successful!');
            } catch (e) {
              print('Error updating restaurant: $e');
            }
          } else {
            print('No restaurant document found for update.');
          }
        }

        // Fetch the updated user data directly by document ID
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.id)
            .get();

        if (userDoc.exists) {
          // Update the user provider with the new user data
          userProvider.update(
            userDoc['email'],
            userDoc['username'],
            userDoc['password'],
            userDoc.data()!,
          );

          // Navigate to the AccountScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AccountScreen()),
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Changes saved successfully!')),
          );
        } else {
          throw Exception('User document not found.');
        }
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
              if (userProvider.userType == 'Owner' && isAccepted) ...[
                _buildTextField("Restaurant Name",
                    initialValue: restaurantName,
                    onChanged: (value) => restaurantName = value,
                    validator: (value) =>
                        validateRequired(value, "Restaurant Name")),
                const SizedBox(height: 20),
                _buildTextField("Restaurant Location",
                    initialValue: restaurantLocation,
                    onChanged: (value) => restaurantLocation = value,
                    validator: (value) =>
                        validateRequired(value, "Restaurant Location")),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: cuisineType.isNotEmpty
                      ? cuisineType
                      : null, // Current value or null
                  decoration: InputDecoration(
                    labelText: "Cuisine Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: cuisines.map((String cuisine) {
                    return DropdownMenuItem<String>(
                      value: cuisine,
                      child: Text(cuisine),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      cuisineType = newValue ?? ''; // Update the state
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Cuisine Type is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField("Restaurant Phone Number",
                    initialValue: restaurantPhoneNumber,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => restaurantPhoneNumber = value,
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
