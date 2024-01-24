import 'package:app_001/display_survey_responses.dart';

import 'select_subject_survey.dart';
import 'subject_display_page.dart';
import 'subject_register_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SurveyorPageUtil extends StatefulWidget {
  @override
  _SurveyorPageUtilState createState() => _SurveyorPageUtilState();
}

class _SurveyorPageUtilState extends State<SurveyorPageUtil> {
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectRegisterPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.add, size: 30), // Add an icon
                      label: Text('Register New Subject'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectDisplayPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.list, size: 30), // Add an icon
                      label: Text('Display Subjects'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplaySurveyResponses(),
                          ),
                        );
                      },
                      icon: Icon(Icons.list, size: 30), // Add an icon
                      label: Text('Display Responses'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectSubjectSurveyPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.assignment, size: 30), // Add an icon
                      label: Text('Take Survey'),
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
