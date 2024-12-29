//packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert';

//screens
import 'package:egywander/screens/accountScreen.dart';
import 'package:egywander/screens/admindashScreen.dart';
import 'package:egywander/screens/registerScreen.dart';

//widget
import 'package:egywander/widgets/systembars.dart';

//providers
import 'package:provider/provider.dart';
import 'package:egywander/providers/userProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Hash the password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Show a SnackBar message
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Handle login logic
  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    final loginInput = _emailController.text.trim();
    final enteredPasswordHash = hashPassword(_passwordController.text.trim());

    try {
      QuerySnapshot snapshot;
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email',
              isEqualTo: loginInput.toLowerCase()) // Case-insensitive email
          .where('password', isEqualTo: enteredPasswordHash)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _showMessage("Login Successful!", Colors.green);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final userDoc = snapshot.docs.first;
        userProvider.login(
            userDoc.id,
            userDoc['firstname'],
            userDoc['lastname'],
            userDoc['email'],
            userDoc['age'],
            userDoc['gender'],
            userDoc['password'],
            userDoc['usertype'],
            userDoc);
        if (userDoc['usertype'] == 'Admin') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDashboardScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountScreen(),
            ),
          );
        }
      } else {
        _showMessage("Invalid email or password.", Colors.red);
      }
    } catch (e) {
      _showMessage("Error: $e", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationBar(context),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 130),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: const Text(
                    "Welcome back! Glad to see you again.",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 40),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child: ElevatedButton(
                            onPressed: _loginUser,
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
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Don't have an account? ",
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
                                        builder: (context) =>
                                            const RegisterScreen()),
                                  );
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: const Text(
                                  "Register now!",
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
            ],
          ),
        ),
      ),
    );
  }
}
