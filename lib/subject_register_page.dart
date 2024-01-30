import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'login_page.dart';

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
  final TextEditingController motherNameBeneficiaryController =
      TextEditingController();
  final TextEditingController childNameBeneficiaryController =
      TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController initialDateController = TextEditingController();
  final TextEditingController finalDateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController husbandNameController = TextEditingController();
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
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
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
    String motherNameBeneficiary = motherNameBeneficiaryController.text;
    String childNameBeneficiary = childNameBeneficiaryController.text;
    String mobile = mobileController.text;
    String initialDate = initialDateController.text;
    String finalDate = finalDateController.text;
    String address = addressController.text;
    String husbandName = husbandNameController.text;
    String age = ageController.text;
    String sex = sexController.text;
    String caste = casteController.text;
    // String image = imageController.text;
    // String voice = voiceController.text;
    String religion = religionController.text;
    String occupation = occupationController.text;
    String zoneid = zoneidController.text;
    String email = emailController.text;

    await DatabaseHelper.instance.insertSubject({
      'MotherNameBeneficiary': motherNameBeneficiary,
      'ChildNameBeneficiary': childNameBeneficiary,
      'Mobile': mobile,
      'InitialDate': initialDate,
      'FinalDate': finalDate,
      'Address': address,
      'HusbandName': husbandName,
      'Age': age,
      'Sex': sex,
      'Caste': caste,
      'Image': '',
      'Voice': '',
      'Religion': religion,
      'Occupation': occupation,
      'Zone_ID': zoneid,
      'Email': email,
    });
  }

  void _clearFields() {
    motherNameBeneficiaryController.clear();
    childNameBeneficiaryController.clear();
    mobileController.clear();
    initialDateController.clear();
    finalDateController.clear();
    addressController.clear();
    husbandNameController.clear();
    ageController.clear();
    sexController.clear();
    casteController.clear();
    imageController.clear();
    voiceController.clear();
    religionController.clear();
    occupationController.clear();
    zoneidController.clear();
    emailController.clear();
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

  DateTime initialDateSelected = DateTime.now();
  DateTime finalDateSelected = DateTime.now();

  Widget _buildDateSelector(String labelText, DateTime selectedDate,
      Function(DateTime) onDateSelected, TextEditingController dateController) {
    if (selectedDate != null) {
      dateController.text = _formatDate(selectedDate);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                child: Text(
                  labelText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                      context, selectedDate, onDateSelected, dateController),
                  decoration: InputDecoration(
                    hintText: 'Select Date',
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

  Future<void> _selectDate(
      BuildContext context,
      DateTime selectedDate,
      Function(DateTime) onDateSelected,
      TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
      controller.text = _formatDate(pickedDate);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Registration Page'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Create a New Subject',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildFormField(
                      'Mother\'s Name', motherNameBeneficiaryController),
                  _buildFormField(
                      'Child\'s Name', childNameBeneficiaryController),
                  _buildFormField('Mobile', mobileController,
                      keyboardType: TextInputType.phone),
                  // _buildFormField('Initial Date', initialDateController,
                  //     keyboardType: TextInputType.datetime),
                  // Text(
                  //   "Selected Date: ${_formatDate(initialDateSelected)}", // Format the date as a string
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () => _selectDate(context),
                  //   child: Text('Select Date'),
                  // ),
                  _buildDateSelector('Initial Date', initialDateSelected,
                      (DateTime date) {
                    setState(() {
                      initialDateSelected = date;
                    });
                  }, initialDateController),
                  _buildDateSelector('Final Date', finalDateSelected,
                      (DateTime date) {
                    setState(() {
                      finalDateSelected = date;
                    });
                  }, finalDateController),

                  _buildFormField('Address', addressController),
                  _buildFormField('Husband\'s Name', husbandNameController),
                  _buildFormField('Age', ageController,
                      keyboardType: TextInputType.number),
                  _buildFormField('Sex', sexController),
                  _buildFormField('Caste', casteController),
                  _buildFormField('Image', imageController),
                  _buildFormField('Voice', voiceController),
                  _buildFormField('Religion', religionController),
                  _buildFormField('Occupation', occupationController),
                  _buildFormField('Zone ID', zoneidController),
                  _buildFormField('Email', emailController,
                      keyboardType: TextInputType.emailAddress),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                        ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getImage,
                    child: Text('Pick Image'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: addSubject,
                    icon: Icon(Icons.person, size: 30),
                    label: Text('Create Subject'),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout, size: 30),
              label: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
