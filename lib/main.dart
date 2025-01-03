//packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
//screen
import 'package:egywander/screens/homepageScreen.dart';
//providers
import 'package:egywander/providers/favoriteProvider.dart';
import 'package:egywander/providers/homepageactivityprovider.dart';
import 'package:egywander/providers/restaurantProvider.dart';
import 'package:egywander/providers/searchProvider.dart';
import 'package:egywander/providers/userProvider.dart';
import 'package:egywander/providers/themeProvider.dart';

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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(
              create: (context) => Homepageactivityprovider()),
          ChangeNotifierProvider(create: (context) => RestaurantProvider()),
          ChangeNotifierProvider(create: (context) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor:
                Colors.grey[100], // Background for light mode
            primarySwatch: Colors.orange,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor:
                Color(0xFF333333), // Background for dark mode
            primarySwatch: Colors.orange,
          ),
          themeMode: themeProvider.themeMode,
          home: HomeScreen(),
        );
      },
    );
  }
}
