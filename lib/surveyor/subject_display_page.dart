// import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../backend/database_helper.dart';
import 'package:path/path.dart' as path;

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
    // int val = await DatabaseHelper.instance.getCountForZone('zone1');
    // print(val);
    final subjects_ = await DatabaseHelper.instance.getSubjects();
    // for (var e in subjects) {
    //   print(e['Zone_ID']);
    //   print(e['Village']);
    // }
    setState(() {
      subjects = subjects_;
    });
  }

  Widget biometricDialogue(String filePath) {
    try {
      // Load the image file
      File imageFile = File(filePath);

      // Check if the image file exists
      if (!imageFile.existsSync()) {
        throw Exception('Image not found');
      }

      // If image file exists, show the dialog with the image
      return Dialog(
        child: Container(
          width: 200,
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(imageFile),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    } catch (e) {
      // If image file not found or any other exception occurs, show error message
      return Dialog(
        child: Container(
          width: 200,
          height: 250,
          alignment: Alignment.center,
          child: Text('Image is not available'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficiary Display Page'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Display Details of Beneficiaries',
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
                                label: Text('Biometric'),
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
                                      DataCell(
                                        Text('View Biometric'),
                                        onTap: () async {
                                          print(subject['Image']);
                                          // final db = DatabaseHelper.instance;
                                          // print(
                                          //     subject['subject_id'].toString());
                                          // final flag = await db.upadteImage(
                                          //     subject['subject_id'].toString());
                                          // print(flag);
                                          final filepath =
                                              await getApplicationDocumentsDirectory();
                                          await showDialog(
                                            context: context,
                                            builder: (_) => biometricDialogue(
                                              path.join(filepath.path,
                                                  subject['Image'].toString()),
                                            ),
                                          );
                                        },
                                      ),
                                      DataCell(Text(
                                          subject['MaritalStatus'].toString())),
                                      DataCell(
                                          Text(subject['Village'].toString())),
                                      DataCell(
                                          Text(subject['IDType'].toString())),
                                      DataCell(
                                          Text(subject['IDNumber'].toString())),
                                      DataCell(
                                          Text(subject['Mobile'].toString())),
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
        ],
      ),
    );
  }
}
