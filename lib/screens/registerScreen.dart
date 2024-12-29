//packages
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

//screen
import 'package:egywander/screens/loginScreen.dart';

//widget
import 'package:egywander/widgets/systembars.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isOwner = false;
  String? selectedGender;
  String? selectedCuisine;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController restaurantLocationController =
      TextEditingController();
  final TextEditingController restaurantPhoneController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> genders = ["Male", "Female"];
  final List<String> cuisines = ["Egyptian", "Italian", "Chinese", "Other"];

  // Email Validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<bool> isEmailRegistered(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> checkEmailExists(String email) async {
    bool emailExists = await isEmailRegistered(email);
    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This email is already registered')),
      );
    }
  }

  // Name Validation (only letters)
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
      return 'Name must contain only letters';
    }
    return null;
  }

  // Age Validation (2 digits only)
  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    if (!RegExp(r"^\d{1,2}$").hasMatch(value)) {
      return 'Age must be a valid number with at most 2 digits';
    }
    return null;
  }

  // Password Validation (at least 8 characters)
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  // Confirm Password Validation (must match Password)
  String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Restaurant location text
  String? validateRestaurantLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    // Ensures a valid google maps link
    if (!RegExp(r"^(https?:\/\/)?(www\.)?(google\.com\/maps|maps\.app\.goo\.gl)\/[^\s]+$").hasMatch(value)) {
      return 'Enter a valid google maps location link';
    }
    return null;
  }

  // Restaurant Phone Number Validation
  String? validateRestaurantPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Regex for 5-digit hotline strting with 19 or 11-digit mobile number starting with 010, 011, 012, or 015
    if (!RegExp(r"^19\d{3}$").hasMatch(value) &&
        !RegExp(r"^(010|011|012|015)\d{8}$").hasMatch(value)) {
      return 'Phone number must be either a 5-digit hotline or an 11-digit number starting with 0';
    }
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator,
      void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted, // Callback for Firestore validation
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

  String? password;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    final hashed = sha256.convert(bytes); // Generate SHA-256 hash
    return hashed.toString(); // Return the hash as a string
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Perform asynchronous email validation
      bool emailExists = await isEmailRegistered(emailController.text);
      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This email is already registered')),
        );

        return;
      }

      final hashedPassword = _hashPassword(passwordController.text);

      final userData = {
        'firstname': firstNameController.text.trim(),
        'lastname': lastNameController.text.trim(),
        'email': emailController.text.trim().toLowerCase(),
        'age': int.parse(ageController.text.trim()),
        'gender': selectedGender,
        'password': hashedPassword,
        'usertype': isOwner ? "Owner" : "Wanderer",
      };

      print('User Data: $userData');

      try {
        // Attempt to add the user data to Firestore
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('users').add(userData);

        // Retrieve the auto-generated document ID
        String userId = docRef.id;
        if (isOwner) {
          final restaurantData = {
            'ownerId': userId,
            'restaurantName': restaurantNameController.text.trim(),
            'restaurantLocation': restaurantLocationController.text.trim(),
            'cuisineType': selectedCuisine,
            'restaurantPhoneNumber': restaurantPhoneController.text.trim(),
            'isAccepted': false,
          };
          await FirebaseFirestore.instance
              .collection('restaurants')
              .add(restaurantData);
        }

        // Navigate to Login screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        // Handle the error
        print('Error: $e'); // Debugging error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // User Type Selection
                        FadeInUp(
                          duration: const Duration(milliseconds: 1100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.person,
                                      color: !isOwner
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isOwner = false;
                                      });
                                    },
                                  ),
                                  Text(
                                    "Wanderer",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: !isOwner
                                          ? Colors.orange
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              // Owner IconButton with label
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.storefront,
                                      color:
                                          isOwner ? Colors.orange : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isOwner = true;
                                      });
                                    },
                                  ),
                                  Text(
                                    "Owner",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isOwner ? Colors.orange : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: _buildTextField(
                              "First Name", firstNameController,
                              validator: validateName),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: _buildTextField(
                              "Last Name", lastNameController,
                              validator: validateName),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: _buildTextField(
                            "Email",
                            emailController,
                            validator: validateEmail,
                            onFieldSubmitted: (value) async {
                              await checkEmailExists(value);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: _buildTextField("Age", ageController,
                              validator: validateAge,
                              keyboardType: TextInputType.number),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: DropdownButtonFormField<String>(
                            value: selectedGender,
                            items: genders
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Gender",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your gender';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: _buildTextField("Password", passwordController,
                              obscureText: true, validator: validatePassword),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: _buildTextField(
                              "Confirm Password", confirmPasswordController,
                              obscureText: true,
                              validator: (value) => validateConfirmPassword(
                                  value, passwordController.text)),
                        ),
                        const SizedBox(height: 20),
                        // Additional Fields for Owner
                        if (isOwner) ...[
                          FadeInUp(
                            duration: const Duration(milliseconds: 2000),
                            child: _buildTextField(
                              "Restaurant Name",
                              restaurantNameController,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 2100),
                            child: _buildTextField(
                              "Restaurant Location",
                              restaurantLocationController,
                              validator: validateRestaurantLocation
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 2200),
                            child: DropdownButtonFormField<String>(
                              value: selectedCuisine,
                              items: cuisines
                                  .map((cuisine) => DropdownMenuItem(
                                        value: cuisine,
                                        child: Text(cuisine),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCuisine = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Cuisine Type",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a cuisine type';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 2300),
                            child: _buildTextField("Restaurant Phone Number",
                                restaurantPhoneController,
                                validator: validateRestaurantPhoneNumber),
                          ),
                        ],

                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 2400),
                          child: ElevatedButton(
                            onPressed: _registerUser,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 242, 227, 194)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login Navigation
                        FadeInUp(
                          duration: const Duration(milliseconds: 2500),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white // White text in dark mode
                                      : Colors.grey, 
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
