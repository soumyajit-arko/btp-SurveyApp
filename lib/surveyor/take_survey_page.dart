import 'dart:io';
import 'package:app_001/Audio/audio_player.dart';
import 'package:app_001/Audio/audio_recorder.dart';
import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/family_details.dart';
import 'package:app_001/surveyor/form_details.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
import 'package:app_001/surveyor/past_response_widget.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../backend/database_helper.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;

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
  Map<String, bool?> checkboxValues = {};
  Map<String, dynamic> pastResponse = {};
  List<Map<String, dynamic>> pastResponses = [];
  String pageTitle = "Take Service";
  String saveText = "Save Service";
  String careTaker = "";
  // String selectedResponse = ''; // Variable to hold the selected response
  Map<String, dynamic>? selectedResponse;
  Map<String, dynamic> selectedResponseUtil = {};
  File? _image;
  // bool isChecked = false;
  List<bool> checkedList = [];

  bool showPlayer = false;
  String? audioPath;
  @override
  void initState() {
    showPlayer = false;
    super.initState();
    changeTitle();
    displayForm();
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

  void displayForm() async {
    final details =
        await DatabaseHelper.instance.getFormWithName(widget.formName.formName);
    dynamic jsonContent = "";
    if (widget.nextPage != "survey") {
      if (details[0]['details_source'] != null)
        jsonContent =
            jsonDecode(details[0]['details_source'])['details_source'];
      // print('json CONTENT : $jsonContent');
    } else {
      // print('halo : ');
      jsonContent =
          jsonDecode(details[0]['template_source'])['template_source'];
      // print(details[0]['sid']);
      // print(widget.familyDetails.subjectID);
      final pR = await DatabaseHelper.instance.getPreviousResponses(
          widget.familyDetails.subjectID, details[0]['sid']);
      // print('ROWS : : : ');
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
        // print(pastResponses);
        //  List<Map<String,dynamic> > y = jsonDecode(pR);
        // print(pR[0]['survey_data'].runtimeType);
        // print(pR[0]['survey_data']);
        var x = jsonDecode(pR[0]['survey_data']);
        String careTaker_ = "";
        if (pR[0]['username'] != null) {
          careTaker_ = pR[0]['username'];
        }
        // print(x.runtimeType);
        // print(x);

        setState(() {
          pastResponse = x;
          careTaker = careTaker_;
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

  void updateCheckboxResponse(String questionText, bool? value) {
    print('I am updating checkbox value');
    setState(() {
      checkboxValues[questionText] = value;
      // responses[questionText] = value;
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

  Future<bool> validateAndSaveResponse() async {
    bool allRequiredQuestionsAnswered = true;
    print('Came to validation : ');
    for (var question in questions) {
      final req = question['attrreq'];
      print('req : $req');
      final questionText = question['attrname'];
      final response = responses[questionText];
      print('checking req = true or not');
      print('$questionText : $response');
      if (question['attrtype'] == 'Check Box') continue;
      if ((req == 'true' || req == 1 || req == '1') &&
          (response == null || response.isEmpty)) {
        print('found not true');
        allRequiredQuestionsAnswered = false;
        break;
      }
    }
    if (!allRequiredQuestionsAnswered) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Required Questions'),
            content: Text('Please make sure to answer all required questions.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Close the dialog and return false
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
    return allRequiredQuestionsAnswered;
  }

  Future<void> saveResponse() async {
    final responsesMap = Map<String, dynamic>.from(responses);
    print('The responses are : ');
    print(responsesMap);
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
        'image': "",
        'voice': "",
        'username': LoginPage.username,
        'userid': LoginPage.userId,
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
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String imageFileName = "${rid + 1}"+".jpg";
      String pathutil = path.join(documentDirectory.path, imageFileName);
      final te = await _image?.copy(pathutil);

      final b = await DatabaseHelper.instance.insertResponse({
        'rid': rid + 1,
        'subject_id': subID,
        'survey_datetime': formattedDatetime,
        'sid': sid,
        'record_type': 0,
        'image': imageFileName,
        'voice': audioPath ?? "",
        'username': LoginPage.username,
        'userid': LoginPage.userId,
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

  Widget _buildSmallTextField(
      String questionText, String hintText, String unit) {
    return Container(
      width: 400, // Set the desired width
      height: 50,
      child: TextField(
        onChanged: (value) {
          handleOptionSelected(questionText, value);
        },
        decoration: InputDecoration(
          isDense: true,
          hintText: (unit.isNotEmpty) ? hintText + " in $unit" : hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget questionTextWithResponse(
      String questionText, String unit_, dynamic req) {
    String prevText = "";
    if (selectedResponseUtil.isNotEmpty) {
      prevText = "(" + selectedResponseUtil[questionText];
      if (unit_.isNotEmpty) {
        prevText += " $unit_";
      }
      prevText += ")";
    } else {
      if (pastResponse.isNotEmpty && pastResponse[questionText] != null) {
        prevText = "(" + pastResponse[questionText];
        if (unit_.isNotEmpty) {
          prevText += " $unit_";
        }
        prevText += ")";
      }
    }
    if (unit_.isNotEmpty) {
      questionText += " (in " + unit_ + ")";
    }
    // if (pastResponse[questionText] != null) {
    // }
    if (req == 1 || req == '1' || (req == 'true')) {
      questionText += '*';
    }
    return Text(
      "$questionText $prevText",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    final questionText = question['attrname'];
    final questionType = question['attrtype'];
    final options_ = question['attrvalues'];
    final unit_ = question['attrunit'];
    final req = question['attrreq'];
    dynamic options;
    if (options_ == null) {
      options = null;
    } else {
      options = options_.split(',');
    }

    if (questionType == 'Check Box') {
      // responses[questionText] = "false";
      return Row(
        children: [
          Checkbox(
            value: checkboxValues[questionText] ?? false,
            onChanged: (bool? newValue) {
              print('value is $newValue');
              print(checkboxValues[questionText]);
              setState(() {
                checkboxValues[questionText] = newValue ?? false;
                responses[questionText] =
                    (checkboxValues[questionText] == true) ? "true" : "false";
              });
              print(checkboxValues[questionText]);
              if (checkboxValues[questionText] != null &&
                  checkboxValues[questionText] == true) {
                print('yo its true');
                print(responses[questionText]);
              } else {
                print('well its false');
                print(responses[questionText]);
              }
              // updateCheckboxResponse(questionText, newValue);
            },
          ),
          Expanded(
            child: questionTextWithResponse(questionText, unit_, req),
          ),
        ],
      );
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
              questionTextWithResponse(questionText, unit_, req),
              SizedBox(height: 10),
              _buildSmallTextField(questionText, 'Enter your answer', unit_),
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
                if (widget.nextPage == 'survey' && pastResponse.isNotEmpty)
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
                    careTaker: careTaker,
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
                if (widget.nextPage == 'survey')
                  const Text(
                    'Take Biometric',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.nextPage == 'survey') const SizedBox(height: 20),
                if (widget.nextPage == 'survey')
                  _image == null
                      ? const Text('No image selected.')
                      : Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                        ),
                if (widget.nextPage == 'survey') const SizedBox(height: 20),
                if (widget.nextPage == 'survey')
                  ElevatedButton(
                    onPressed: _getImageFromCamera,
                    child: const Text("Take a Picture"),
                  ),
                if (widget.nextPage == 'survey')
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: showPlayer
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: AudioPlayer(
                                source: audioPath!,
                                onDelete: () {
                                  setState(() => showPlayer = false);
                                },
                              ),
                            )
                          : Recorder(
                              onStop: (path) {
                                print('Recorded file path: $path');
                                setState(() {
                                  audioPath = path;
                                  showPlayer = true;
                                });
                              },
                            ),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: () async {
                    bool responseValidated = await validateAndSaveResponse();
                    if (responseValidated == true) {
                      print('yes validated');
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SurveyorPageUtil()),
                          (route) => false, // Remove all routes from the stack
                        );
                      }
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
