import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';
import 'take_survey_page.dart';

class SelectSubjectSurveyPage extends StatefulWidget {
  @override
  _SelectSubjectSurveyPageState createState() =>
      _SelectSubjectSurveyPageState();
}

class _SelectSubjectSurveyPageState extends State<SelectSubjectSurveyPage> {
  late Future<List<String>> _formNames;
  late Future<List<String>> _subjectNames;

  String? _selectedName;
  String? _selectedSubject;

  // List<TextEditingController> textControllers = [];
  // int count = 0;
  @override
  void initState() {
    super.initState();
    _loadFormNames();
  }

  void _loadFormNames() {
    _formNames = DatabaseHelper.instance.getFormsNames();
    _subjectNames = DatabaseHelper.instance.getSubjectNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Survey'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<List<String>>(
                    future: _subjectNames,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.hasData) {
                          List<String>? formNames = snapshot.data;
                          return Row(
                            children: [
                              Text('Select Subject:'), // Add a label here
                              SizedBox(width: 10), // Add some spacing
                              DropdownButton<String>(
                                value: _selectedSubject,
                                items: formNames
                                    ?.map((String name) =>
                                        DropdownMenuItem<String>(
                                          value: name,
                                          child: Text(name),
                                        ))
                                    .toList(),
                                onChanged: (String? selectedSubject) {
                                  setState(() {
                                    if (selectedSubject != null) {
                                      _selectedSubject = selectedSubject;
                                      // Do something with the selected name.
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        } else {
                          return Text('No data available');
                        }
                      }
                    },
                  ),
                  FutureBuilder<List<String>>(
                    future: _formNames,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.hasData) {
                          List<String>? formNames = snapshot.data;
                          return Row(
                            children: [
                              Text('Select Form:'), // Add a label here
                              SizedBox(width: 10), // Add some spacing
                              DropdownButton<String>(
                                value: _selectedName,
                                items: formNames
                                    ?.map((String name) =>
                                        DropdownMenuItem<String>(
                                          value: name,
                                          child: Text(name),
                                        ))
                                    .toList(),
                                onChanged: (String? selectedName) {
                                  setState(() {
                                    if (selectedName != null) {
                                      _selectedName = selectedName;
                                      // Do something with the selected name.
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        } else {
                          return Text('No data available');
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TakeSurveyPage(_selectedName!, _selectedSubject!),
                        ),
                      );
                    },
                    icon: Icon(Icons.assignment,
                        size:
                            30), // Add an icon (e.g., a survey icon for "Take Survey")
                    label: Text('Take Survey'),
                  )
                ],
              ),
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
