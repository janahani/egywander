import 'package:uuid/uuid.dart';

// Enums for Gender and UserType
enum Gender { male, female }
enum UserType { admin, owner, wanderer }

class User {
  final String id; // Unique identifier for the user
  final String firstname;
  final String lastname;
  final String email;
  final int age;
  final Gender gender; // Enum for gender
  final String username;
  final String password;
  final UserType usertype; // Enum for user type

  // Constructor with auto-generated UUID
  User({
    String? id, // Allow optional UUID to be passed
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.age,
    required this.gender,
    required this.username,
    required this.password,
    required this.usertype,
  }) : id = id ?? const Uuid().v4(); // Auto-generate UUID if not provided

  // Convert User object to Map (for saving in Firebase, etc.)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'age': age,
      'gender': gender.toString().split('.').last, // Convert enum to string
      'username': username,
      'password': password,
      'usertype': usertype.toString().split('.').last, // Convert enum to string
    };
  }

  // Convert Map to User object (when fetching from Firebase, etc.)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      age: map['age'],
      gender: Gender.values.firstWhere((e) => e.toString().split('.').last == map['gender']),
      username: map['username'],
      password: map['password'],
      usertype: UserType.values.firstWhere((e) => e.toString().split('.').last == map['usertype']),
    );
  }
}
