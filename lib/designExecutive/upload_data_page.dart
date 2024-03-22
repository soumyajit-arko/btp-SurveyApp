import 'dart:convert';
import 'package:app_001/backend/database_helper.dart';
import 'package:app_001/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DesignDataUploadPage extends StatefulWidget {
  const DesignDataUploadPage({super.key});

  @override
  State<DesignDataUploadPage> createState() => _DesignDataUploadPageState();
}

class _DesignDataUploadPageState extends State<DesignDataUploadPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> uploadForms() async {
    final databaseHelper = DatabaseHelper.instance;
    final data = await databaseHelper.uploadFormsData();
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/create-new-survey";
    for (var form in data) {
      print(form);
      String jsonPayload = jsonEncode(form);
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${LoginPage.jwtToken}',
        },
        body: jsonPayload,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully uploaded a form!!!'),
          ),
        );
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

  Future<void> uploadSurveyFields() async {
    final databaseHelper = DatabaseHelper.instance;
    final data = await databaseHelper.uploadFieldsData();
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/create-SurveyFields-new";
    for (var field in data) {
      print(field);

      String jsonPayload = jsonEncode({
        'attrname': field['attribute_name'],
        'attrtype': field['attribute_datatype:'],
        'source_type': field['source_type'],
        'sid': field['sid'],
        'attrunit': field['attribute_unit'],
        'attrreq': field['required_value'],
      });
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${LoginPage.jwtToken}',
        },
        body: jsonPayload,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully uploaded a field!!!'),
          ),
        );
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
                await uploadForms();
                await uploadSurveyFields();
              },
              child: Text('Upload new Forms'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
