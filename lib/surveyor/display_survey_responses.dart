// import 'dart:io';

// import 'package:app_001/Audio/audio_player.dart';
// import 'package:app_001/login_page.dart';
// import 'package:app_001/surveyor/hamburger_menu.dart';
// import 'package:app_001/surveyor/survery_page_util.dart';
// import 'package:app_001/utils/NetworkSpeedChecker.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import '../backend/database_helper.dart';
// import 'package:path/path.dart' as path;
// import 'survey_data_page.dart';

// class DisplaySurveyResponses extends StatefulWidget {
//   const DisplaySurveyResponses({super.key});

//   @override
//   State<DisplaySurveyResponses> createState() => _DisplaySurveyResponsesState();
// }

// class _DisplaySurveyResponsesState extends State<DisplaySurveyResponses> {
//   List<Map<String, dynamic>> responsesList = [];
//   @override
//   void initState() {
//     super.initState();
//     _loadResponses();
//   }

//   void _loadResponses() async {
//     final res = await DatabaseHelper.instance.getResponses();
//     print(res);
//     setState(() {
//       responsesList = res;
//     });
//   }

//   Widget biometricDialogue(String imagePath, String audioPath) {
//     // Check if both image and audio files exist
//     bool imageExists = File(imagePath).existsSync();
//     bool audioExists = File(audioPath).existsSync();

//     if (!imageExists && !audioExists) {
//       // If neither image nor audio files exist, display "Image and Audio not present" message
//       return Dialog(
//         child: Container(
//           width: 200,
//           height: 250,
//           alignment: Alignment.center,
//           child: Text('Image and Audio are not available'),
//         ),
//       );
//     } else {
//       // If at least one of the files exists, display the dialog with image and audio
//       return Dialog(
//         child: Container(
//           width: 200,
//           height: 270,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (imageExists)
//                 Container(
//                   width: 200,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: FileImage(File(imagePath)),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 15),
//               if (!imageExists)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (!imageExists) Text('Image is not available'),
//               if (!imageExists)
//                 SizedBox(
//                   height: 50,
//                 ),
//               SizedBox(height: 10),
//               if (audioExists)
//                 Container(
//                   width: 200,
//                   height: 80,
//                   alignment: Alignment.center,
//                   child: AudioPlayer(
//                     source: audioPath!,
//                     onDelete: () {},
//                   ),
//                 ),
//               SizedBox(height: 10),
//               if (!audioExists) Text('Audio is not available'),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: HamburgerMenu(
//         userName: LoginPage.userId,
//         email: LoginPage.username,
//         pages: [
//           SurveyorPageUtil(),
//           LoginPage(),
//           NetworkSpeedChecker(),
//         ],
//         icons: [
//           Icons.home,
//           Icons.logout,
//           Icons.network_cell_rounded,
//         ],
//         pageTitles: ['Home', 'Log out', 'Bandwidth'],
//       ),
//       appBar: AppBar(
//         title: Text('Display Responses'),
//       ),
//       body: Stack(
//         children: <Widget>[
//           SingleChildScrollView(
//             child: Center(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Responses of various Beneficiaries',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 responsesList.isNotEmpty
//                     ? SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columns: const <DataColumn>[
//                             // DataColumn(label: Text('rid')),
//                             DataColumn(label: Text('Beneficiary Name')),
//                             DataColumn(label: Text('Service Name')),
//                             DataColumn(label: Text('Mobile')),
//                             DataColumn(label: Text('Age')),
//                             DataColumn(label: Text('Village')),

