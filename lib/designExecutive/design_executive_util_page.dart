import 'package:app_001/designExecutive/display_fields_page.dart';
import 'package:app_001/designExecutive/display_forms_page.dart';
import 'package:app_001/designExecutive/forms_name_details_page.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';

class DesignExecutiveUtilPage extends StatefulWidget {
  @override
  _DesignExecutiveUtilPageState createState() =>
      _DesignExecutiveUtilPageState();
}

class _DesignExecutiveUtilPageState extends State<DesignExecutiveUtilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Design Executive Page'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayFormsPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.folder, size: 30),
                      label: Text('Display Forms'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayFieldsPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.format_list_bulleted, size: 30),
                      label: Text('Display Fields'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormsNameDetailsPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.create, size: 30),
                      label: Text('Create Form'),
                    ),
                    SizedBox(height: 20),
                  ],
                )
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
