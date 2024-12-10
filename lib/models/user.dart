import 'package:uuid/uuid.dart';

// Enums for Gender and UserType
enum Gender { male, female }
enum UserType { admin, owner, wanderer }

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final int age;
  final Gender gender; // Enum for gender
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
      password: map['password'],
      usertype: UserType.values.firstWhere((e) => e.toString().split('.').last == map['usertype']),
    );
  }


  // String representation of the User object
  @override
  String toString() {
    return 'User(id: $id, firstname: $firstname, lastname: $lastname, email: $email, '
           'age: $age, gender: ${gender.toString().split('.').last}, '
           ' usertype: ${usertype.toString().split('.').last})';
  }
}
