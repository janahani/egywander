import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  int? age;
  String? gender;
  String? username;
  String? password;
  String? userType;

  bool get isLoggedIn => email != null;

  void login(String id,String firstName, String lastName, String email, int age, String gender, String username,
   String password, String userType, userDoc) {
    this.id = id;
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
    id = null;
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
