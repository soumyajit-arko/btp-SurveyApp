import 'dart:convert';
import 'dart:math';
import 'package:app_001/backend/database_helper.dart';
import 'package:app_001/surveyor/data_upload_page.dart';
import 'package:http/http.dart' as http;
import 'package:app_001/surveyor/display_survey_responses.dart';
import 'package:app_001/surveyor/village_data_table_page.dart';
import 'subject_display_page.dart';
import 'subject_register_page.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';

class SurveyorPageUtil extends StatefulWidget {
  @override
  _SurveyorPageUtilState createState() => _SurveyorPageUtilState();
}

class _SurveyorPageUtilState extends State<SurveyorPageUtil> {
  List<dynamic> zones_allocated = [], forms_allocated = [];
  @override
  void initState() {
    super.initState();
    basicInit();
  }

  Future<void> basicInit() async {
    await getAllocatedZone();
    for (String zone in zones_allocated) {
      await getZoneInfo(zone);
    }
    await getAllocatedSurveyorForms();
    for (String surveyId in forms_allocated) {
      await getSurveyInfo(surveyId);
    }
  }

  Future<void> getAllocatedZone() async {
    String url =
        "https://csjitsi.iitkgp.ac.in/api/user/get-allocated-zone";
    Map<String, dynamic> payload = {"userid": LoginPage.userId};
    String jsonPayload = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LoginPage.jwtToken}',
      },
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      zones_allocated.clear();

      var json = jsonDecode(response.body);
      setState(() {
        zones_allocated = json['zone-id'];
      });
      print("response body : $json");
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  Future<void> getZoneInfo(String zone) async {
    String url =
        "https://csjitsi.iitkgp.ac.in/api/user/get-zone-info";
    Map<String, dynamic> payload = {"zone_id": zone};
    String jsonPayload = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LoginPage.jwtToken}',
      },
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      final databaseHelper = DatabaseHelper.instance;
      int flag = await databaseHelper.storeTheZones(json['zone-info']);
      print('flag : $flag');
      print("response body : $json");
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  Future<void> getAllocatedSurveyorForms() async {
    String url =
        "https://csjitsi.iitkgp.ac.in/api/user/get-allocate-surveyor";
    Map<String, dynamic> payload = {"userid": LoginPage.userId};
    String jsonPayload = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LoginPage.jwtToken}',
      },
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      forms_allocated.clear();
      var json = jsonDecode(response.body);
      setState(() {
        forms_allocated = json['survey-ids'];
      });
      print("response body : $json");
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  Future<void> getSurveyInfo(String surveyId) async {
    String url =
        "https://csjitsi.iitkgp.ac.in/api/user/get-survey-info";
    Map<String, dynamic> payload = {"sid": surveyId};
    String jsonPayload = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LoginPage.jwtToken}',
      },
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      final databaseHelper = DatabaseHelper.instance;
      int flag = await databaseHelper.storeTheSurveyForms(json['survey-info']);
      // print('Inserted flag : $flag');
      // print("response body : $json");
      // print('a : ${json['survey-info'][0]}');
      final f = jsonDecode(json['survey-info']['template_source']);
      print('f : ${f['template_source']}');
      // print('a : ${json['survey-info']["template_source"]}');
      for (var element in f['template_source']) {
        // print('${element['attrreq']}');
        await databaseHelper.insertField({
          'Name': element['attrname'],
          'fid': Random().nextInt(1000),
          'sid': surveyId,
          'source_type': 0,
          'attribute_name': element['attrname'],
          'attribute_datatype': element['attrtype'],
          'required_value': element['attrreq'] == "true" ? 1 : 0,
          'attribute_unit': element['attrunit'],
        });
      }
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
                            builder: (context) => DataUploadPage(),
                            // FamilyDataTablePage(nextPage: 'service registraion'),
                          ),
                        );
                      },
                      icon: Icon(Icons.assignment, size: 30), // Add an icon
                      label: Text('Demo Page'),
                    ),
                    SizedBox(height: 20),
                    
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
