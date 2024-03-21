import 'package:app_001/designExecutive/design_executive_util_page.dart';
import 'package:flutter/material.dart';
import 'backend/database_helper.dart'; // Import your database helper
import 'surveyor/survery_page_util.dart';
import 'admin/admin_page_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static String jwtToken = "";
  static String userId = "";
  static String protocol = "http";
  // static String domainName = "csjitsi.iitkgp.ac.in";
  static String domainName = "10.5.29.229:8080";
  // static String IP_Address = "10.5.29.229";
  // static String Port = "8080";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // String? userType;

  @override
  void initState() {
    super.initState();
    setState(() {
      LoginPage.jwtToken = "";
      LoginPage.userId = "";
    });
  }

  void handleLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // final databaseHelper = DatabaseHelper.instance;

    // final user = await databaseHelper.getUser(username, password);
    String url =
        "${LoginPage.protocol}://${LoginPage.domainName}/api/user/login";
    print(url);
    Map<String, dynamic> payload = {"username": username, "password": password};
    String jsonPayload = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonPayload,
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      String userType = "";
      setState(() {
        LoginPage.jwtToken = json["jwtToken"];
        LoginPage.userId = json["userid"];
        userType = json["type"];
      });
      print("response body : $json");
      if (userType != "") {
        if (userType == 'adm') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPageUtil()),
          );
          print('logging in as adm');
        } else if (userType == 'svy') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SurveyorPageUtil()),
          );
          print('logging in as svy');
        } else if (userType == 'dex') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DesignExecutiveUtilPage()),
          );
          print('logging in as dex');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot Login!!!'),
            ),
          );
        }
      } else {
        // print('Login failed. User not found.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect credentials!!!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Problem Connecting to the server!!!'),
        ),
      );
      // print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'SERVICE PROJECT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/images/bg2.jpeg',
                width: 450,
                height: 250,
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 200,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleLogin,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
