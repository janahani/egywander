// import 'package:flutter/material.dart';
// import '/widgets/favoritescard.dart';
// import '../widgets/systembars.dart';
// import 'activityScreen.dart';

// class FavoritesScreen extends StatefulWidget {
//   const FavoritesScreen({Key? key}) : super(key: key);

//   @override
//   State<FavoritesScreen> createState() => _FavoritesScreenState();
// }

// class _FavoritesScreenState extends State<FavoritesScreen> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   List<Map<String, dynamic>> favorites = [
//     {
//       'name': 'Pyramids Tour',
//       'location': 'Giza Plateau',
//       'rating': 4.8,
//       'imageUrl':
//           'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxweXJhbWlkc3xlbnwwfHx8fDE3MzM1MTMxMTJ8MA&ixlib=rb-4.0.3&q=80&w=400',
//     },
//     {
//       'name': 'Khan El Khalili Visit',
//       'location': 'Old Cairo',
//       'rating': 4.6,
//       'imageUrl':
//           'https://images.unsplash.com/photo-1729956816147-92d4d2ef48ac?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxraGFuJTIwZWwlMjBraGFsaWxpfGVufDB8fHx8MTczMzUxNDQ1NXww&ixlib=rb-4.0.3&q=80&w=1080',
//     },
//   ];

//   void removeFromFavorites(int index) {
//     final removedFavorite = favorites[index];
//     setState(() {
//       favorites.removeAt(index);
//     });
//     // Show a Snackbar
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('${removedFavorite['name']} was removed from favorites'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _navigateToActivityScreen(Map<String, dynamic> favorite) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ActivityScreen(
//           id : favorite['id'],
//           imageUrl: favorite['imageUrl']!,
//           title: favorite['name']!,
//           location: favorite['location']!,
//           price: '\$1200',
//           rating: favorite['rating']!,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: Colors.grey[100],
//         appBar: appBar(context),
//         bottomNavigationBar: bottomNavigationBar(context),
//         body: SafeArea(
//           top: true,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: favorites.length,
//             itemBuilder: (context, index) {
//               final favorite = favorites[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: GestureDetector(
//                   onTap: () => _navigateToActivityScreen(favorite),
//                   child: FavoritesCard(
//                     name: favorite['name']!,
//                     location: favorite['location']!,
//                     rating: favorite['rating']!,
//                     imageUrl: favorite['imageUrl']!,
//                     Remove: () => removeFromFavorites(index),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
