import 'package:egywander/screens/admindashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'userDetailsScreen.dart';
import '../widgets/systembars.dart';

class UsersManagementScreen extends StatefulWidget {
  @override
  _UsersManagementScreenState createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  TextEditingController _searchController = TextEditingController();

  // Sample data for each category
  List<Map<String, String>> customers = List.generate(
    10,
    (index) =>
        {"name": "Customer $index", "email": "customer$index@example.com"},
  );
  List<Map<String, String>> admins = List.generate(
    5,
    (index) => {"name": "Admin $index", "email": "admin$index@example.com"},
  );
  List<Map<String, String>> restaurantOwners = List.generate(
    7,
    (index) =>
        {"name": "Restaurant Owner $index", "email": "owner$index@example.com"},
  );

  String _searchQuery = "";

  List<Map<String, String>> _filterUsers(
      List<Map<String, String>> users, String query) {
    if (query.isEmpty) return users;
    return users
        .where((user) =>
            user["name"]!.toLowerCase().contains(query.toLowerCase()) ||
            user["email"]!.toLowerCase().contains(query.toLowerCase()))
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
          length: 3,
          child: Column(
            children: [
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
                    hintText: "Search by name or email...",
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
              SizedBox(
                height: 10,
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
                tabs: [
                  Tab(
                    child: Text("Customers"),
                  ),
                  Tab(
                    child: Text("Admins"),
                  ),
                  Tab(
                    child: Text("Restaurant\nOwners"),
                  ),
                ],
              ),

              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    // Customers List
                    _buildUserList(_filterUsers(customers, _searchQuery),
                        "No customers found"),
                    // Admins List
                    _buildUserList(
                        _filterUsers(admins, _searchQuery), "No admins found"),
                    // Restaurant Owners List
                    _buildUserList(_filterUsers(restaurantOwners, _searchQuery),
                        "No restaurant owners found"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(List<Map<String, String>> users, String emptyMessage) {
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
                user["name"]!,
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user["email"]!,
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      // Navigate to UserDetailScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(user: user),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete User'),
                            content: Text(
                                'Are you sure you want to delete ${user["name"]}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text(
                                  'No',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    users.removeAt(index); // Delete the user
                                  });
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
