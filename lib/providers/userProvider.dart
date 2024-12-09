import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  String? firstName;
  String? lastName;
  String? email;
  String? age;
  String? gender;
  String? username;
  String? password;
  String? userType;

  bool get isLoggedIn => email != null;

  void login(String firstName, String lastName, String email, String age, String gender, String username,
   String password, String userType) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.age = age;
    this.gender = gender;
    this.username = username;
    this.password = password;
    this.userType = userType;
    notifyListeners();
  }

  void logout() {
    firstName = null;
    lastName = null;
    email = null;
    age = null;
    gender = null;
    username = null;
    password = null;
    userType = null;
    notifyListeners();
  }
}
