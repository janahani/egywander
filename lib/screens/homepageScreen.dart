//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import 'package:egywander/providers/homepageactivityprovider.dart';
import 'package:egywander/providers/searchProvider.dart';

//screens
import 'package:egywander/screens/filterScreen.dart';
import 'package:egywander/screens/searchResultsScreen.dart';

//widgets
import 'package:egywander/widgets/categorychip.dart';
import 'package:egywander/widgets/systembars.dart';
import 'package:egywander/widgets/travelcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Entertainment';
  String popularCategory = 'Most Popular';
  final TextEditingController _searchController = TextEditingController();

  void _fetchActivities(BuildContext context, String city) async {
    final provider =
        Provider.of<Homepageactivityprovider>(context, listen: false);

    try {
      await Future.wait([
        provider.fetchPlacesForCity(city),
        provider.fetchPopularPlacesForCity(city),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch activities for $city: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPhone = constraints.maxWidth < 400;
          final isTablet = constraints.maxWidth >= 600;
          final isDesktop = constraints.maxWidth >= 1024;

          final double chipWidth =
              constraints.maxWidth / 4; // four chips per row

          final horizontalPadding = isDesktop
              ? 32.0
              : isTablet
                  ? 24.0
                  : isPhone
                      ? 12.0
                      : 16.0;

          final cityCardWidth = isDesktop
              ? constraints.maxWidth * 0.2
              : isTablet
                  ? constraints.maxWidth * 0.3
                  : (constraints.maxWidth - horizontalPadding * 2 - 10) / 2;

          final cityCardHeight = isPhone ? 80.0 : 100.0;

          final titleFontSize = isDesktop
              ? 32.0
              : isTablet
                  ? 28.0
                  : isPhone
                      ? 20.0
                      : 24.0;

          final subtitleFontSize = isDesktop
              ? 28.0
              : isTablet
                  ? 24.0
                  : isPhone
                      ? 16.0
                      : 20.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: isPhone ? 5 : 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isPhone ? 5 : 10,
                    children: [
                      Text(
                        'Schedule your',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Dark mode: white text
                              : Colors.black54, 
                        ),
                      ),
                      Text(
                        'trip to Egypt!',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isPhone ? 15 : 20),
                  Container(
                    width: double.infinity,
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: isDesktop ? 18.0 : (isTablet ? 16.0 : 14.0),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: isDesktop ? 28.0 : 24.0,
                        ),
                        hintText: 'Search places',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(isDesktop ? 15 : 10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isDesktop ? 20 : (isTablet ? 15 : 8),
                          horizontal: isDesktop ? 24 : (isTablet ? 16 : 12),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: isPhone ? 15 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _fetchActivities(context, 'Cairo'),
                        child: Container(
                          width: cityCardWidth,
                          height: cityCardHeight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(isPhone ? 8 : 10),
                            image: DecorationImage(
                              image: AssetImage('assets/images/pyramids.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.6),
                                  borderRadius:
                                      BorderRadius.circular(isPhone ? 8 : 10),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Cairo',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () =>
                            _fetchActivities(context, 'Luxor and Aswan'),
                        child: Container(
                          width: cityCardWidth,
                          height: cityCardHeight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(isPhone ? 8 : 10),
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/welcomescreen.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.6),
                                  borderRadius:
                                      BorderRadius.circular(isPhone ? 8 : 10),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Luxor & Aswan',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isPhone ? 15 : 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isPhone ? 5 : 10,
                    children: [
                      CategoryChip(
                        label: 'Entertainment',
                        color: const Color.fromARGB(255, 158, 158, 158),
                        isSelected: selectedCategory == 'Entertainment',
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'Entertainment';
                          });
                        },
                      ),
                      CategoryChip(
                        label: 'Food',
                        color: const Color.fromARGB(255, 158, 158, 158),
                        isSelected: selectedCategory == 'Food',
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'Food';
                          });
                        },
                      ),
                      CategoryChip(
                        label: 'Landmarks',
                        color: Colors.grey,
                        isSelected: selectedCategory == 'Landmarks',
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'Landmarks';
                          });
                        },
                      ),
                      CategoryChip(
                        label: 'Sea',
                        color: Colors.grey,
                        isSelected: selectedCategory == 'Sea',
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'Sea';
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: isPhone ? 20 : 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Places',
                        style: TextStyle(
                          fontSize: isPhone ? 16 : (isTablet ? 22 : 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(isPhone ? 8 : 10),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: isPhone ? 8 : 12,
                              vertical: isPhone ? 4 : 8,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: isPhone ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isPhone ? 15 : 20),
                  SizedBox(
                    height: isPhone ? 250 : (isTablet ? 350 : 300),
                    child: Consumer<Homepageactivityprovider>(
                      builder: (context, provider, child) {
                        final filteredActivities = provider.activities
                            .where((activity) =>
                                activity.category == selectedCategory)
                            .toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredActivities.length,
                          itemBuilder: (context, index) {
                            final activity = filteredActivities[index];
                            return TravelCard(homePageActivity: activity);
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Most Popular Places',
                      style: TextStyle(
                        fontSize: isPhone ? 16 : (isTablet ? 22 : 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: isPhone ? 15 : 25),
                  SizedBox(
                    height: isPhone ? 250 : (isTablet ? 350 : 300),
                    child: Consumer<Homepageactivityprovider>(
                      builder: (context, provider, child) {
                        final popularActivities = provider.popularActivities;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popularActivities.length,
                          itemBuilder: (context, index) {
                            final activity = popularActivities[index];
                            return TravelCard(homePageActivity: activity);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
