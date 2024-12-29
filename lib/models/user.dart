import 'package:uuid/uuid.dart';

enum Gender { male, female }

enum UserType { admin, owner, wanderer }

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final int age;
  final Gender gender; 
  final String password;
  final UserType usertype; 

  User({
    String? id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.age,
    required this.gender,
    required this.password,
    required this.usertype,
  }) : id = id ?? const Uuid().v4(); 

  // Convert User object to Map for saving in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'age': age,
      'gender': gender.toString().split('.').last, 
      'password': password,
      'usertype': usertype.toString().split('.').last, 
    };
  }

  // Convert Map to User object when fetching from Firestore
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      age: map['age'],
      gender: Gender.values
          .firstWhere((e) => e.toString().split('.').last == map['gender']),
      password: map['password'],
      usertype: UserType.values
          .firstWhere((e) => e.toString().split('.').last == map['usertype']),
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
