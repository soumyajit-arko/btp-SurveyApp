import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataUploadPage extends StatefulWidget {
  const DataUploadPage({super.key});

  @override
  State<DataUploadPage> createState() => _DataUploadPageState();
}

class _DataUploadPageState extends State<DataUploadPage> {
  String IP_Address = "10.5.29.229";
  String Port = "8080";
  @override
  void initState()  {
    super.initState();
    login();
  }
  // design1, user1
  Future<void> login() async {
    String url = "http://$IP_Address:$Port/api/user/login";
    Map<String, dynamic> payload = {
      "username": "user1",
      "password": "user1"
    };
    String jsonPayload = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonPayload,
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("response body : $json");
    } else {
      print('Error Connecting to the server : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data Upload'),
        ),
        body: Container());
  }
}
