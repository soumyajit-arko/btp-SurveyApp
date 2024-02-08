import 'package:app_001/surveyor/family_details.dart';
import 'package:app_001/surveyor/form_details.dart';
import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
import 'dart:convert';

class TakeSurveyPage extends StatefulWidget {
  final FormDetails formName;
  final FamilyDetails familyDetails;
  final String nextPage;
  final String startDate;
  final String endDate;
  const TakeSurveyPage(
      {required this.formName,
      required this.familyDetails,
      required this.nextPage,
      this.startDate="",
      this.endDate="",
      super.key});
  @override
  _TakeSurveyPageState createState() => _TakeSurveyPageState();
}

class _TakeSurveyPageState extends State<TakeSurveyPage> {
  List<Map<String, dynamic>> questions = [];
  Map<String, dynamic> responses = {};
  String pageTitle = "Take Survey";
  String saveText = "Save Survey";
  @override
  void initState() {
    super.initState();
    changeTitle();
    displayForm();
    printSelectedName();
  }

  void changeTitle() {
    if (widget.nextPage != 'survey') {
      setState(() {
        pageTitle = "Regisration for Service";
        saveText = "Enroll for service";
      });
    }
  }

  void printSelectedName() async {
    // print(_selectedName);
    // print('Initial');

    // print('Final');
    print(widget.formName);
    print(widget.familyDetails);
  }

  void displayForm() async {
    final details =
        await DatabaseHelper.instance.getFormWithName(widget.formName.formName);
    String jsonContent = "";

    if (widget.nextPage != "survey") {
      jsonContent = details[0]['details_source'];
    } else {
      jsonContent = details[0]['template_source'];
    }
    final data = json.decode(jsonContent);
    List<Map<String, dynamic>> mapList =
        data.cast<Map<String, dynamic>>().toList();

    setState(() {
      questions = mapList;
    });
  }

  void handleOptionSelected(String question, String selectedOption) {
    setState(() {
      responses[question] = selectedOption;
    });
  }

  void handleMultipleChoiceOptionSelected(
      String question, String option, bool selected) {
    setState(() {
      if (responses[question] != null) {
        // If a response already exists, append the new option with a comma
        responses[question] = '${responses[question]}, $option';
      } else {
        responses[question] = option;
      }
    });
  }

  void saveResponse() async {
    final responsesMap = Map<String, dynamic>.from(responses);
    final responsesJson = json.encode(responsesMap);
    final subjectID = widget.familyDetails.subjectID;
    // await DatabaseHelper.instance.getsubjectIDByName(widget.familyDetails);
    final sid_ =
        await DatabaseHelper.instance.getSidByName(widget.formName.formName);
    final subID = int.parse(subjectID);
    final sid = int.parse(sid_);
    DateTime now = DateTime.now();
    final formattedDatetime = now.toUtc().toIso8601String();
    if (widget.nextPage != "survey") {
      final b = await DatabaseHelper.instance.insertResponse({
        'subject_id': subID,
        'survey_datetime': formattedDatetime,
        'sid': sid,
        'record_type': 1,
        'survey_data': responsesJson,
      });
      print('B : : : $b');
      final c = await DatabaseHelper.instance.insertServiceEnrollment({
        'subject_id': subID,
        'sid': sid,
        'start_date': widget.startDate,
        'end_date': widget.endDate,
      });
      print('doen : $c');
    } else {
      final b = await DatabaseHelper.instance.insertResponse({
        'subject_id': subID,
        'survey_datetime': formattedDatetime,
        'sid': sid,
        'record_type': 0,
        'survey_data': responsesJson,
      });
      print('B : : : $b');
    }
    final rid_ =
        await DatabaseHelper.instance.getridBysubjectIDandDatetime(subID, now);
    final rid = int.parse(rid_);
    for (var key in responsesMap.keys) {
      dynamic value = responsesMap[key];
      final fid_ =
          await DatabaseHelper.instance.getfidBysidandAttributeName(sid, key);
      final fid = int.parse(fid_);
      await DatabaseHelper.instance.insertFieldEntry({
        'rid': rid,
        'fid': fid,
        'value': value,
      });
    }

    setState(() {
      responses = {};
    });
    if (widget.nextPage != 'survey') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully Enrolled To Service'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Survey Successfuly Saved'),
        ),
      );
    }
  }

  Widget _buildSmallTextField(String questionText, String hintText) {
    return Container(
      width: 400, // Set the desired width
      height: 50,
      child: TextField(
        onChanged: (value) {
          handleOptionSelected(questionText, value);
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    final questionText = question['question'];
    final questionType = question['type'];
    final options_ = question['options'];
    final options = options_.split(',');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (questionType == 'Single Choice')
                for (var option in options)
                  RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: responses[questionText],
                    onChanged: (value) {
                      handleOptionSelected(questionText, value ?? '');
                    },
                  ),
              if (questionType == 'Multiple Choice')
                for (var option in options)
                  CheckboxListTile(
                    title: Text(option),
                    value: responses[questionText]?.contains(option) ?? false,
                    onChanged: (selected) {
                      if (selected != null) {
                        handleMultipleChoiceOptionSelected(
                          questionText,
                          option,
                          selected,
                        );
                      }
                    },
                  ),
              if (questionType == 'Text Answer' ||
                  questionType == 'Integer Answer')
                _buildSmallTextField(questionText, 'Enter your answer'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => LoginPage(),
                //       ),
                //     );
                //   },
                //   icon: Icon(Icons.logout, size: 30),
                //   label: Text('Logout'),
                // ),
                SizedBox(height: 20),
                for (var question in questions) _buildQuestionWidget(question),
                ElevatedButton.icon(
                  onPressed: saveResponse,
                  icon: Icon(Icons.save, size: 30),
                  label: Text(saveText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
