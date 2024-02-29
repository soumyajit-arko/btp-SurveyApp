import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
// import '../login_page.dart';

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
                                label: Text('Beneficiary Name'),
                              ),
                              DataColumn(
                                label: Text('Spouse Name'),
                              ),
                              DataColumn(
                                label: Text('Child Name'),
                              ),
                              DataColumn(
                                label: Text('Marital Status'),
                              ),
                              DataColumn(
                                label: Text('Village'),
                              ),
                              DataColumn(
                                label: Text('ID Type'),
                              ),
                              DataColumn(
                                label: Text('ID Number'),
                              ),
                              DataColumn(
                                label: Text('Contact No.'),
                              ),
                              DataColumn(
                                label: Text('Address'),
                              ),
                              DataColumn(
                                label: Text('Age'),
                              ),
                              DataColumn(
                                label: Text('Sex'),
                              ),
                              DataColumn(
                                label: Text('Caste'),
                              ),
                            ],
                            rows: subjects
                                .map(
                                  (subject) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                          subject['SubjectName'].toString())),
                                      DataCell(Text(
                                          subject['SpouseName'].toString())),
                                      DataCell(Text(
                                          subject['ChildName'].toString())),
                                      DataCell(Text(
                                          subject['MaritalStatus'].toString())),
                                      DataCell(
                                          Text(subject['Village'].toString())),
                                      DataCell(
                                          Text(subject['IDType'].toString())),
                                      DataCell(
                                          Text(subject['IDNumber'].toString())),
                                      DataCell(Text(subject['Mobile']
                                          .toString())), // Assuming 'Mobile' is the contact number
                                      DataCell(
                                          Text(subject['Address'].toString())),
                                      DataCell(Text(subject['Age'].toString())),
                                      DataCell(Text(subject['Sex'].toString())),
                                      DataCell(
                                          Text(subject['Caste'].toString())),
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
          // Positioned(
          //   top: 10, // Adjust top position as needed
          //   right: 10, // Adjust right position as needed
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => LoginPage(),
          //         ),
          //       );
          //     },
          //     icon: Icon(Icons.logout, size: 30), // Add a logout icon
          //     label: Text('Logout'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
