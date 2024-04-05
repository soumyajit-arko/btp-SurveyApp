import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:camera/camera.dart';
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

class SubjectRegisterPage extends StatefulWidget {
  @override
  _SubjectRegisterPageState createState() => _SubjectRegisterPageState();
}

class _SubjectRegisterPageState extends State<SubjectRegisterPage> {
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController idTypeController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController spouseNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController casteController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController voiceController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController zoneidController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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

  Future<void> addSubject() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    // _image.
    // print(te);
    // print('done');
    String subjectName = subjectNameController.text;
    String spouseName = spouseNameController.text;
    String childName = childNameController.text;
    String maritalStatus = maritalStatusController.text;
    String village = villageController.text;
    String idType = idTypeController.text;
    String idNumber = idNumberController.text;
    String mobile = mobileController.text;
    String address = addressController.text;
    String age = ageController.text;
    String sex = sexController.text;
    String caste = casteController.text;
    String? voice = audioPath;
    String religion = religionController.text;
    String occupation = occupationController.text;
    String zoneid = zoneidController.text;
    String email = emailController.text;
    int count = 1 + (await DatabaseHelper.instance.getCountForZone(zoneid));
    String subjectID = "${zoneid}_$count";
    String filename = subjectID + ".jpg";
    String pathutil = path.join(documentDirectory.path, filename);
    print(pathutil);
    final te = await _image?.copy(pathutil);
    String image = filename;

    await DatabaseHelper.instance.insertSubject({
      'subject_id': subjectID,
      'SubjectName': subjectName,
      'SpouseName': spouseName,
      'ChildName': childName,
      'MaritalStatus': maritalStatus,
      'Village': village,
      'IDType': idType,
      'IDNumber': idNumber,
      'Mobile': mobile,
      'Address': address,
      'Age': age,
      'Sex': sex,
      'Caste': caste,
      'Image': image,
      'Voice': voice,
      'Religion': religion,
      'Occupation': occupation,
      'Zone_ID': zoneid,
      'Email': email,
      'upload_time': 0,
    });
    _clearFields();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Benificary Enrolled successfully'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormDataTablePage(
            village: village, nextPage: "service registration"),
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
    subjectNameController.clear();
    childNameController.clear();
    mobileController.clear();
    maritalStatusController.clear();
    villageController.clear();
    idTypeController.clear();
    idNumberController.clear();
    addressController.clear();
    spouseNameController.clear();
    ageController.clear();
    sexController.clear();
    casteController.clear();
    imageController.clear();
    voiceController.clear();
    religionController.clear();
    occupationController.clear();
    zoneidController.clear();
    emailController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficiary Enrollment Page'),
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
                    'Enroll New Beneficiary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFormField('Beneficiary Name', subjectNameController),
                  _buildFormField('Spouse Name', spouseNameController),
                  _buildFormField('Child Name', childNameController),
                  _buildFormField('Marital Status', maritalStatusController),
                  _buildFormField('Village', villageController),
                  _buildFormField('ID Type', idTypeController),
                  _buildFormField('ID Number', idNumberController),
                  _buildFormField('Mobile', mobileController,
                      keyboardType: TextInputType.phone),
                  _buildFormField('Address', addressController),
                  _buildFormField('Age', ageController,
                      keyboardType: TextInputType.number),
                  _buildFormField('Sex', sexController),
                  _buildFormField('Caste', casteController),
                  // _buildFormField('Image', imageController),
                  // _buildFormField('Voice', voiceController),
                  _buildFormField('Religion', religionController),
                  _buildFormField('Occupation', occupationController),
                  _buildFormField('Zone ID', zoneidController),
                  _buildFormField('Email', emailController,
                      keyboardType: TextInputType.emailAddress),
                  _image == null
                      ? const Text('No image selected.')
                      : Text('Image_${subjectNameController.text}'),
                  // Image.file(
                  //     _image!,
                  //     height: 100,
                  //     width: 100,
                  //   ),
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
                      addSubject();
                    },
                    icon: const Icon(Icons.person, size: 30),
                    label: const Text('Create Subject'),
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
