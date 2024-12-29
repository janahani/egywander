//packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

//screens
import 'screens/homepageScreen.dart';

//providers
import 'providers/userProvider.dart';
import 'providers/homepageactivityprovider.dart';
import 'providers/favoriteProvider.dart';
import 'providers/searchProvider.dart';
import 'providers/restaurantProvider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => Homepageactivityprovider()),
        ChangeNotifierProvider(create: (context) => RestaurantProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
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
      home: HomeScreen(),
    );
  }
}
