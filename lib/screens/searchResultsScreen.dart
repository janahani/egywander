import 'package:egywander/models/homepageActivities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/searchProvider.dart';
import '../widgets/systembars.dart';
import '../screens/activityScreen.dart';
import 'package:egywander/providers/homepageactivityprovider.dart';

class SearchPage extends StatelessWidget {
  // final String query;

  SearchPage({super.key});
// , required this.query
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for places...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                searchProvider.debounceSearch(value);
              },
            ),
          ),
          if (searchProvider.isLoading)
            Center(child: CircularProgressIndicator()),
          if (!searchProvider.isLoading && searchProvider.searchResults.isEmpty)
            Center(child: Text('No results found.')),
          if (!searchProvider.isLoading &&
              searchProvider.searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchProvider.searchResults.length,
                itemBuilder: (context, index) {
                  final activity = searchProvider.searchResults[index];
                  return ListTile(
                    title: Text(activity.name ?? 'Unnamed Place'),
                    subtitle: Text(activity.location ?? 'No address available'),
                    leading: activity.imageUrl != null
                        ? Image.network(activity.imageUrl!)
                        : Icon(Icons.place),
                    onTap: () async {
                      // Get the activity provider from the Provider
                      final activityProvider =
                          Provider.of<Homepageactivityprovider>(context,
                              listen: false);

                      // Fetch the activity details
                       HomePageActivity? homePageActivity =
                          await activityProvider.fetchActivityById(activity.id);
                          
                      if (homePageActivity != null) {
                        homePageActivity.category = ' ';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityScreen(
                              homePageActivity: homePageActivity,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to fetch activity details.'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
