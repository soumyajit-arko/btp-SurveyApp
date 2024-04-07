import 'dart:convert';
import 'dart:io';
import 'package:app_001/surveyor/hamburger_menu.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
import 'package:http/http.dart' as http;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:camera/camera.dart';
import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/form_selection_survey.dart';
import 'package:app_001/surveyor/village_data_table_page.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
// import 'package:record/record.dart';

import '../backend/database_helper.dart';
import '../Audio/audio_player.dart';
import '../Audio/audio_recorder.dart';

class BiometricPage extends StatefulWidget {
  final String village;
  final String nextPage;
  const BiometricPage(
      {required this.village, required this.nextPage, super.key});
  @override
  _BiometricPageState createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  File? _image;

  bool showPlayer = false;
  String? audioPath;
  // Future<void> _getImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     }
  //   });
  // }

  @override
  void initState() {
    showPlayer = false;

    super.initState();
  }

  // void addSubject() async {
  //   String name = nameController.text;

  //   int age = int.tryParse(ageController.text) ?? 0;
  //   String sex = sexController.text;
  //   String zoneID = zoneIDController.text;
  //   String occupation = occupationController.text;

  //   String address = addressController.text;
  //   String mobile = mobileController.text;
  //   String email = emailController.text;

  //   await DatabaseHelper.instance.insertSubject({
  //     'Name': name,
  //     'Age': age,
  //     'Sex': sex,
  //     'Zone_ID': zoneID,
  //     'Occupation': occupation,
  //     'Address': address,
  //     'Mobile': mobile,
  //     'Email': email
  //   });

  //   _clearFields();
  // }

  // void _clearFields() {
  //   nameController.clear();

  //   ageController.clear();
  //   sexController.clear();
  //   zoneIDController.clear();
  //   occupationController.clear();

  //   addressController.clear();
  //   mobileController.clear();
  //   emailController.clear();
  // }
  Future<void> addSubject() async {
    // Directory documentDirectory = await getApplicationDocumentsDirectory();

    // String filename = subjectNameController.text + ".jpg";
    // String pathutil = path.join(documentDirectory.path, filename);
    // final te = await _image?.copy(pathutil);
    // _image.
    // print(te);
    print('done');

    // String image = filename;
    // String? voice = audioPath;

    // _clearFields();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Biometric Saved Successfully'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>

            // FormDataTablePage(village: village, nextPage: "service registration"),
            FormDataTablePage(village: widget.village, nextPage: "survey"),
      ),
    );
  }

  // void tempFun() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   String filename = subjectNameController.text + ".jpg";

  //   final pathutil = path.join(documentDirectory.path, filename);
  //   print(pathutil);
  //   final f = File(pathutil);
  //   final  fileContent = await f.readAsBytes();

  //   print(f);
  //   print(fileContent);
  //   setState(() {
  //     _tempimage = f;
  //   });
  //   print('executed :: : ');
  // }

  void _clearFields() {
    // subjectNameController.clear();
    // childNameController.clear();
    // mobileController.clear();
    // maritalStatusController.clear();
    // villageController.clear();
    // idTypeController.clear();
    // idNumberController.clear();
    // initialDateController.clear();
    // finalDateController.clear();
    // addressController.clear();
    // spouseNameController.clear();
    // ageController.clear();
    // sexController.clear();
    // casteController.clear();
    // imageController.clear();
    // voiceController.clear();
    // religionController.clear();
    // occupationController.clear();
    // zoneidController.clear();
    // emailController.clear();
    // _image.delete()
  }

  Widget _buildSmallTextField(
      TextEditingController controller, String labelText,
      {TextInputType? keyboardType}) {
    return Container(
      width: 200,
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Widget _buildFormField(String labelText, TextEditingController controller,
  //     {TextInputType? keyboardType}) {
  //   return Container(
  //     // margin: EdgeInsets.only(left: 380, bottom: 15),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: 100, // Adjust the width according to your preference
  //               child: Text(
  //                 labelText,
  //                 style: TextStyle(fontSize: 18),
  //               ),
  //             ),
  //             SizedBox(
  //                 width: 20), // Adjust the space between label and text field
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(
  //                     right: 380.0), // Adjust the horizontal padding
  //                 child: TextField(
  //                   controller: controller,
  //                   keyboardType: keyboardType,
  //                   decoration: InputDecoration(
  //                     hintText: 'Enter $labelText',
  //                     border: OutlineInputBorder(),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
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

  Widget _buildFormField(String labelText, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10), // Adjust vertical margin as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 100, // Adjust the width according to your preference
                child: Text(
                  labelText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                width: 20, // Adjust the space between label and text field
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: 'Enter $labelText',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // DateTime initialDateSelected = DateTime.now();
  // DateTime finalDateSelected = DateTime.now();

  // Widget _buildDateSelector(String labelText, DateTime selectedDate,
  //     Function(DateTime) onDateSelected, TextEditingController dateController) {
  //   if (selectedDate != null) {
  //     dateController.text = _formatDate(selectedDate);
  //   }

  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               width: 100,
  //               child: Text(
  //                 labelText,
  //                 style: TextStyle(fontSize: 18),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             Expanded(
  //               child: TextField(
  //                 controller: dateController,
  //                 readOnly: true,
  //                 onTap: () => _selectDate(
  //                     context, selectedDate, onDateSelected, dateController),
  //                 decoration: InputDecoration(
  //                   hintText: 'Select Date',
  //                   border: OutlineInputBorder(),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _selectDate(
  //     BuildContext context,
  //     DateTime selectedDate,
  //     Function(DateTime) onDateSelected,
  //     TextEditingController controller) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2101),
  //   );

  //   if (pickedDate != null) {
  //     onDateSelected(pickedDate);
  //     controller.text = _formatDate(pickedDate);
  //   }
  // }

  // String _formatDate(DateTime date) {
  //   return DateFormat('dd-MM-yyyy').format(date);
  // }

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
        title: Text('Biometric Page'),
         actions: [
          IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back_rounded)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Take Biometric',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _image == null
                      ? const Text('No image selected.')
                      : Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                        ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getImageFromCamera,
                    child: const Text("Take a Picture"),
                  ),
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
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      print('create subject is clicked');
                      addSubject();
                      print('came out');
                    },
                    icon: const Icon(Icons.person, size: 30),
                    label: const Text('Take Biometric'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
