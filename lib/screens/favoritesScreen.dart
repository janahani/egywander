import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egywander/providers/userProvider.dart';
import 'package:egywander/providers/favoriteProvider.dart';
import '../models/homepageActivities.dart';
import 'package:egywander/widgets/systembars.dart';
import 'package:egywander/screens/loginScreen.dart';
import 'package:egywander/providers/homepageactivityprovider.dart';
import 'package:egywander/widgets/favoritesCard.dart';
import 'package:egywander/models/favoriteActivity.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);

    if (!userProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You should log in/register")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return Scaffold();
    }

    final userId = userProvider.id!;
    final activitiesProvider =
        Provider.of<Homepageactivityprovider>(context, listen: false);
        favoritesProvider.fetchFavorites(userProvider.id.toString());
        print(favoritesProvider.favorites);
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          return FutureBuilder<List<HomePageActivity>>(
            future: _fetchFavoriteActivities(
              favoritesProvider.favorites,
              activitiesProvider,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading favorite activities'));
              }

              final favoriteActivities = snapshot.data ?? [];

              if (favoriteActivities.isEmpty) {
                return Center(child: Text('No favorite activities found'));
              }

              return ListView.builder(
                // padding: EdgeInsets.all(), // Add padding to avoid overflow
                itemCount: favoriteActivities.length,
                itemBuilder: (context, index) {
                  final activity = favoriteActivities[index];
                  return FavoritesCard(
                    name: activity.name,
                    location: activity.location,
                    rating: activity.rating!.toDouble(),
                    imageUrl: activity.imageUrl,
                    Remove: () {
                      favoritesProvider.toggleFavorite(userId, activity.id);
                    },
                  );
                },
              );
            },
          );
        },
      )
    );
  }

  Future<List<HomePageActivity>> _fetchFavoriteActivities(
    List<FavoriteActivity> favorites,
    Homepageactivityprovider activitiesProvider,
  ) async {
    // Fetch all activities
    final activities = await Future.wait(
      favorites.map((favorite) async {
        //return await activitiesProvider.fetchActivityById(favorite.placeId);
      }),
    );

    // Filter out null values after resolving futures
    return activities
        .where((activity) => activity != null)
        .cast<HomePageActivity>()
        .toList();
  }
}
