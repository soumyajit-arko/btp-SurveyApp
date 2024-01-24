import 'package:app_001/design_executive_util_page.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper
import 'survery_page_util.dart';
import 'admin_page_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedUserType;
  List<String> userTypes = [
    'Admin',
    'Center Admin',
    'Surveyor',
    'Design Executive'
  ];

  void handleLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    final databaseHelper = DatabaseHelper.instance;


    final user =
        await databaseHelper.getUser(username, password, selectedUserType);

    if (user != null) {
      // User exists
      print('Login successful for user: ${user['Name']}');


      if (selectedUserType == 'Admin') {
        // Navigate to the AdminPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPageUtil()),
        );
      }
      //else if (selectedUserType == 'Center Admin') {
      //   // Navigate to the CenterAdminPage
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => CenterAdminPage()),
      //   );
      // }
      else if (selectedUserType == 'Surveyor') {
        // Navigate to the SurveyorPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SurveyorPageUtil()),
        );
      } else if (selectedUserType == 'Design Executive') {
        // Navigate to the DesignExecutivePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DesignExecutiveUtilPage()),
        );
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect credentials!!!'),
          ),
        );
      }
    } else {
     
      print('Login failed. User not found.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect credentials!!!'),
        ),
      );
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
                'SURVEY PROJECT', 
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/images/login_bg.png',
                width: 450,
                height: 250,
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text('Select User Type'),
                value: selectedUserType,
                items: userTypes.map((String userType) {
                  return DropdownMenuItem<String>(
                    value: userType,
                    child: Text(userType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUserType = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 40,
                child: Row(
                  children: [
                    // const Text('Username\t\t'),
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
                    // const Text('Password\t\t'),
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
