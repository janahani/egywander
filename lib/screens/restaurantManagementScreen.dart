import 'package:egywander/screens/admindashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/systembars.dart';
import 'requestDetailsScreen.dart';

class RestaurantManagementScreen extends StatefulWidget {
  @override
  _RestaurantManagementScreenState createState() =>
      _RestaurantManagementScreenState();
}

class _RestaurantManagementScreenState
    extends State<RestaurantManagementScreen> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> restaurantRequests = List.generate(
    7,
    (index) => {
      "Restaurant": "Restaurant $index",
      "Owner": "owner example$index",
      "Email": "owner$index@gmail.com"
    },
  );

  String _searchQuery = "";

  List<Map<String, String>> _filterUsers(
      List<Map<String, String>> restaurantRequests, String query) {
    if (query.isEmpty) return restaurantRequests;
    return restaurantRequests
        .where((restaurantRequests) => restaurantRequests["Restaurant"]!
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: adminAppbar(context),
      body: Container(
        child: DefaultTabController(
          length: 0,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Restaurant Requests',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    hoverColor: Colors.orange,
                    hintText: "Search by restaurant name",
                    prefixIcon: Icon(Icons.search, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Colors.orange), // Default border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.8), // Border color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1.0), // Border color when focused
                    ),
                  ),
                ),
              ),

              // TabBar
              TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orange,
                indicatorPadding: EdgeInsets.symmetric(
                  horizontal: 1.0,
                ),
                labelStyle: GoogleFonts.lato(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                tabs: [],
              ),

              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    // Restaurant Owners List
                    buildRestaurantList(
                        _filterUsers(restaurantRequests, _searchQuery),
                        "No restaurant requests found"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRestaurantList(
      List<Map<String, String>> users, String emptyMessage) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              title: Text(
                user["Restaurant"]!,
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user["Owner"]!,
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailsScreen(
                        restaurant: user,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
