import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
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

  final _formKey = GlobalKey<FormState>();

  final List<String> genders = ["Male", "Female"];
  final List<String> cuisines = ["Egyptian", "Italian", "Chinese", "Other"];

  Widget _buildTextField(String labelText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        }
        return null;
      },
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

  // form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {}
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
                          child: _buildTextField("First Name"),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: _buildTextField("Last Name"),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: _buildTextField("Email"),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: _buildTextField("Age"),
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
                          child: _buildTextField("Username"),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: _buildTextField("Password", obscureText: true),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: _buildTextField("Confirm Password",
                              obscureText: true),
                        ),
                        const SizedBox(height: 20),
                        // Additional Fields for Owner
                        if (isOwner) ...[
                          FadeInUp(
                            duration: const Duration(milliseconds: 2000),
                            child: _buildTextField("Restaurant Name"),
                          ),
                          const SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 2100),
                            child: _buildTextField("Restaurant Address"),
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
                            child: _buildTextField("Restaurant Phone Number"),
                          ),
                          const SizedBox(height: 20),
                        ],
                        // Register Button
                        FadeInUp(
                          duration: const Duration(milliseconds: 2400),
                          child: ElevatedButton(
                            onPressed: _submitForm,
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
