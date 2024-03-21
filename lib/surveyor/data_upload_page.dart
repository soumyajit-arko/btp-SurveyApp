import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataUploadPage extends StatefulWidget {
  const DataUploadPage({super.key});

  @override
  State<DataUploadPage> createState() => _DataUploadPageState();
}

class _DataUploadPageState extends State<DataUploadPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                
              },
              child: Text('Upload new Beneficiaries'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                
              },
              child: Text('Upload responses'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                
              },
              child: Text('Upload service enrollment'),
            ),
            SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
}
