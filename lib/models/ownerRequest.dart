import 'package:uuid/uuid.dart';

enum Gender { male, female }
enum UserType { admin, owner, wanderer }

class OwnerRequest {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final int age;
  final Gender gender; // Enum for gender
  final String username;
  final String password;
  bool isAccepted; // Initially set to false

  OwnerRequest({
    String? id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.age,
    required this.gender,
    required this.username,
    required this.password,
    this.isAccepted = false, // Default value
  }): id = id ?? const Uuid().v4();

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'age': age,
      'gender': gender.name, // Convert enum to string
      'username': username,
      'password': password,
      'isAccepted': isAccepted,
    };
  }

  // Create an object from a map
  factory OwnerRequest.fromMap(Map<String, dynamic> map) {
    return OwnerRequest(
      id: map['id'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
      gender: Gender.values.firstWhere((e) => e.name == map['gender']),
      username: map['username'] as String,
      password: map['password'] as String,
      isAccepted: map['isAccepted'] as bool? ?? false, // Default to false
    );
  }

  // toString method for debugging and easy representation
  @override
  String toString() {
    return 'OwnerRequest('
        'id: $id, '
        'firstname: $firstname, '
        'lastname: $lastname, '
        'email: $email, '
        'age: $age, '
        'gender: ${gender.name}, '
        'username: $username, '
        'password: $password, '
        'isAccepted: $isAccepted)';
  }
}
