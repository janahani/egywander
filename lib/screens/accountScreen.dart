import 'package:flutter/material.dart';
import '../widgets/systembars.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Welcome to EgyWanders"),
        centerTitle: false,
      ),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with CircleAvatar and Hello, Jana Hani text
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, Jana Hani",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 5), // Space between Hello and Egypt
                    Text(
                      "Egypt",
                      style: TextStyle(
                        fontSize: 14, // Smaller font size
                        color: Colors.black, // Black color for Egypt
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20), // Adds spacing between the top section and list items
            Divider(),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Register"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add navigation or functionality here
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Account Settings"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add navigation or functionality here
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About Us"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add navigation or functionality here
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add navigation or functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
