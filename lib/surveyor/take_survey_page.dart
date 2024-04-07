import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/biometric_page.dart';
import 'package:app_001/surveyor/family_details.dart';
import 'package:app_001/surveyor/form_details.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
import 'package:app_001/surveyor/past_response_widget.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
import 'dart:convert';


class TakeSurveyPage extends StatefulWidget {
  final FormDetails formName;
  final FamilyDetails familyDetails;
  final String nextPage;
  final String startDate;
  final String endDate;
  final String village;
  const TakeSurveyPage(
      {required this.formName,
      required this.familyDetails,
      required this.nextPage,
      required this.village,
      this.startDate = "",
      this.endDate = "",
      super.key});
  @override
  _TakeSurveyPageState createState() => _TakeSurveyPageState();
}

class _TakeSurveyPageState extends State<TakeSurveyPage> {
  List<Map<String, dynamic>> questions = [];
  Map<String, dynamic> responses = {};
  Map<String, dynamic> pastResponse = {};
  List<Map<String, dynamic>> pastResponses = [];
  String pageTitle = "Take Service";
  String saveText = "Save Service";
  // String selectedResponse = ''; // Variable to hold the selected response
  Map<String, dynamic>? selectedResponse;
  Map<String, dynamic> selectedResponseUtil = {};

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
        pageTitle = "Regisration for ${widget.formName.formName} Service";
        saveText = "Enroll for service";
      });
    } else {
      setState(() {
        pageTitle = widget.formName.formName;
        saveText = "Save Service";
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
    dynamic jsonContent = "";
    // final d = jsonDecode(details[0]['template_source']);
    // print('details :  : ${details[0]['template_source']}');
    // print('d :::: ${d['template_source']}');
    if (widget.nextPage != "survey") {
      if (details[0]['details_source'] != null)
        jsonContent =
            jsonDecode(details[0]['details_source'])['details_source'];
    } else {
      print('halo : ');
      jsonContent =
          jsonDecode(details[0]['template_source'])['template_source'];
      // print(jsonContent[0]);
      // for (var r in jsonContent) {
      //   print(r['attrname']);
      // }
      print(details[0]['sid']);
      print(widget.familyDetails.subjectID);
      final pR = await DatabaseHelper.instance.getPreviousResponses(
          widget.familyDetails.subjectID, details[0]['sid']);
      print('ROWS : : : ');
      // for (var e in pR) {
      //   print(e['survey_data']);
      // }
      if (pR.isNotEmpty) {
        // print(pR);
        setState(() {
          for (var row in pR) {
            // print(jsonDecode(row));
            print(row);
            pastResponses.add(row);
          }
        });
        print(pastResponses);
        //  List<Map<String,dynamic> > y = jsonDecode(pR);
        // print(pR[0]['survey_data'].runtimeType);
        // print(pR[0]['survey_data']);
        var x = jsonDecode(pR[0]['survey_data']);
        // print(x.runtimeType);
        // print(x);

        setState(() {
          pastResponse = x;
        });
      }
    }
    // print(jsonEncode(jsonContent));
    if (jsonContent != "") {
      List<Map<String, dynamic>> mapList =
          List<Map<String, dynamic>>.from(jsonContent);
      // print(mapList);

      setState(() {
        questions = mapList;
      });
    }

    // for (var e in mapList) {
    //   print('e : $e : ${e['attrtype']}');
    // }
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

  Future<void> saveResponse() async {
    final responsesMap = Map<String, dynamic>.from(responses);
    final responsesJson = json.encode(responsesMap);
    final subjectID = widget.familyDetails.subjectID;
    // await DatabaseHelper.instance.getsubjectIDByName(widget.familyDetails);
    final sid_ =
        await DatabaseHelper.instance.getSidByName(widget.formName.formName);
    final subID = (subjectID);
    final sid = (sid_);
    DateTime now = DateTime.now();
    final formattedDatetime = now.toUtc().toIso8601String();
    final rid = await DatabaseHelper.instance.getCountForResponses();
    if (widget.nextPage != "survey") {
      final b = await DatabaseHelper.instance.insertResponse({
        'rid': rid + 1,
        'subject_id': subID,
        'survey_datetime': formattedDatetime,
        'sid': sid,
        'record_type': 1,
        'survey_data': responsesJson,
        'upload_time': 0,
      });
      print('B : : : $b');
      final c = await DatabaseHelper.instance.insertServiceEnrollment({
        'subject_id': subID,
        'sid': sid,
        'start_date': widget.startDate,
        'end_date': widget.endDate,
        'upload_time': 0,
      });
      print('doen : $c');
    } else {
      final b = await DatabaseHelper.instance.insertResponse({
        'rid': rid + 1,
        'subject_id': subID,
        'survey_datetime': formattedDatetime,
        'sid': sid,
        'record_type': 0,
        'survey_data': responsesJson,
        'upload_time': 0,
      });
      print('B : : : $b');
    }
    // final rid_ =
    //     await DatabaseHelper.instance.getridBysubjectIDandDatetime(subID, now);
    // final rid = rid_;
    print('found rid : $rid');
    for (var key in responsesMap.keys) {
      dynamic value = responsesMap[key];
      final fid_ =
          await DatabaseHelper.instance.getfidBysidandAttributeName(sid, key);
      final fid = fid_;
      print('fo fid : $fid');
      await DatabaseHelper.instance.insertFieldEntry({
        'rid': rid + 1,
        'fid': fid,
        'value': value,
        'upload_time': 0,
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
          content: Text('Service Successfuly Saved'),
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

  Widget questionTextWithResponse(String questionText) {
    String prevText = "";
    if (selectedResponseUtil.isNotEmpty) {
      prevText = "(" + selectedResponseUtil[questionText] + ")";
    } else {
      if (pastResponse.isNotEmpty) {
        prevText = "(" + pastResponse[questionText] + ")";
      }
    }
    // if (pastResponse[questionText] != null) {
    // }
    return Text(
      "$questionText $prevText",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    final questionText = question['attrname'];
    final questionType = question['attrtype'];
    final options_ = question['attrvalues'];
    dynamic options;
    if (options_ == null) {
      options = null;
    } else {
      options = options_.split(',');
    }

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
              questionTextWithResponse(questionText),
              // Text(
              //   questionText,
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              SizedBox(height: 10),
              // if (questionType == 'Single Choice')
              //   for (var option in options)
              //     RadioListTile<String>(
              //       title: Text(option),
              //       value: option,
              //       groupValue: responses[questionText],
              //       onChanged: (value) {
              //         handleOptionSelected(questionText, value ?? '');
              //       },
              //     ),
              // if (questionType == 'Multiple Choice')
              //   for (var option in options)
              //     CheckboxListTile(
              //       title: Text(option),
              //       value: responses[questionText]?.contains(option) ?? false,
              //       onChanged: (selected) {
              //         if (selected != null) {
              //           handleMultipleChoiceOptionSelected(
              //             questionText,
              //             option,
              //             selected,
              //           );
              //         }
              //       },
              //     ),
              // if (questionType == 'Text Answer' ||
              //     questionType == 'Integer Answer')
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
        title: Text(pageTitle),
        actions: [
          IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back_rounded)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                if (widget.nextPage == 'survey')
                  PastResponseWidget(
                    pastResponses: pastResponses,
                    onSelect: (response) {
                      setState(() {
                        selectedResponse = response;
                        selectedResponseUtil =
                            jsonDecode(response['survey_data']);
                      });
                      print('The response selected is : $selectedResponse');
                    },
                  ),
                SizedBox(height: 20),
                if (questions.isEmpty)
                  Text(
                    'No details are required',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                if (questions.isEmpty)
                  SizedBox(
                    height: 20,
                  ),
                for (var question in questions) _buildQuestionWidget(question),
                ElevatedButton.icon(
                  onPressed: () async {
                    await saveResponse();
                    if (widget.nextPage != "survey") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakeSurveyPage(
                            formName: widget.formName,
                            familyDetails: widget.familyDetails,
                            nextPage: "survey",
                            village: widget.village,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BiometricPage(
                                village: widget.village,
                                nextPage: widget.nextPage)),
                      );
                    }
                  },
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
