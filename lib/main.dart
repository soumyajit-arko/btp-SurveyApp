// import 'package:app_001/surveyor/form_selection_survey.dart';
// import 'package:app_001/surveyor/subject_selection_survey.dart';
import 'package:app_001/admin/admin_page_util.dart';
import 'package:app_001/surveyor/data_upload_page.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'login_page.dart';
import 'backend/database_helper.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './log/logger.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  log.info('Started the APP');

  final dbHelper = DatabaseHelper.instance;
  // dbHelper.deleteDatabaseUtil();
  dbHelper.initDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      // home: 
      // home: DataUploadPage(),
      home: LoginPage(),
      // home: FamilyDataTablePage(),
      // home: FormDataTablePage(),
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