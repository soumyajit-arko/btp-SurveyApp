import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
// import '../login_page.dart';
import 'survey_data_page.dart';

class DisplaySurveyResponses extends StatefulWidget {
  const DisplaySurveyResponses({super.key});

  @override
  State<DisplaySurveyResponses> createState() => _DisplaySurveyResponsesState();
}

class _DisplaySurveyResponsesState extends State<DisplaySurveyResponses> {
  List<Map<String, dynamic>> responsesList = [];
  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  void _loadResponses() async {
    final res = await DatabaseHelper.instance.getResponses();
    print(res);
    setState(() {
      responsesList = res;
    });
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
        title: Text('Display Responses'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Responses of various Beneficiaries',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                responsesList.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const <DataColumn>[
                            // DataColumn(label: Text('rid')),
                            DataColumn(label: Text('Beneficiary Name')),
                            DataColumn(label: Text('Service Name')),
                            DataColumn(label: Text('Mobile')),
                            DataColumn(label: Text('Age')),
                            DataColumn(label: Text('Village')),

                            // DataColumn(label: Text('sid')),
                            // DataColumn(label: Text('subject_id')),
                            DataColumn(label: Text('survey datetime')),
                            DataColumn(label: Text('survey data')),
                          ],
                          rows: responsesList
                              .map(
                                (form_) => DataRow(
                                  cells: <DataCell>[
                                    // DataCell(Text(form_['rid'].toString())),
                                    DataCell(
                                        Text(form_['SubjectName'].toString())),
                                    DataCell(
                                        Text(form_['FormName'].toString())),
                                    DataCell(Text(form_['Mobile'].toString())),
                                    DataCell(Text(form_['Age'].toString())),
                                    DataCell(Text(form_['Village'].toString())),
                                    // DataCell(Text(form_['sid'].toString())),
                                    // DataCell(      Text(form_['subject_id'].toString())),
                                    DataCell(Text(
                                        form_['survey_datetime'].toString())),
                                    DataCell(
                                      const Text("View the response"),
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
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : Container(),
              ],
            )),
          ),
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => LoginPage(),
          //         ),
          //       );
          //     },
          //     icon: Icon(Icons.logout, size: 30),
          //     label: Text('Logout'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
