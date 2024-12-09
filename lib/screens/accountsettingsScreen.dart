import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/systembars.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Predefined values
  final String firstName = "John";
  final String lastName = "Doe";
  final String gender = "Male";
  final String age = "25";
  final String username = "johndoe123";

  // Editable values
  String email = "johndoe@example.com";
  String password = "password123";
  String confirmPassword = "password123";
  String restaurantName = "John's Bistro";
  String restaurantAddress = "123 Main St, Springfield";
  String cuisineType = "Italian";
  String restaurantPhoneNumber = "01234567890"; // Example phone number

  final List<String> genders = ["Male", "Female"];
  final List<String> cuisines = ["Egyptian", "Italian", "Chinese", "Other"];

// General required field validation with field name
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Phone number validation
  String? validatePhoneNumber(String? value) {
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
                    const Text(
                      "Account Settings",
                      style: TextStyle(
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
                        // Unchangeable Fields
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: _buildTextField("First Name",
                              initialValue: firstName, readOnly: true),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: _buildTextField("Last Name",
                              initialValue: lastName, readOnly: true),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: _buildTextField("Gender",
                              initialValue: gender, readOnly: true),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: _buildTextField("Age",
                              initialValue: age, readOnly: true),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: _buildTextField("Username",
                              initialValue: username, readOnly: true),
                        ),
                        const SizedBox(height: 20),
                        // Editable Fields
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child: _buildTextField("Email",
                              initialValue: email,
                              onChanged: (value) => email = value,
                              validator: validateEmail),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: _buildTextField("Password",
                              obscureText: true,
                              initialValue: password,
                              onChanged: (value) => password = value,
                              validator: validatePassword),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: _buildTextField("Confirm Password",
                              obscureText: true,
                              initialValue: confirmPassword,
                              onChanged: (value) => confirmPassword = value,
                              validator: validateConfirmPassword),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 2000),
                          child: _buildTextField(
                            "Restaurant Name",
                            initialValue: restaurantName,
                            onChanged: (value) => restaurantName = value,
                            validator: (value) =>
                                validateRequired(value, "Restaurant Name"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 2100),
                          child: _buildTextField(
                            "Restaurant Address",
                            initialValue: restaurantAddress,
                            onChanged: (value) => restaurantAddress = value,
                            validator: (value) =>
                                validateRequired(value, "Restaurant Address"),
                          ),
                        ),

                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 2200),
                          child: DropdownButtonFormField<String>(
                            value: cuisineType,
                            items: cuisines
                                .map((cuisine) => DropdownMenuItem(
                                      value: cuisine,
                                      child: Text(cuisine),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                cuisineType = value!;
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
                            validator: (value) =>
                                validateRequired(value, "Cuisine Type"),
                          ),
                        ),

                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 2300),
                          child: _buildTextField("Restaurant Phone Number",
                              initialValue: restaurantPhoneNumber,
                              onChanged: (value) =>
                                  restaurantPhoneNumber = value,
                              validator: validatePhoneNumber),
                        ),
                        const SizedBox(height: 20),
                        // Save Button
                        FadeInUp(
                          duration: const Duration(milliseconds: 2400),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Save changes logic
                              }
                            },
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
                                  "Save Changes",
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
