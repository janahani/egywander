import 'package:flutter/material.dart';
import 'package:egywander/screens/accountsettingsScreen.dart';
import 'package:egywander/widgets/systembars.dart';
import '/widgets/accountmenubtns.dart';
import 'aboutusScreen.dart';


class UsersManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              labelColor: Colors.orange,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(text: "Customers"),
                Tab(text: "Admins"),
                Tab(text: "Restaurant Owners"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Customers List
                  ListView.builder(
                    itemCount: 10, // Replace with actual data length
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Customer $index"),
                        subtitle: Text("customer@example.com"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Navigate to edit customer page
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Delete the customer
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Admins List
                  ListView.builder(
                    itemCount: 5, // Replace with actual data length
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Admin $index"),
                        subtitle: Text("admin@example.com"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Navigate to edit admin page
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Delete the admin
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Restaurant Owners List
                  ListView.builder(
                    itemCount: 7, // Replace with actual data length
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Restaurant Owner $index"),
                        subtitle: Text("owner@example.com"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Navigate to edit restaurant owner page
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Delete the restaurant owner
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
