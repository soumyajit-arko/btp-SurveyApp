import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';

import '../backend/database_helper.dart';
import '../login_page.dart';

class SubjectRegisterPage extends StatefulWidget {
  @override
  _SubjectRegisterPageState createState() => _SubjectRegisterPageState();
}

class _SubjectRegisterPageState extends State<SubjectRegisterPage> {
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController ageController = TextEditingController();
  // final TextEditingController sexController = TextEditingController();
  // final TextEditingController occupationController = TextEditingController();
  // final TextEditingController zoneIDController = TextEditingController();
  // final TextEditingController addressController = TextEditingController();
  // final TextEditingController mobileController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController idTypeController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();

  // final TextEditingController initialDateController = TextEditingController();
  // final TextEditingController finalDateController = TextEditingController();
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
  void addSubject() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String filename = subjectNameController.text + ".jpg";
    String pathutil = path.join(documentDirectory.path, filename);
    final te = await _image?.copy(pathutil);
    // _image.
    print(te);
    print('done');
    String subjectName = subjectNameController.text;
    String spouseName = spouseNameController.text;
    String childName = childNameController.text;
    String maritalStatus = maritalStatusController.text;
    String village = villageController.text;
    String idType = idTypeController.text;
    String idNumber = idNumberController.text;
    String mobile = mobileController.text;
    // String initialDate = initialDateController.text;
    // String finalDate = finalDateController.text;
    String address = addressController.text;
    String age = ageController.text;
    String sex = sexController.text;
    String caste = casteController.text;
    String image = filename;
    // String voice = voiceController.text;
    String religion = religionController.text;
    String occupation = occupationController.text;
    String zoneid = zoneidController.text;
    String email = emailController.text;

    await DatabaseHelper.instance.insertSubject({
      'SubjectName': subjectName,
      'SpouseName': spouseName,
      'ChildName': childName,
      'MaritalStatus': maritalStatus,
      'Village': village,
      'IDType': idType,
      'IDNumber': idNumber,
      'Mobile': mobile,
      // 'InitialDate': initialDate,
      // 'FinalDate': finalDate,
      'Address': address,
      'Age': age,
      'Sex': sex,
      'Caste': caste,
      'Image': image,
      'Voice': '',
      'Religion': religion,
      'Occupation': occupation,
      'Zone_ID': zoneid,
      'Email': email,
    });
    _clearFields();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Benificary Enrolled successfully'),
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
    // initialDateController.clear();
    // finalDateController.clear();
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
                  // _buildDateSelector('Initial Date', initialDateSelected,
                  //     (DateTime date) {
                  //   setState(() {
                  //     initialDateSelected = date;
                  //   });
                  // }, initialDateController),
                  // _buildDateSelector('Final Date', finalDateSelected,
                  //     (DateTime date) {
                  //   setState(() {
                  //     finalDateSelected = date;
                  //   });
                  // }, finalDateController),

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
                      : Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                        ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: _getImage,
                  //   child: Text('Pick Image'),
                  // ),
                  ElevatedButton(
                    // onPressed: () async {
                    //   await availableCameras().then((value) => Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (_) => CameraPage(cameras: value))));
                    // },
                    onPressed: _getImageFromCamera,
                    child: const Text("Take a Picture"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: addSubject,
                    icon: const Icon(Icons.person, size: 30),
                    label: const Text('Create Subject'),
                  ),
                  // ElevatedButton(onPressed: tempFun, child: Text('Temp')),
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => LoginPage(),
          //         ),
          //       );
          //     },
          //     icon: Icon(Icons.logout, size: 30),
          //     label: Text('Logout'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
