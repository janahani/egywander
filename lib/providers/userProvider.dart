import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? firstName;
  String? lastName;
  String? email;
  bool get isLoggedIn => email != null;

  void login(String firstName, String lastName, String email) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    notifyListeners();
  }

  void logout() {
    firstName = null;
    lastName = null;
    email = null;
    notifyListeners();
  }
}
