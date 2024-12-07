import 'package:flutter/material.dart';
import 'screens/welcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with provided options
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyCBFe108R8zD3K_h1fm2t4e_FErWkJR2yA", // Your Firebase API Key
      authDomain:
          "lab7-b626d.firebaseapp.com", // Typically "project-id.firebaseapp.com"
      databaseURL:
          "https://lab7-b626d-default-rtdb.firebaseio.com", // Your Firebase Realtime Database URL
      projectId: "lab7-b626d", // Project ID
      storageBucket: "lab7-b626d.appspot.com", // Firebase Storage Bucket
      messagingSenderId: "861898509176", // Your Messaging Sender ID
      appId: "1:861898509176:android:bf1b15f27d94e8d5ea568d", // Your App ID
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
