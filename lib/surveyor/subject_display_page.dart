// import 'dart:html';

import 'dart:io';

import 'package:app_001/Audio/audio_player.dart';
import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
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

  Widget biometricDialogue(String imagePath, String audioPath) {
    // Check if both image and audio files exist
    bool imageExists = File(imagePath).existsSync();
    bool audioExists = File(audioPath).existsSync();

    if (!imageExists && !audioExists) {
      // If neither image nor audio files exist, display "Image and Audio not present" message
      return Dialog(
        child: Container(
          width: 200,
          height: 250,
          alignment: Alignment.center,
          child: Text('Image and Audio are not available'),
        ),
      );
    } else {
      // If at least one of the files exists, display the dialog with image and audio
      return Dialog(
        child: Container(
          width: 200,
          height: 270,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageExists)
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              SizedBox(height: 15),
              if (!imageExists)
                SizedBox(
                  height: 50,
                ),
              if (!imageExists) Text('Image is not available'),
              if (!imageExists)
                SizedBox(
                  height: 50,
                ),
              SizedBox(height: 10),
              if (audioExists)
                Container(
                  width: 200,
                  height: 80,
                  alignment: Alignment.center,
                  child: AudioPlayer(
                    source: audioPath!,
                    onDelete: () {},
                  ),
                ),
              SizedBox(height: 10),
              if (!audioExists) Text('Audio is not available'),
            ],
          ),
        ),
      );
    }
  }
  // Widget biometricDialogue(String filePath) {
  //   try {
  //     // Load the image file
  //     File imageFile = File(filePath);

  //     // Check if the image file exists
  //     if (!imageFile.existsSync()) {
  //       throw Exception('Image not found');
  //     }

  //     // If image file exists, show the dialog with the image
  //     return Dialog(
  //       child: Container(
  //         width: 200,
  //         height: 250,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: FileImage(imageFile),
  //             fit: BoxFit.fill,
  //           ),
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     // If image file not found or any other exception occurs, show error message
  //     return Dialog(
  //       child: Container(
  //         width: 200,
  //         height: 250,
  //         alignment: Alignment.center,
  //         child: Text('Image is not available'),
  //       ),
  //     );
  //   }
  // }
  Widget TextFieldUtil(String text) {
    if (text.isNotEmpty && text != 'null') {
      return Text(text);
    } else {
      return Text("-----");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu(
        userName: LoginPage.userId,
        email: LoginPage.username,
        pages: [
          SurveyorPageUtil(),
          LoginPage(),
          NetworkSpeedChecker(),
        ],
        icons: [
          Icons.home,
          Icons.logout,
          Icons.network_cell_rounded,
        ],
        pageTitles: ['Home', 'Log out', 'Bandwidth'],
      ),
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
                                      DataCell(TextFieldUtil(
                                          subject['SubjectName'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['SpouseName'].toString())),
                                      DataCell(TextFieldUtil(
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
                                              path.join(
                                                  filepath.path,
                                                  subject['subject_id'] +
                                                      ".mp3"),
                                            ),
                                          );
                                        },
                                      ),
                                      DataCell(TextFieldUtil(
                                          subject['MaritalStatus'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['Village'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['IDType'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['IDNumber'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['Mobile'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['Address'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['Age'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['Sex'].toString())),
                                      DataCell(TextFieldUtil(
                                          subject['Caste'].toString())),
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
