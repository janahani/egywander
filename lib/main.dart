import 'package:flutter/material.dart';
import 'screens/welcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:provider/provider.dart';
import 'providers/userProvider.dart';
import 'screens/UserManagementScreen.dart';
import 'screens/admindashScreen.dart';


Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with provided options
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB-dtf3e62C_qwVC9h0hhd6Vam0vigJVDk", // From "api_key"
      authDomain:
          "egywanders.firebaseapp.com", // Usually "project_id.firebaseapp.com"
      databaseURL:
          "https://egywanders-default-rtdb.firebaseio.com", // Constructed URL
      projectId: "egywanders", // From "project_id"
      storageBucket: "egywanders.firebasestorage.app", // From "storage_bucket"
      messagingSenderId: "94969573446", // From "project_number"
      appId:
          "1:94969573446:android:61bb2362cc3ada8e3b9a47", // From "mobilesdk_app_id"
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UsersManagementScreen(),
    );
  }
}
