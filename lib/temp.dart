// import 'package:flutter/material.dart';
// import 'database_helper.dart';
// import 'dart:convert';
// import 'login_page.dart';

// class TakeSurveyPage extends StatefulWidget {
//   final String formName;
//   final String subjectName;
//   TakeSurveyPage(this.formName, this.subjectName);
//   @override
//   _TakeSurveyPageState createState() => _TakeSurveyPageState();
// }

// class _TakeSurveyPageState extends State<TakeSurveyPage> {
//   List<Map<String, dynamic>> questions = [];
//   Map<String, dynamic> responses = {};

//   @override
//   void initState() {
//     super.initState();
//     displayForm();
//   }

//   void printSelectedName() async {
//     // print(_selectedName);
//     // print('Initial');

//     // print('Final');
//     print(widget.formName);
//     print(widget.subjectName);
//   }

//   void displayForm() async {
//     final details =
//         await DatabaseHelper.instance.getFormWithName(widget.formName);
//     final jsonContent = details[0]['template_source'];
//     final data = json.decode(jsonContent);
//     List<Map<String, dynamic>> mapList =
//         data.cast<Map<String, dynamic>>().toList();

//     setState(() {
//       questions = mapList;
//     });
//   }

//   void handleOptionSelected(String question, String selectedOption) {
//     setState(() {
//       responses[question] = selectedOption;
//     });
//   }

//   void handleMultipleChoiceOptionSelected(
//       String question, String option, bool selected) {
//     setState(() {
//       if (responses[question] != null) {
//         // If a response already exists, append the new option with a comma
//         responses[question] = '${responses[question]}, $option';
//       } else {
//         responses[question] = option;
//       }
//     });
//   }

//   void saveResponse() async {
//     final responsesMap = Map<String, dynamic>.from(responses);
//     final responsesJson = json.encode(responsesMap);
//     final subjectID =
//         await DatabaseHelper.instance.getsubjectIDByName(widget.subjectName);
//     final sid_ = await DatabaseHelper.instance.getSidByName(widget.formName);
//     final subID = int.parse(subjectID);
//     final sid = int.parse(sid_);
//     DateTime now = DateTime.now();
//     final formattedDatetime = now.toUtc().toIso8601String();

//     await DatabaseHelper.instance.insertResponse({
//       'subject_id': subID,
//       'survey_datetime': formattedDatetime,
//       'sid': sid,
//       'survey_data': responsesJson,
//     });

//     final rid_ =
//         await DatabaseHelper.instance.getridBysubjectIDandDatetime(subID, now);
//     final rid = int.parse(rid_);
//     for (var key in responsesMap.keys) {
//       dynamic value = responsesMap[key];
//       final fid_ =
//           await DatabaseHelper.instance.getfidBysidandAttributeName(sid, key);
//       final fid = int.parse(fid_);
//       await DatabaseHelper.instance.insertFieldEntry({
//         'rid': rid,
//         'fid': fid,
//         'value': value,
//       });
//     }

//     setState(() {
//       responses = {};
//     });
//   }

//   Widget _buildSmallTextField(String questionText, String hintText) {
//     return Container(
//       width: 400, // Set the desired width
//       height: 50,
//       child: TextField(
//         onChanged: (value) {
//           handleOptionSelected(questionText, value);
//         },
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take Survey'),
//       ),
//       body: Stack(
//         children: <Widget>[
//           SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: 500,
//                   child: ListView.builder(
//                     itemCount: questions.length,
//                     itemBuilder: (context, index) {
//                       final question = questions[index];
//                       final questionText = question['question'];
//                       final questionType = question['type'];
//                       final options_ = question['options'];
//                       final options = options_.split(',');
//                       Widget? questionWidget;
//                       if (questionType == 'Single Choice') {
//                         questionWidget = Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(questionText, style: TextStyle(fontSize: 18)),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             for (var option in options)
//                               RadioListTile<String>(
//                                 title: Text(option),
//                                 value: option,
//                                 groupValue: responses[questionText],
//                                 onChanged: (value) {
//                                   handleOptionSelected(
//                                       questionText, value ?? '');
//                                 },
//                               ),
//                           ],
//                         );
//                       } else if (questionType == 'Multiple Choice') {
//                         questionWidget = Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(questionText, style: TextStyle(fontSize: 18)),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             for (var option in options)
//                               CheckboxListTile(
//                                 title: Text(option),
//                                 value:
//                                     responses[questionText]?.contains(option) ??
//                                         false,
//                                 onChanged: (selected) {
//                                   if (selected != null) {
//                                     handleMultipleChoiceOptionSelected(
//                                         questionText, option, selected);
//                                   }
//                                 },
//                               ),
//                           ],
//                         );
//                       } else if (questionType == 'Text Answer' ||
//                           questionType == 'Integer Answer') {
//                         // final tempUtil = TextEditingController();
//                         // textControllers.add(tempUtil);
//                         // count++;
//                         questionWidget = Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(questionText,
//                                     style: TextStyle(fontSize: 18)),
//                                 SizedBox(
//                                     width:
//                                         10), // Add spacing between the Text and TextField
//                                 _buildSmallTextField(
//                                     questionText, 'Enter your answer'),
//                               ],
//                             )
//                           ],
//                         );
//                       }

//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: questionWidget,
//                       );
//                     },
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: saveResponse,
//                   icon: Icon(Icons.save, size: 30), // Add a "save" icon
//                   label: Text('Save Response'),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 10,
//             right: 10,
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginPage(),
//                   ),
//                 );
//               },
//               icon: Icon(Icons.logout, size: 30),
//               label: Text('Logout'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