//                             // DataColumn(label: Text('sid')),
//                             // DataColumn(label: Text('subject_id')),
//                             DataColumn(label: Text('survey datetime')),
//                             DataColumn(label: Text('survey data')),
//                             DataColumn(label: Text('Biometric')),
//                           ],
//                           rows: responsesList
//                               .map(
//                                 (form_) => DataRow(
//                                   cells: <DataCell>[
//                                     // DataCell(Text(form_['rid'].toString())),
//                                     DataCell(
//                                         Text(form_['SubjectName'].toString())),
//                                     DataCell(
//                                         Text(form_['FormName'].toString())),
//                                     DataCell(Text(form_['Mobile'].toString())),
//                                     DataCell(Text(form_['Age'].toString())),
//                                     DataCell(Text(form_['Village'].toString())),
//                                     // DataCell(Text(form_['sid'].toString())),
//                                     // DataCell(      Text(form_['subject_id'].toString())),
//                                     DataCell(Text(
//                                         form_['survey_datetime'].toString())),
//                                     DataCell(
//                                       const Text("View the response"),
//                                       onTap: () {
//                                         String templateSource =
//                                             form_['survey_data'].toString();
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 SurveyData(templateSource),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     DataCell(
//                                       Text('View Biometric'),
//                                       onTap: () async {
//                                         final filepath =
//                                             await getApplicationDocumentsDirectory();
//                                         showDialog(
//                                           context: context,
//                                           builder: (_) => biometricDialogue(
//                                             path.join(filepath.path,
//                                                 form_['image'].toString()),
//                                             form_['voice'] ?? "",
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       )
//                     : Container(),
//               ],
//             )),
//           ),
//           // Positioned(
//           //   top: 10,
//           //   right: 10,
//           //   child: ElevatedButton.icon(
//           //     onPressed: () {
//           //       Navigator.pushReplacement(
//           //         context,
//           //         MaterialPageRoute(
//           //           builder: (context) => LoginPage(),
//           //         ),
//           //       );
//           //     },
//           //     icon: Icon(Icons.logout, size: 30),
//           //     label: Text('Logout'),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

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
import 'survey_data_page.dart';

// class DisplaySurveyResponses extends StatefulWidget {
//   const DisplaySurveyResponses({Key? key}) : super(key: key);

//   @override
//   State<DisplaySurveyResponses> createState() => _DisplaySurveyResponsesState();
// }

// class _DisplaySurveyResponsesState extends State<DisplaySurveyResponses> {
//   List<Map<String, dynamic>> responsesList = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadResponses();
//   }

//   void _loadResponses() async {
//     final res = await DatabaseHelper.instance.getResponses();
//     print(res);
//     setState(() {
//       responsesList = res;
//     });
//   }

//   Widget biometricDialogue(String imagePath, String? audioPath) {
//     // Check if both image and audio files exist
//     bool imageExists = File(imagePath).existsSync();
//     bool audioExists = File(audioPath!).existsSync();

