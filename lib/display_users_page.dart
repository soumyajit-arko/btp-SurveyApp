import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';

class DisplayUsersPage extends StatefulWidget {
  @override
  _DisplayUsersPageState createState() => _DisplayUsersPageState();
}

class _DisplayUsersPageState extends State<DisplayUsersPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    users = await DatabaseHelper.instance.getUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Display Details of Users',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  users.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text('Name'),
                              ),
                              DataColumn(
                                label: Text('User ID'),
                              ),
                              DataColumn(
                                label: Text('Age'),
                              ),
                              DataColumn(
                                label: Text('Sex'),
                              ),
                              DataColumn(
                                label: Text('Center Code'),
                              ),
                              DataColumn(
                                label: Text('User Type'),
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
                            rows: users
                                .map(
                                  (user) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(user['Name'].toString())),
                                      DataCell(Text(user['Userid'].toString())),
                                      DataCell(Text(user['Age'].toString())),
                                      DataCell(Text(user['Sex'].toString())),
                                      DataCell(
                                          Text(user['Center_code'].toString())),
                                      DataCell(
                                          Text(user['User_Type'].toString())),
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
