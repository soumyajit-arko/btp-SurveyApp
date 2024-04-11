import 'dart:io';
import 'package:app_001/designExecutive/design_executive_util_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'backend/database_helper.dart';
import 'surveyor/survery_page_util.dart';
import 'admin/admin_page_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:footer/footer.dart';
// import 'package:footer/footer_view.dart';

class LoginPage extends StatefulWidget {
  static String jwtToken = "";
  static String userId = "";
  static String username = "";
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
  // List<String> logs = []; // List to store logs

  @override
  void initState() {
    super.initState();
    setState(() {
      LoginPage.jwtToken = "";
      LoginPage.userId = "";
      LoginPage.username = "";
      // pages = [];
      // HamburgerMenu.pageTitles = ['Home', 'Log out'];
    });
    // util();
    // copyImageToApplicationDirectory();
    // copyAudioToApplicationDirectory();
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
    const int timeoutDuration = 10;

    try {
      // Log message before API call
      // logMessage('Attempting login...');
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonPayload,
      ).timeout(Duration(seconds: timeoutDuration));

      if (response.statusCode == 200) {
        // logMessage('Login successful!');

        var json = jsonDecode(response.body);
        String userType = "";
        setState(() {
          LoginPage.jwtToken = json["jwtToken"];
          LoginPage.userId = json["userid"];
          LoginPage.username = json["name"];
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
              MaterialPageRoute(
                  builder: (context) => DesignExecutiveUtilPage()),
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
          // logMessage('Problem Connecting to the server!!!');

          // print('Login failed. User not found.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect credentials!!!'),
            ),
          );
        }
      } else {
        // logMessage('Cannot login bruh!!!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Problem Connecting to the server!!!'),
          ),
        );
        // print('Error Connecting to the server : ${response.statusCode}');
      }
    } catch (e) {
      // logMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> util() async {
    final db = DatabaseHelper.instance;
    await db.upadteImage('zone1_4');
  }

  Future<void> copyImageToApplicationDirectory() async {
    // Get the directory for storing application files
    Directory appDir = await getApplicationDocumentsDirectory();

    // Define the source and destination paths
    String assetsImagePath = 'assets/images/p4.jpg';
    String destinationImagePath = '${appDir.path}/zone1_4.jpg';
    // print(destinationImagePath);
    try {
      // Load the image byte data from assets
      ByteData imageBytes = await rootBundle.load(assetsImagePath);
      List<int> byteList = imageBytes.buffer.asUint8List();

      // Write the image byte data to a file in the application directory
      File(destinationImagePath).writeAsBytes(byteList);

      // /data/user/0/com.example.app_001/app_flutter/null
      print('Image copied successfully to application directory.');
    } catch (e) {
      print('Error copying image: $e');
    }
  }

  Future<void> copyAudioToApplicationDirectory() async {
    // Get the directory for storing application files
    Directory appDir = await getApplicationDocumentsDirectory();

    // Define the source and destination paths
    String assetsAudioPath = 'assets/images/p6.mp3';
    String destinationAudioPath = '${appDir.path}/zone1_6.mp3';
    // print(destinationAudioPath);
    try {
      // Load the image byte data from assets
      ByteData audioBytes = await rootBundle.load(assetsAudioPath);
      List<int> byteList = audioBytes.buffer.asUint8List();

      // Write the image byte data to a file in the application directory
      File(destinationAudioPath).writeAsBytes(byteList);

      // /data/user/0/com.example.app_001/app_flutter/null
      print('Audio copied successfully to application directory.');
    } catch (e) {
      print('Error copying image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: HamburgerMenu(
      //   userName: 'userName',
      //   email: 'email',
      //   pages: [
      //     SurveyorPageUtil(),
      //     LoginPage(),
      //     NetworkSpeedChecker(),
      //   ],
      //   icons: [
      //     Icons.home,
      //     Icons.logout,
      //     Icons.network_cell_rounded,
      //   ],
      //   pageTitles: ['Home', 'Log out', 'Bandwidth'],
      // ),
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
        // actions: [
        //   IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_back_rounded)),
        // ],
        // leading: Icon(Icons.mail),
      ),

      body:
          //  new FooterView(
          // children: <Widget>[
          SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Matri Karuna',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  color: Colors.blue,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2.5, 2.5),
                      blurRadius: 3.0,
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                    // Shadow(
                    //   offset: Offset(10.0, 10.0),
                    //   blurRadius: 8.0,
                    //   color: Color.fromARGB(125, 0, 0, 255),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Image.asset(
                  'assets/images/imlogo.jpg',
                  // width: 190,
                  height: 200,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 300,
                height: 300,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'saMiX Login',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
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
                                prefixIcon: IconButton(
                                    onPressed: () {}, icon: Icon(Icons.person)),
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
                                prefixIcon: IconButton(
                                    onPressed: () {}, icon: Icon(Icons.key)),
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
              SizedBox(
                height: 130,
              ),
              // Align(
              // alignment: Alignment.center,
              // child:
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Developed and designed at -\n Computer Science & Engineering Department, IIT Kharagpur",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  // "Developed and designed at -\n Computer Science & Engineering Department, IIT Kharagpur\n Contact: Prof. Jayanta Mukhopadhyay, jay@cse.iitkgp.ac.in, \nPhone: +91-3222-283484",style: TextStyle(fontSize: 13),textAlign: TextAlign.center,),
                ),
              ),
              // Display logs
              // SizedBox(height: 20),
              // Container(
              //   width: 300,
              //   height: 150,
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: ListView.builder(
              //     itemCount: logs.length,
              //     itemBuilder: (context, index) {
              //       return Text(logs[index]);
              //     },
              //   ),
              // ),
              // ),
            ],
          ),
        ),
      ),
      // ],
      // footer: new Footer(
      // child: Padding(
      // padding: new EdgeInsets.all(10.0),
      // child: Text('Developed and designed at Computer Science & Engineering Department, IIT Kharagpur Contact: Prof. Jayanta Mukhopadhyay, jay@cse.iitkgp.ac.in, Phone: +91-3222-283484',style: TextStyle(color: Colors.black),)),
      // ),
      // flex: 1),
    );
  }

  // // Function to append log message to logs list
  // void logMessage(String message) {
  //   setState(() {
  //     logs.add(message);
  //   });
  // }
}