//     if (!imageExists && !audioExists) {
//       // If neither image nor audio files exist, display "Image and Audio not present" message
//       return Dialog(
//         child: Container(
//           width: 200,
//           height: 250,
//           alignment: Alignment.center,
//           child: Text('Image and Audio are not available'),
//         ),
//       );
//     } else {
//       // If at least one of the files exists, display the dialog with image and audio
//       return Dialog(
//         child: Container(
//           width: 200,
//           height: 270,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (imageExists)
//                 Container(
//                   width: 200,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: FileImage(File(imagePath)),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 15),
//               if (!imageExists)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (!imageExists) Text('Image is not available'),
//               if (!imageExists)
//                 SizedBox(
//                   height: 50,
//                 ),
//               SizedBox(height: 10),
//               if (audioExists)
//                 Container(
//                   width: 200,
//                   height: 80,
//                   alignment: Alignment.center,
//                   child: AudioPlayer(
//                     source: audioPath,
//                     onDelete: () {},
//                   ),
//                 ),
//               SizedBox(height: 10),
//               if (!audioExists) Text('Audio is not available'),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: HamburgerMenu(
//         userName: LoginPage.userId,
//         email: LoginPage.username,
//         pages: [
//           SurveyorPageUtil(),
//           LoginPage(),
//           NetworkSpeedChecker(),
//         ],
//         icons: [
//           Icons.home,
//           Icons.logout,
//           Icons.network_cell_rounded,
//         ],
//         pageTitles: ['Home', 'Log out', 'Bandwidth'],
//       ),
//       appBar: AppBar(
//         title: Text('Display Responses'),
//       ),
//       body: Stack(
//         children: <Widget>[
//           SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'Responses of various Beneficiaries',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   responsesList.isNotEmpty
//                       ? SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: DataTable(
//                             columns: const <DataColumn>[
//                               DataColumn(label: Text('Beneficiary Name')),
//                               DataColumn(label: Text('Service Name')),
//                               DataColumn(label: Text('Mobile')),
//                               DataColumn(label: Text('Age')),
//                               DataColumn(label: Text('Village')),
//                               DataColumn(label: Text('survey datetime')),
//                               DataColumn(label: Text('survey data')),
//                               DataColumn(label: Text('Biometric')),
//                             ],
//                             rows: responsesList
//                                 .map(
//                                   (form_) => DataRow(
//                                     cells: <DataCell>[
//                                       DataCell(Text(
//                                           form_['SubjectName'].toString())),
//                                       DataCell(
//                                           Text(form_['FormName'].toString())),
//                                       DataCell(
//                                           Text(form_['Mobile'].toString())),
//                                       DataCell(Text(form_['Age'].toString())),
//                                       DataCell(
//                                           Text(form_['Village'].toString())),
//                                       DataCell(Text(
//                                           form_['survey_datetime'].toString())),
//                                       DataCell(
//                                         const Text("View the response"),
//                                         onTap: () {
//                                           String templateSource =
//                                               form_['survey_data'].toString();
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   SurveyData(templateSource),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                       DataCell(
//                                         Text('View Biometric'),
//                                         onTap: () async {
//                                           final filepath =
//                                               await getApplicationDocumentsDirectory();
//                                           showDialog(
//                                             context: context,
//                                             builder: (_) => biometricDialogue(
//                                               path.join(filepath.path,
//                                                   form_['image'].toString()),
//                                               form_['voice'] ?? "",
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DisplaySurveyResponses extends StatefulWidget {
  const DisplaySurveyResponses({Key? key}) : super(key: key);

  @override
  State<DisplaySurveyResponses> createState() => _DisplaySurveyResponsesState();
}

class _DisplaySurveyResponsesState extends State<DisplaySurveyResponses> {
  List<Map<String, dynamic>> responsesList = [];
  List<Map<String, dynamic>> filteredResponsesList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  void _loadResponses() async {
    final res = await DatabaseHelper.instance.getResponses();
    // print(res);
    for (var row in res) {
      print(row);
    }
    setState(() {
      responsesList = res;
      filteredResponsesList = res;
    });
  }

  void _filterResponses(String query) {
    setState(() {
      filteredResponsesList = responsesList.where((response) {
        final subjectName = response['SubjectName'].toString().toLowerCase();
        final formName = response['FormName'].toString().toLowerCase();
        return subjectName.contains(query.toLowerCase()) ||
            formName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Widget TextFieldSubject(Map<String, dynamic> form_) {
    String name = form_['SubjectName'];
    if (form_['SpouseName'] != null) {
      name += "/" + form_['SpouseName'].toString();
    }
    if (form_['ChildName'] != null) {
      name += "/" + form_['ChildName'].toString();
    }
    return Text(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Responses'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                _filterResponses(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by beneficiary or service name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                      label: Text('Beneficiary Name/Spouse Name/Child Name')),
                  DataColumn(label: Text('Service Name')),
                  DataColumn(label: Text('Mobile')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Village')),
                  DataColumn(label: Text('Survey Datetime')),
                  DataColumn(label: Text('Survey Data')),
                  DataColumn(label: Text('Biometric')),
                ],
                rows: filteredResponsesList
                    .map(
                      (form_) => DataRow(
                        cells: <DataCell>[
                          DataCell(TextFieldSubject(form_)),
                          DataCell(Text(form_['FormName'].toString())),
                          DataCell(Text(form_['Mobile'].toString())),
                          DataCell(Text(form_['Age'].toString())),
                          DataCell(Text(form_['Village'].toString())),
                          DataCell(Text(form_['survey_datetime'].toString())),
                          DataCell(
                            GestureDetector(
                              child: Text('View the response'),
                              onTap: () {
                                String templateSource =
                                    form_['survey_data'].toString();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SurveyData(templateSource),
                                  ),
                                );
                              },
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              child: Text('View Biometric'),
                              onTap: () async {
                                final filepath =
                                    await getApplicationDocumentsDirectory();
                                showDialog(
                                  context: context,
                                  builder: (_) => biometricDialogue(
                                    path.join(filepath.path,
                                        form_['image'].toString()),
                                    form_['voice'] ?? "",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget biometricDialogue(String imagePath, String? audioPath) {
    // Check if both image and audio files exist
    bool imageExists = File(imagePath).existsSync();
    bool audioExists = File(audioPath!).existsSync();

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
                    source: audioPath,
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
}
