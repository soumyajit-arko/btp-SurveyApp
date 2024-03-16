import 'dart:convert';
import 'package:app_001/admin/admin_page_util.dart';
import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/user_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataUploadPage extends StatefulWidget {
  const DataUploadPage({super.key});

  @override
  State<DataUploadPage> createState() => _DataUploadPageState();
}

class _DataUploadPageState extends State<DataUploadPage> {
  String IP_Address = "10.5.29.229";
  String Port = "8080";
  @override
  void initState() {
    super.initState();
    // login();
    // createNewSurvey();
    // getSubjectInfo();
  }

  // design1, user1
  Future<void> login() async {
    String url = "https://csjitsi.iitkgp.ac.in/api/user/login";
    Map<String, dynamic> payload = {"username": "user1", "password": "user1"};
    String jsonPayload = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("response body : $json");
      print("${json["type"]}");
      print(json["name"]);
      print(json["jwtToken"]);
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  Future<void> getSubjectInfo() async {
    String url = "http://$IP_Address:$Port/api/user/get-subject-info";
    Map<String, dynamic> payload = {"subjectid": "zone2_1"};
    String jsonPayload = jsonEncode(payload);
    String bt =
        "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsImV4cCI6MTcxMDM2MDE0OSwiaWF0IjoxNzEwMzI0MTQ5LCJrZXkiOiJXbWlIVTc3OFg1d2VzMnR3czdsZkdrbGo2bUh4QWtjMGRFMlVtUW9VL1pjPSJ9.RB-ngXS6RDFFt1_cKCCQvbAQelY_rBfCXObBL_Rz8v8";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + bt,
      },
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("response body : $json");
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  Future<void> createNewSurvey() async {
    String url = "http://$IP_Address:$Port/api/user/create-new-survey";
    Map<String, dynamic> payload = {
      "name": "Test_Bally_2",
      "description": "Testing description",
      "template_source": "Testing template_source"
    };
    String jsonPayload = jsonEncode(payload);
    String bt =
        "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsImV4cCI6MTcxMDM2MDE0OSwiaWF0IjoxNzEwMzI0MTQ5LCJrZXkiOiJXbWlIVTc3OFg1d2VzMnR3czdsZkdrbGo2bUh4QWtjMGRFMlVtUW9VL1pjPSJ9.RB-ngXS6RDFFt1_cKCCQvbAQelY_rBfCXObBL_Rz8v8";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + bt,
      },
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("response body : $json");
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  Widget _demo(String username, String email) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                "J",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            onDetailsPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserDetailsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SurveyorPageUtil()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Admin'),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminPageUtil()));
            },
          ),
          // Rest of the drawer content
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data Upload'),
        ),
        drawer: _demo("Ramesh", "Ramesh@123.com"),
        body: Container());
  }
}
