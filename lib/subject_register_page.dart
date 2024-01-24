import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'login_page.dart';

class SubjectRegisterPage extends StatefulWidget {
  @override
  _SubjectRegisterPageState createState() => _SubjectRegisterPageState();
}

class _SubjectRegisterPageState extends State<SubjectRegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController zoneIDController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
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

  void addSubject() async {
    String name = nameController.text;

    int age = int.tryParse(ageController.text) ?? 0;
    String sex = sexController.text;
    String zoneID = zoneIDController.text;
    String occupation = occupationController.text;

    String address = addressController.text;
    String mobile = mobileController.text;
    String email = emailController.text;

    await DatabaseHelper.instance.insertSubject({
      'Name': name,
      'Age': age,
      'Sex': sex,
      'Zone_ID': zoneID,
      'Occupation': occupation,
      'Address': address,
      'Mobile': mobile,
      'Email': email
    });

    _clearFields();
  }

  void _clearFields() {
    nameController.clear();

    ageController.clear();
    sexController.clear();
    zoneIDController.clear();
    occupationController.clear();

    addressController.clear();
    mobileController.clear();
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

  Widget _buildFormField(String labelText, TextEditingController controller,
    {TextInputType? keyboardType}) {
  return Container(
    margin: EdgeInsets.only(left: 380,bottom: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, // Adjust the width according to your preference
              child: Text(
                labelText,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(width: 20), // Adjust the space between label and text field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 380.0), // Adjust the horizontal padding
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: 'Enter $labelText',
                    border: OutlineInputBorder(),
                  ),
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
                  _buildFormField('Name', nameController),
                  _buildFormField('Age', ageController,
                      keyboardType: TextInputType.number),
                  _buildFormField('Sex', sexController),
                  _buildFormField('Zone ID', zoneIDController),
                  _buildFormField('Occupation', occupationController),
                  _buildFormField('Address', addressController),
                  _buildFormField('Mobile', mobileController,
                      keyboardType: TextInputType.phone),
                  _buildFormField('Email', emailController),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!,height: 100,width: 100,),
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
