//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//widget
import 'package:egywander/widgets/systembars.dart';

//model
import 'package:egywander/models/homepageActivities.dart';

//providers
import 'package:egywander/providers/homepageactivityprovider.dart';
import 'package:egywander/providers/searchProvider.dart';

//screen
import 'package:egywander/screens/activityScreen.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
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
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Query cannot be empty.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  searchProvider.debounceSearch(''); 
                } else if (value.trim().length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Query must be at least 3 characters.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  searchProvider.debounceSearch(value); 
                }
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
                      final activityProvider =
                          Provider.of<Homepageactivityprovider>(context,
                              listen: false);

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
