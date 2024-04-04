import 'dart:convert';
import 'package:app_001/backend/database_helper.dart';
import 'package:app_001/log/logger.dart';
import 'package:app_001/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataDownloadPage extends StatefulWidget {
  const DataDownloadPage({super.key});

  @override
  State<DataDownloadPage> createState() => _DataDownloadPageState();
}

class _DataDownloadPageState extends State<DataDownloadPage> {
  List<dynamic> zones_allocated = [],
      forms_allocated = [],
      services_available = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> download_villages() async {
    // final databaseHelper = DatabaseHelper.instance;
    // await databaseHelper.check_service_enrollment();
    await getAllocatedZone();
    for (String zone in zones_allocated) {
      await getZoneInfo(zone);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully Downloaded Villages'),
      ),
    );
  }

  Future<void> getAllocatedZone() async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-allocated-zone";
    Map<String, dynamic> payload = {"userid": LoginPage.userId};
    String jsonPayload = jsonEncode(payload);
    log.info('url : $url, json payload : $jsonPayload');
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error Connecting to the server : ${response.statusCode}!!!'),
        ),
      );
    }
  }

  Future<void> getZoneInfo(String zone) async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-zone-info";
    Map<String, dynamic> payload = {"zone_id": zone};
    String jsonPayload = jsonEncode(payload);
    log.info('url : $url, json payload : $jsonPayload');

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
      // print(json);
      final databaseHelper = DatabaseHelper.instance;
      int flag = await databaseHelper.storeTheZones(json['zone-info']);
      // print('$flag');
      log.info('Status : $flag');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error Connecting to the server : ${response.statusCode}!!!'),
        ),
      );
    }
  }

  Future<void> download_forms() async {
    await getAllocatedSurveyorForms();
    for (String surveyId in forms_allocated) {
      await getSurveyInfo(surveyId);
      await getFieldInfo(surveyId);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully Downloaded forms'),
      ),
    );
  }

  Future<void> getAllocatedSurveyorForms() async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-allocate-surveyor";
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error Connecting to the server : ${response.statusCode}!!!'),
        ),
      );
      // print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  Future<void> getSurveyInfo(String surveyId) async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-survey-info";
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
      json['survey-info']['upload_time'] = "1";
      int flag = await databaseHelper.storeTheSurveyForms(json['survey-info']);
      // print(flag);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error Connecting to the server : ${response.statusCode}!!!'),
        ),
      );
    }
  }

  Future<void> getFieldInfo(String surveyId) async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-FieldProject-info";
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
      // print(json['FieldProject-info']);
      final databaseHelper = DatabaseHelper.instance;
      for (var element in json['FieldProject-info']) {
        element['upload_time'] = "1";
        var flag = await databaseHelper.insertFieldUtil(element);
        // print(flag);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error Connecting to the server : ${response.statusCode}!!!'),
        ),
      );
    }
  }

  Future<void> getSubjects() async {
    for (String zone in zones_allocated) {
      await getBeneficiariesByZone(zone);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully Downloaded Beneficiaries'),
      ),
    );
  }

  Future<void> getBeneficiariesByZone(String zone) async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-SubjectInfo-ByZone";
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
      for (var subject in json['subject-log']) {
        int flag = await databaseHelper.insertSubjectUtil({
          "subject_id": subject["subject_id"],
          "SubjectName": subject["subjectname"],
          "SpouseName": subject["spousename"],
          "ChildName": subject["childname"],
          "MaritalStatus": subject["maritalstatus"],
          "Village": subject["village"],
          "IDType": subject["idtype"],
          "IDNumber": subject["idnumber"],
          "Age": subject["age"],
          "Sex": subject["sex"],
          "Caste": subject["caste"],
          "Religion": subject["religion"],
          "Image": subject["image"],
          "Voice": subject["voice"],
          "Occupation": subject["occupation"],
          "Zone_ID": subject["zone_id"],
          "Address": subject["address"],
          "Mobile": subject["mobile"],
          "Email": subject["email"],
          "upload_time": 1
        });
        // print(flag);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error Connecting to the server : ${response.statusCode}!!!'),
        ),
      );
    }
  }

  Future<void> getAllServices() async {
    await getServicesList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully Downloaded Services'),
      ),
    );
  }

  Future<void> getServicesList() async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-all-services";
    Map<String, dynamic> payload = {};
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
      // print(json['service-log']);
      final databaseHelper = DatabaseHelper.instance;
      for (var service in json['service-log']) {
        service['upload_time'] = "1";
        int flag = await databaseHelper.insertServiceUtil(service);
        // print(flag);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error Connecting to the server : ${response.statusCode}!!!'),
        ),
      );
    }
  }

  Future<void> getAllResponses() async {
    final databaseHelper = DatabaseHelper.instance;
    final subjects = await databaseHelper.getSubjectsSids();
    // print(subjects);
    for (var subject in subjects) {
      // print(subject['subject_id']);
      await getResponseOfASubject(subject['subject_id']);
    }
    // await databaseHelper.check_responses_to_upload();
  }

  Future<void> getResponseOfASubject(String subjectID) async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-RecordLog-BySubjectId";
    Map<String, dynamic> payload = {"subject_id": subjectID};
    String jsonPayload = jsonEncode(payload);
    var result = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LoginPage.jwtToken}',
      },
      body: jsonPayload,
    );
    final databaseHelper = DatabaseHelper.instance;
    if (result.statusCode == 200) {
      var json = jsonDecode(result.body);
      // print(json);
      for (var response in json['record-log']) {
        // print(response);
        // response['upload_time'] = "1";
        // response['InstanceTime'] = response['instance_time'];
        int flag = await databaseHelper.insertResponseUtil({
          "rid": response['rid'],
          "subject_id": response['subject_id'],
          "survey_datetime": response['survey_datetime'],
          "sid": response['sid'],
          "record_type": response['record_type'],
          "survey_data": response['survey_data'],
          "InstanceTime": response['instance_time'],
          "upload_time": 1,
        });
        // print(flag);
        final survey_data = jsonDecode(response['survey_data']);
        // print(survey_data);
        survey_data.forEach((key, value) {
          getFieldEntriesOfASubject(key, response['rid']);
        });
        // for (var entry in survey_data) {
        //   print(entry);
        // }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error Connecting to the server : ${result.statusCode}!!!'),
        ),
      );
    }
  }

  Future<void> getFieldEntriesOfASubject(String fid, String rid) async {
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/get-FieldEntries-Value";
    Map<String, dynamic> payload = {
      "fid": fid,
      "rid": rid,
    };
    String jsonPayload = jsonEncode(payload);
    var result = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LoginPage.jwtToken}',
      },
      body: jsonPayload,
    );
    if (result.statusCode == 200) {
      var json = jsonDecode(result.body);
      // print('entry : $json');
      final databaseHelper = DatabaseHelper.instance;
      int flag = await databaseHelper.insertFiedEntryUtil({
        "rid": rid,
        "fid": fid,
        "value": json['value'],
        "upload_time": 1,
      });
      // print(flag);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Download'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await download_villages();
                // DatabaseHelper.instance.checkZones();
                // print('Download Villages');
              },
              child: Text('Download Villages'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await download_forms();
                // DatabaseHelper.instance.checkUploadTime();
                // DatabaseHelper.instance.checkSurveyForms();
                // DatabaseHelper.instance.checkFields();
                // print('Download Forms');
              },
              child: Text('Download Forms'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await getSubjects();
                DatabaseHelper.instance.checkSubjects();
                // print('Download Beneficiaries');
              },
              child: Text('Download Beneficiaries'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await getAllServices();
                // print('Download Services');
              },
              child: Text('Download Services'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await getAllResponses();

                // print('Download Responses');
              },
              child: Text('Download Responses'),
            ),
          ],
        ),
      ),
    );
  }
}
