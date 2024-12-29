//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//widget
import 'package:egywander/widgets/systembars.dart';

//providers
import 'package:egywander/providers/restaurantProvider.dart';
import 'package:egywander/providers/userProvider.dart';

//model
import 'package:egywander/models/restaurant.dart';

class RequestStatusOwner extends StatelessWidget {
  const RequestStatusOwner({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final ownerId = userProvider.id;

    if (ownerId == null) {
      return _buildErrorScreen(
          context, "Owner ID is not available. Please try again later.");
    }

    // Fetch the restaurantId based on the ownerId
    return FutureBuilder<String?>(
      future: restaurantProvider.fetchRestaurantIdByOwnerId(ownerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen(context);
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorScreen(context, 'Error fetching restaurant ID');
        }

        final restaurantId = snapshot.data!;
        return FutureBuilder<Restaurant?>(
          future: restaurantProvider.fetchRestaurantDetailsById(restaurantId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen(context);
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return _buildErrorScreen(
                  context, 'Error fetching restaurant details');
            }

            final restaurant = snapshot.data!;
            return _buildSuccessScreen(context, restaurant);
          },
        );
      },
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScreen(BuildContext context, String message) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(BuildContext context, Restaurant restaurant) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Request Status: ${restaurant.status}",
              style: TextStyle(
                fontSize: 16,
                color: restaurant.isAccepted ? Colors.green : Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            if (restaurant.isAccepted) ...[
              _buildRestaurantInfo(context, restaurant),
            ] else ...[
              Center(
                child: Text(
                  "Your request is still pending. Please wait for approval.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo(BuildContext context, Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Restaurant Name Card
        Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Restaurant Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(restaurant.name, style: TextStyle(fontSize: 18)),
                  ],
                ),
                Icon(Icons.restaurant, size: 30, color: Colors.green),
              ],
            ),
          ),
        ),

        // Location Card
        Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(restaurant.location, style: TextStyle(fontSize: 18)),
                  ],
                ),
                Icon(Icons.location_on, size: 30, color: Colors.blue),
              ],
            ),
          ),
        ),

        // Contact Number Card
        Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Contact Number",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(restaurant.contactNumber,
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
                Icon(Icons.phone, size: 30, color: Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
