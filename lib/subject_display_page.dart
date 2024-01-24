import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';

class SubjectDisplayPage extends StatefulWidget {
  @override
  _SubjectDisplayPageState createState() => _SubjectDisplayPageState();
}

class _SubjectDisplayPageState extends State<SubjectDisplayPage> {
  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.initDatabase();
    _loadsubjects();
  }

  void _loadsubjects() async {
    subjects = await DatabaseHelper.instance.getSubjects();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects Display Page'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Display Details of subjects',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subjects.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text('Name'),
                              ),
                              DataColumn(
                                label: Text('Subject ID'),
                              ),
                              DataColumn(
                                label: Text('Age'),
                              ),
                              DataColumn(
                                label: Text('Sex'),
                              ),
                              DataColumn(
                                label: Text('Zone ID'),
                              ),
                              DataColumn(
                                label: Text('Occupation'),
                              ),
                              DataColumn(
                                label: Text('Address'),
                              ),
                              DataColumn(
                                label: Text('Mobile'),
                              ),
                              DataColumn(
                                label: Text('Email'),
                              ),
                            ],
                            rows: subjects
                                .map(
                                  (user) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(user['Name'].toString())),
                                      DataCell(
                                          Text(user['subject_id'].toString())),
                                      DataCell(Text(user['Age'].toString())),
                                      DataCell(Text(user['Sex'].toString())),
                                      DataCell(
                                          Text(user['Zone_ID'].toString())),
                                      DataCell(
                                          Text(user['Occupation'].toString())),
                                      DataCell(
                                          Text(user['Address'].toString())),
                                      DataCell(Text(user['Mobile'].toString())),
                                      DataCell(Text(user['Email'].toString())),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      : Container(),
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
