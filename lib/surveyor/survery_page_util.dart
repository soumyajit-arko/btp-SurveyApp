import 'package:app_001/backend/database_helper.dart';
import 'package:app_001/surveyor/change_username.dart';
import 'package:app_001/surveyor/data_download_page.dart';
import 'package:app_001/surveyor/data_upload_page.dart';
import 'package:app_001/surveyor/display_survey_responses.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
// import 'package:app_001/surveyor/family_details.dart';
// import 'package:app_001/surveyor/subject_selection_survey.dart';
import 'package:app_001/surveyor/village_data_table_page.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
// import 'form_selection_survey.dart';
import 'subject_display_page.dart';
import 'subject_register_page.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';

class SurveyorPageUtil extends StatefulWidget {
  @override
  _SurveyorPageUtilState createState() => _SurveyorPageUtilState();
}

class _SurveyorPageUtilState extends State<SurveyorPageUtil> {
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
          SurveyorPageUtil(),
        ],
        icons: [
          Icons.home,
          Icons.logout,
          Icons.network_cell_rounded,
          Icons.edit_outlined,
        ],
        pageTitles: ['Home', 'Log out', 'Bandwidth', 'Change Username'],
        reloadCallback: () {
          setState(() {}); // Trigger a rebuild of the parent widget
        },
      ),
      appBar: AppBar(
        title: Text('Home'),
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
                      label: Text('Beneficiary Enrollment'),
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
                      label: Text('Display Beneficiaries'),
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
                            builder: (context) =>
                                VillageDataTablePage(nextPage: 'survey'),
                            // FamilyDataTablePage(nextPage: 'survey'),
                          ),
                        );
                      },
                      icon: Icon(Icons.assignment, size: 30), // Add an icon
                      label: Text('Take Service'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VillageDataTablePage(
                                nextPage: 'service registration'),
                            // FamilyDataTablePage(nextPage: 'service registraion'),
                          ),
                        );
                      },
                      icon: Icon(Icons.assignment, size: 30), // Add an icon
                      label: Text('Enroll to a Service'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeUserNamePage(nextPage: 'survey'),
                          ),
                        );
                      },
                      icon: Icon(Icons.assignment, size: 30), // Add an icon
                      label: Text('Change username'),
                    ),
                    // SizedBox(height: 20),
                    // ElevatedButton.icon(
                    //   onPressed: () async {
                    //     await DatabaseHelper.instance
                    //         .updateSubjectId('ppp', 'zone4_2');
                    //   },
                    //   icon: Icon(Icons.assignment, size: 30), // Add an icon
                    //   label: Text('Update Subject'),
                    // ),
                    // SizedBox(height: 20),
                    // ElevatedButton.icon(
                    //   onPressed: () async {
                    //     await DatabaseHelper.instance
                    //         .updateRecordLogID('9898', '17');
                    //   },
                    //   icon: Icon(Icons.assignment, size: 30), // Add an icon
                    //   label: Text('Update record_id'),
                    // ),
                    // SizedBox(height: 20),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => DataDownloadPage(),
                    //       ),
                    //     );
                    //   },
                    //   icon: Icon(Icons.assignment, size: 30), // Add an icon
                    //   label: Text('Download Data'),
                    // ),
                    // SizedBox(height: 20),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => FormDataTablePage(
                    //           nextPage: 'Service Enrolled Subjects',
                    //           family: FamilyDetails(
                    //               subjectID: '',
                    //               subjectName: '',
                    //               spouseName: '',
                    //               childName: ''),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   icon: Icon(Icons.assignment, size: 30), // Add an icon
                    //   label: Text('Service Enrolled List'),
                    // ),
                    SizedBox(height: 20),
                  ],
                )
              ],
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
