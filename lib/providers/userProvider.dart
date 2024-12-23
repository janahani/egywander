import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  int? age;
  String? gender;
  String? password;
  String? userType;

  // Getter for isLoggedIn - checks if email is set
  bool get isLoggedIn => email != null;

  String? get userID => id;

   // Setter for userID
  void setID(String id) {
    id = id;
    notifyListeners();  // Notify listeners when user ID is set
  }

  // Setter for isLoggedIn (to manually set login status)
  set isLoggedIn(bool status) {
    if (status) {
      email = 'yassminezzat@gmail.com';  
    } else {
      email = null;
      password = null;
      notifyListeners();  
    }
    notifyListeners();  
  }

  // Function to log in the user with all user details
  void login(String id, String firstName, String lastName, String email, int age, String gender, 
      String password, String userType, userDoc) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.age = age;
    this.gender = gender;
    this.password = password;
    this.userType = userType;
    notifyListeners();
  }

  // Update user details (e.g., email, password)
  void update(String email, String password, userDoc) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  // Function to log out the user (clears all user data)
  void logout() {
    id = null;
    firstName = null;
    lastName = null;
    email = null;
    age = null;
    gender = null;
    password = null;
    userType = null;
    notifyListeners();
  }
}
