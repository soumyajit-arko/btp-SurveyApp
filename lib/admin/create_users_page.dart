// Existing imports
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../backend/database_helper.dart';
import 'package:intl/intl.dart';
import '../login_page.dart';

class CreateUsersPage extends StatefulWidget {
  @override
  _CreateUsersPageState createState() => _CreateUsersPageState();
}

class _CreateUsersPageState extends State<CreateUsersPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController centerCodeController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<Map<String, dynamic>> users = [];

 

  @override
  void initState() {
    super.initState();
  }

  void addUser() async {
    String name = nameController.text;
    String userId = userIdController.text;
    String password = passwordController.text;
    int age = int.tryParse(ageController.text) ?? 0;
    String sex = sexController.text;
    String centerCode = centerCodeController.text;
    String userType = userTypeController.text;
    String address = addressController.text;
    String mobile = mobileController.text;
    String email = emailController.text;
    dynamic currentTime = DateFormat.jm().format(DateTime.now());

    final result = await DatabaseHelper.instance.insertUser({
      'Name': name,
      'Userid': userId,
      'Password': password,
      'Age': age,
      'Sex': sex,
      'Center_code': centerCode,
      'User_Type': userType,
      'Address': address,
      'Mobile': mobile,
      'Email': email,
      'Instance_time': currentTime,
    });

    print('result is : ');
    print(result);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User added successfully'),
        ),
      );

      // Clear text fields
      _clearFields();
      // print('Done');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add user. Userid already exists.'),
        ),
      );
    }
  }

  void _clearFields() {
    nameController.clear();
    userIdController.clear();
    passwordController.clear();
    ageController.clear();
    sexController.clear();
    centerCodeController.clear();
    userTypeController.clear();
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
        onChanged: (text) {
          if (text != '' &&
              keyboardType == TextInputType.number &&
              int.tryParse(text) == null) {
            // Show a Snackbar error message if input is not a number
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter a valid number'),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Create a New User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildSmallTextField(nameController, 'Name'),
                  SizedBox(height: 10),

                  _buildSmallTextField(userIdController, 'User ID'),
                  SizedBox(height: 10),
                  _buildSmallTextField(passwordController, 'Password'),
                  SizedBox(height: 10),
                  _buildSmallTextField(ageController, 'Age',
                      keyboardType: TextInputType.number),
                  SizedBox(height: 10),
                  _buildSmallTextField(sexController, 'Sex'),
                  SizedBox(height: 10),
                  _buildSmallTextField(centerCodeController, 'Center Code'),
                  SizedBox(height: 10),
                  _buildSmallTextField(userTypeController, 'User Type'),
                  SizedBox(height: 10),
                  _buildSmallTextField(addressController, 'Address'),
                  SizedBox(height: 10),
                  _buildSmallTextField(mobileController, 'Mobile',
                      keyboardType: TextInputType.phone),
                  SizedBox(height: 10),
                  _buildSmallTextField(emailController, 'Email'),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: addUser,
                    icon: Icon(Icons.person, size: 30), // Add a user icon
                    label: Text('Create User'),
                  ),
                  
                  // Display Users button (same as before)
                ],
              ),
            ),
          ),
          Positioned(
            top: 10, // Adjust top position as needed
            right: 10, // Adjust right position as needed
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout, size: 30), // Add a logout icon
              label: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
