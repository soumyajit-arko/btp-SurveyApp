import 'package:flutter/material.dart';
import 'login_page.dart';
import 'database_helper.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  final dbHelper = DatabaseHelper.instance;
  dbHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
/*
reset password
gender drop down
Age from 1 to 150
mobile - only number 10 digits
template source - button to display

 */