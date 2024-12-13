import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'userDetailsScreen.dart';
import '../widgets/systembars.dart';

class UsersManagementScreen extends StatefulWidget {
  @override
  _UsersManagementScreenState createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Query Firestore for users based on type
  Future<List<Map<String, dynamic>>> _fetchUsersByType(String userType) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('usertype', isEqualTo: userType)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        } as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      throw e;
    }
  }

  // Filter users locally by search query
  List<Map<String, dynamic>> _filterUsers(
      List<Map<String, dynamic>> users, String query) {
    if (query.isEmpty) return users;
    return users
        .where((user) =>
            user["firstname"].toLowerCase().contains(query.toLowerCase()) ||
            user["email"].toLowerCase().contains(query.toLowerCase()))
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
              SizedBox(height: 20),
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
                    hintText: "Search by name or email...",
                    prefixIcon: Icon(Icons.search, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey, width: 0.8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // TabBar
              TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orange,
                labelStyle: GoogleFonts.lato(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(child: Text("Wanderers")),
                  Tab(child: Text("Admins")),
                  Tab(child: Text("Restaurant\nOwners")),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Customers List
                    FutureBuilder(
                      future: _fetchUsersByType("Wanderer"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error fetching data.'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No customers found.'));
                        } else {
                          List<Map<String, dynamic>> users =
                              snapshot.data as List<Map<String, dynamic>>;
                          return _buildUserList(users);
                        }
                      },
                    ),
                    // Admins List
                    FutureBuilder(
                      future: _fetchUsersByType("Admin"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error fetching data.'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No admins found.'));
                        } else {
                          List<Map<String, dynamic>> users =
                              snapshot.data as List<Map<String, dynamic>>;
                          return _buildUserList(users);
                        }
                      },
                    ),
                    // Restaurant Owners List
                    FutureBuilder(
                      future: _fetchUsersByType("Owner"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error fetching data.'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('No restaurant owners found.'));
                        } else {
                          List<Map<String, dynamic>> users =
                              snapshot.data as List<Map<String, dynamic>>;
                          return _buildUserList(users);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          "No users found.",
          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            title: Text(
              "${user["firstname"]} ${user["lastname"]}",
              style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              user["email"],
              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
            ),
            trailing: IconButton(
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
          ),
        );
      },
    );
  }
}
