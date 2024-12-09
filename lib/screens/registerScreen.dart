import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loginScreen.dart';
import '../widgets/systembars.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController restaurantAddressController =
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

  // Restaurant Phone Number Validation
  String? validateRestaurantPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Regex for 5-digit hotline or 11-digit mobile number starting with 0
    if (!RegExp(r"^\d{5}$").hasMatch(value) &&
        !RegExp(r"^0\d{10}$").hasMatch(value)) {
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
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) =>
          validateRequired(value, labelText), // Pass field name here
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

  Future<void> _registerUser() async {
  if (_formKey.currentState!.validate()) {
    // Form is valid, proceed with submission
    final userData = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'email': emailController.text,
      'age': ageController.text,
      'gender': selectedGender,
      'username': usernameController.text,
      'password': passwordController.text,
      'usertype': isOwner ? "Owner" : "Wanderer",
      if (isOwner) ...{
        'restaurantName': restaurantNameController.text,
        'restaurantAddress': restaurantAddressController.text,
        'cuisineType': selectedCuisine,
        'restaurantPhoneNumber': restaurantPhoneController.text,
      }
    };

    print('User Data: $userData');  // Debugging output

    try {
      // Attempt to add the user data to Firestore
      await FirebaseFirestore.instance.collection('users').add(userData);
      
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
        decoration: const BoxDecoration(color: Colors.white),
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
                          child: _buildTextField("Email", emailController,
                              validator: validateEmail),
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child:
                              _buildTextField("Username", usernameController),
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
                              validator: (value) =>
                                  validateConfirmPassword(value, password)),
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
                              "Restaurant Address",
                              restaurantAddressController,
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
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.grey,
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
