import 'dart:convert';
import 'package:app_001/backend/database_helper.dart';
import 'package:app_001/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataUploadPage extends StatefulWidget {
  const DataUploadPage({super.key});

  @override
  State<DataUploadPage> createState() => _DataUploadPageState();
}

class _DataUploadPageState extends State<DataUploadPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> uploadBeneficiaryDetails() async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/create-subject-new";
    final databaseHelper = DatabaseHelper.instance;
    final data = await databaseHelper.getSubjectDetailstoUpload();
    for (var subject in data) {
      Map<String, dynamic> payload = subject;
      print(subject);
      String jsonPayload = jsonEncode({
        "subjectname":payload['SubjectName'],
        "spousename":payload['SpouseName'],
        "childname":payload['ChildName'],
        "maritalstatus":payload['MaritalStatus'],
        "village":payload['Village'],
        "idtype":payload['IDType'],
        "idnumber":payload['IDNumber'],
        "age":payload['Age'],
        "sex":payload['Sex'],
        "caste":payload['Caste'],
        "religion":payload['Religion'],
        "image":payload['Image'],
        "voice":payload['Voice'],
        "occupation":payload['Occupation'],
        "zone_id":payload['Zone_ID'],
        "address":payload['Address'],
        "mobile":payload['Mobile'],
        "email":payload['Email']
      });
      print(jsonPayload);
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
        print(json);
        final flag = await databaseHelper
            .upadteSubjectDetailsAfterUpload(subject['subject_id']);
        print(flag);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error Connecting to the server : ${response.statusCode}!!!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                uploadBeneficiaryDetails();
              },
              child: Text('Upload new Beneficiaries'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {},
              child: Text('Upload responses'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {},
              child: Text('Upload service enrollment'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
