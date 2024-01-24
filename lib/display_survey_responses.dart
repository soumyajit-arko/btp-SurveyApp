import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';
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
    responsesList = await DatabaseHelper.instance.getResponses();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  'Display Responses of various Subjects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                responsesList.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Text('rid')),
                            DataColumn(label: Text('sid')),
                            DataColumn(label: Text('subject_id')),
                            DataColumn(label: Text('survey datetime')),
                            DataColumn(label: Text('survey data')),
                          ],
                          rows: responsesList
                              .map(
                                (form_) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(form_['rid'].toString())),
                                    DataCell(Text(form_['sid'].toString())),
                                    DataCell(
                                        Text(form_['subject_id'].toString())),
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
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout, size: 30),
              label: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
