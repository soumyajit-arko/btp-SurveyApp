import 'package:flutter/material.dart';
import 'login_page.dart';
import 'create_users_page.dart';
import 'display_users_page.dart';

class AdminPageUtil extends StatefulWidget {
  @override
  _AdminPageUtilState createState() => _AdminPageUtilState();
}

class _AdminPageUtilState extends State<AdminPageUtil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateUsersPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, size: 30), // Add an icon
                  label: Text('Create New Users'),
                ),
                SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayUsersPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.list, size: 30), // Add an icon
                  label: Text('Display Users'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10, // Adjust top position as needed
            right: 10, // Adjust right position as needed
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout, size: 30), // Add a logout icon
              label: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
