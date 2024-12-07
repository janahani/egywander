
enum Gender { male, female }
enum UserType { admin, owner, wanderer }

class User {
  String firstname;
  String lastname;
  String email;
  int age;
  Gender gender; // Enum for gender
  String username;
  String password;
  UserType usertype; // Enum for usertype

  // Constructor
  User({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.age,
    required this.gender,
    required this.username,
    required this.password,
    required this.usertype,
  });

  // Convert User object to Map (for saving in Firebase, etc.)
  Map<String, dynamic> toMap() {
    return {
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
