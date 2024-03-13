import 'package:app_001/surveyor/family_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Survey {
  final String name;
  final String description;
  final String templateSource;
  final String sid;

  Survey({
    required this.name,
    required this.description,
    required this.templateSource,
    required this.sid,
  });
}

class FormField {
  final String name;
  final String attributeType;
  final String attributeUnit;
  final bool isRequired;

  FormField({
    required this.name,
    required this.attributeType,
    required this.attributeUnit,
    required this.isRequired,
  });
}

class Field {
  final String name;
  final String attributeType;
  final String attributeUnit;
  final bool isRequired;

  Field({
    required this.name,
    required this.attributeType,
    required this.attributeUnit,
    required this.isRequired,
  });
}

class DatabaseHelper {
  // Define the table names and column names
  static const String surveyProjectTable = 'survey_project';
  static const String fieldProjectTable = 'field_project';

  // Define column names for the survey_project table
  static const String surveyName = 'Name';
  static const String surveyId = 'sid';
  static const String creationDate = 'creation_date';
  static const String description = 'Description';
  static const String templateSource = 'template_source';

  // Define column names for the field_project table
  static const String fieldName = 'Name';
  static const String fieldId = 'fid';
  static const String surveyIdFk = 'sid';
  static const String attributeName = 'attribute_name';
  static const String attributeDatatype = 'attribute_datatype';
  static const String attributeUnit = 'attribute_unit';
  static const String requiredValue = 'required_value';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbpath = await getDatabasesPath();
    print('database path : $dbpath');
    String path = join(dbpath, 'storage1.db');
    print('final path : $path');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<bool> _isTableExists(Database db, String tableName) async {
    final result = await db.rawQuery('''
    SELECT name FROM sqlite_master WHERE type='table' AND name=?
  ''', [tableName]);
    return result.isNotEmpty;
  }

  Future<void> _createDb(Database db, int version) async {
    // await db.execute('''
    //   CREATE TABLE questions(
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     question TEXT,
    //     type TEXT,
    //     options TEXT
    //   )
    // ''');
    final tableExists = await _isTableExists(db, 'users');
    if (!tableExists) {
      await db.execute('''
      CREATE TABLE users (
        Name TEXT,
        Userid TEXT PRIMARY KEY,
        Password TEXT,
        Age INTEGER,
        Sex TEXT,
        Center_code TEXT,
        User_Type TEXT,
        Address TEXT,
        Mobile TEXT UNIQUE,
        Email TEXT UNIQUE,
        Instance_time TEXT
      )
    ''');

      await db.rawInsert('''
      INSERT INTO users (Name, Userid,Password, Age, Sex, Center_code, User_Type, Address, Mobile, Email, Instance_time)
      VALUES (?, ?, ?, ?, ?, ?, ?,?, ?, ?, CURRENT_TIMESTAMP)
    ''', [
        'admin',
        'admin123',
        'admin123',
        30,
        'Male',
        'Center123',
        'Admin',
        '123 Main St',
        '1234567890',
        'admin@example.com'
      ]);
      print('added user');
      await db.rawInsert('''
      INSERT INTO users (Name, Userid, Password,Age, Sex, Center_code, User_Type, Address, Mobile, Email, Instance_time)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,CURRENT_TIMESTAMP)
    ''', [
        'design_executive',
        'design123',
        'design123',
        35,
        'Female',
        'Center456',
        'Design Executive',
        '456 Elm St',
        '9876543210',
        'design@example.com'
      ]);
      print('added another user');
    }
// '''
//           CREATE TABLE survey_project (
//             Name TEXT,
//             sid TEXT PRIMARY KEY AUTOINCREMENT,
//             creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
//             Description TEXT,
//             template_source TEXT,
//             InstanceTIme TEXT
//           )
//         ''');
    final subjectExists = await _isTableExists(db, 'Subject');
    if (!subjectExists) {
      //beneficiary name - subject
      //marital status
      // village
      // id type - Voter ,AAdhar, Pan, Driving, Ration, Other-Card
      //and id number
      //
      await db.execute('''
          CREATE TABLE Subject (
            subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
            SubjectName TEXT, 
            SpouseName TEXT,
            ChildName TEXT,
            MaritalStatus TEXT,
            Village TEXT,
            IDType TEXT,
            IDNumber TEXT,
            Mobile TEXT,
            Address TEXT,
            Age INTEGER,
            Sex TEXT,
            Caste TEXT,
            Image TEXT,
            Voice TEXT,
            Religion Text,
            Occupation TEXT,
            Zone_ID TEXT,
            Email TEXT,
            Instance_time TIME DEFAULT CURRENT_TIME
          )
        ''');
      print('Created Subject');
    } else {
      print('Subject Already Exists');
    }
    final surveyProjectExists = await _isTableExists(db, 'survey_project');
    if (!surveyProjectExists) {
      await db.execute('''
          CREATE TABLE survey_project (
            Name TEXT,
            sid INTEGER PRIMARY KEY AUTOINCREMENT,
            creation_date DATE  DEFAULT CURRENT_DATE,
            Description TEXT,
            template_source TEXT,
            details_source TEXT,
            InstanceTime TIME DEFAULT CURRENT_TIME
          )
        ''');
      print('Created survey project');
    } else {
      print('survey_project Already Exists');
    }

    final fieldProjectExists = await _isTableExists(db, 'field_project');
    if (!fieldProjectExists) {
      await db.execute('''
          CREATE TABLE field_project (
            Name TEXT,
            fid INTEGER PRIMARY KEY AUTOINCREMENT,
            sid INTEGER,
            source_type INTEGER,
            attribute_name TEXT,
            attribute_datatype TEXT,
            attribute_unit TEXT,
            attribute_values TEXT,
            required_value INTEGER,
            InstanceTime TIME DEFAULT CURRENT_TIME,
            FOREIGN KEY (sid) REFERENCES survey_project(sid)
          )
        ''');
      print('created field_project');
    } else {
      print('field_project already exists');
    }
    final recordLogs = await _isTableExists(db, 'record_log');
    if (!recordLogs) {
      await db.execute('''
          CREATE TABLE record_log (
            rid INTEGER PRIMARY KEY AUTOINCREMENT,
            subject_id INTEGER,
            survey_datetime DATETIME,
            sid INTEGER,
            record_type INTEGER,
            survey_data TEXT,
            InstanceTime TIME DEFAULT CURRENT_TIME,
            FOREIGN KEY (sid) REFERENCES survey_project(sid),
            FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)

          )
        ''');
      print('created record_log');
    } else {
      print('record_log already exists');
    }
    final fieldEntryTable = await _isTableExists(db, 'field_entry');
    if (!fieldEntryTable) {
      await db.execute('''
          CREATE TABLE field_entry (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rid INTEGER,
            fid INTEGER,
            value TEXT,
            InstanceTime TIME DEFAULT CURRENT_TIME,
            FOREIGN KEY (rid) REFERENCES record_log(rid),
            FOREIGN KEY (fid) REFERENCES field_project(fid)
          )
        ''');
      print('created field_entry');
    } else {
      print('field_entry already exists');
    }
    final serviceEnrollment = await _isTableExists(db, 'service_enrollment');
    if (!serviceEnrollment) {
      await db.execute('''
          CREATE TABLE service_enrollment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            subject_id INTEGER,
            sid INTEGER,
            start_date TEXT,
            end_date TEXT,
            FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
            FOREIGN KEY (sid) REFERENCES survey_project(sid)
          )
        ''');
      print('created service_enrollment');
    } else {
      print('service_enrollment already exists');
    }
  }

  // Insert a new question
  Future<int> insertQuestion(Map<String, dynamic> question) async {
    final db = await database;
    return await db.insert('questions', question);
  }

  // Update an existing question
  Future<int> updateQuestion(
      int id, Map<String, dynamic> updatedQuestion) async {
    final db = await database;
    return await db
        .update('questions', updatedQuestion, where: 'id = ?', whereArgs: [id]);
  }

  // Delete a question
  Future<int> deleteQuestion(int id) async {
    final db = await database;
    return await db.delete('questions', where: 'id = ?', whereArgs: [id]);
  }

  // Retrieve all questions
  Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await database;
    return await db.query('questions');
  }

  Future<List<Map<String, Object?>>> getSubjectsValidForService(
      String serviceName) async {
    // Get current date
    final currentDate = DateTime.now().toIso8601String();
    // Open the database
    final db = await database;
    // Execute the query
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT Subject.*
    FROM Subject
    INNER JOIN service_enrollment ON Subject.subject_id = service_enrollment.subject_id
    INNER JOIN survey_project ON service_enrollment.sid = survey_project.sid
    WHERE survey_project.Name = ?
    AND service_enrollment.end_date > ?
  ''', [serviceName, currentDate]);

    return result;
  }

  Future<List<Map<String, Object?>>> getFamilyDetailsByFormAndVillage(
      String formName, String village) async {
    final db = await database;
    print('halo');
    final result = await db.rawQuery('''
    SELECT DISTINCT Subject.subject_id, Subject.SubjectName, Subject.ChildName, Subject.SpouseName, Subject.Mobile, service_enrollment.start_date, service_enrollment.end_date
    FROM Subject
    INNER JOIN service_enrollment ON Subject.subject_id = service_enrollment.subject_id
    INNER JOIN survey_project ON service_enrollment.sid = survey_project.sid
    WHERE survey_project.Name = ? AND Subject.Village = ? 
  ''', [formName, village]);
    print(result);
    return result;
  }

  Future<List<Map<String, Object?>>> getFamilyDetailsByServiceName(
      String formName) async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT Subject.subject_id, Subject.SubjectName, Subject.ChildName, Subject.SpouseName
    FROM Subject
    INNER JOIN service_enrollment ON Subject.subject_id = service_enrollment.subject_id
    INNER JOIN survey_project ON service_enrollment.sid = survey_project.sid
    WHERE survey_project.Name = ?
  ''', [formName]);

    return result;
  }

  Future<List<String>> getValidServicesForSubject(String subjectId) async {
    // Get current date
    final currentDate = DateTime.now().toIso8601String();
    print('current Date : $currentDate');
    // Open the database
    final db = await database;
    // Execute the query
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT service_enrollment.*, survey_project.Name
    FROM service_enrollment
    INNER JOIN survey_project ON service_enrollment.sid = survey_project.sid
    WHERE service_enrollment.subject_id = ?
    AND service_enrollment.end_date > ?
  ''', [subjectId, currentDate]);
    print('maps : $maps');
    Set<String> uniqueProjectNames = {};
    for (Map<String, dynamic> map in maps) {
      uniqueProjectNames.add(map['Name'] as String);
    }
    List<String> names = [];
    for (String s in uniqueProjectNames) {
      names.add(s);
    }
    return names;
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    final db = await database;

    // Replace 'users' with the actual name of your users table
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'Userid = ? AND Password = ?',
      whereArgs: [username, password],
    );

    if (users.isNotEmpty) {
      // Return the first user (assuming usernames are unique)
      return users.first;
    } else {
      return null; // User not found
    }
  }

  Future<bool> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      await db.insert('users', user);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> insertSubject(Map<String, dynamic> subject) async {
    final db = await database;
    return await db.insert('Subject', subject);
  }

  Future<int> insertForm(Map<String, dynamic> form_) async {
    final db = await database;
    print('inserted');
    return await db.insert('survey_project', form_);
  }

  Future<int> insertFieldEntry(Map<String, dynamic> fieldEntry) async {
    final db = await database;
    print('inserted entry');
    return await db.insert('field_entry', fieldEntry);
  }

  Future<int> insertField(Map<String, dynamic> value) async {
    final db = await database;
    print('field inserted');
    print(value);
    return await db.insert('field_project', value);
  }

  Future<int> insertResponse(Map<String, dynamic> response) async {
    final db = await database;
    print('response inserted');
    print(response);
    return await db.insert('record_log', response);
  }

  Future<int> insertServiceEnrollment(Map<String, dynamic> response) async {
    final db = await database;
    print('service enrolled');
    print(response);
    return await db.insert('service_enrollment', response);
  }

  Future<List<Map<String, dynamic>>> getFields() async {
    final db = await database;
    return await db.query('field_project');
  }

  Future<List<Map<String, dynamic>>> getSubjects() async {
    final db = await database;
    return await db.query('Subject');
  }

  // Future<List<Map<String, dynamic>>> getResponses() async {
  //   final db = await database;
  //   return await db
  //       .query('record_log', where: 'record_type = ?', whereArgs: [0]);
  // }

  Future<List<Map<String, dynamic>>> getResponses() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT s.SubjectName, s.Mobile, s.Village,s.Age, sp.Name AS FormName, rl.*
    FROM record_log rl
    INNER JOIN survey_project sp ON rl.sid = sp.sid
    INNER JOIN Subject s ON rl.subject_id = s.subject_id
    WHERE rl.record_type = 0
  ''');
  }

  Future<String> getSidByName(String name) async {
    final db = await database;
    final result = await db.query(
      'survey_project',
      columns: ['sid'],
      where: 'Name = ?',
      whereArgs: [name],
    );
    // Return the sid as a String
    return result.first['sid'].toString();
  }

  Future<String> getridBysubjectIDandDatetime(
      int subjectID, DateTime currTime) async {
    final db = await database;
    final formattedDatetime = currTime.toUtc().toIso8601String();
    print("${currTime.runtimeType}");
    print(currTime);
    final result = await db.query(
      'record_log',
      columns: ['rid'],
      where: 'subject_id = ? AND survey_datetime = ?',
      whereArgs: [subjectID, formattedDatetime],
    );
    // Return the sid as a String
    return result.first['rid'].toString();
  }

  Future<String> getfidBysidandAttributeName(
      int sid, String attribute_name) async {
    final db = await database;
    final result = await db.query(
      'field_project',
      columns: ['fid'],
      where: 'sid = ? AND attribute_name = ?',
      whereArgs: [sid, attribute_name],
    );
    // Return the sid as a String
    return result.first['fid'].toString();
  }

  Future<String> getsubjectIDByName(FamilyDetails? familyDetails) async {
    final db = await database;

    final result = await db.query(
      'Subject',
      columns: ['subject_id'],
      where: 'SubjectName = ? AND ChildName =? AND SpouseName = ?',
      whereArgs: [
        familyDetails?.subjectName,
        familyDetails?.spouseName,
        familyDetails?.childName
      ],
    );
    // Return the sid as a String
    return result.first['subject_id'].toString();
  }
  // Future<String> getsubjectIDByName(String? name) async {
  //   final db = await database;
  //   final result = await db.query(
  //     'Subject',
  //     columns: ['subject_id'],
  //     where: 'Name = ?',
  //     whereArgs: [name],
  //   );
  //   // Return the sid as a String
  //   return result.first['subject_id'].toString();
  // }

  Future<List<String>> getSubjectNames() async {
    final db = await database;
    final result = await db.query(
      'Subject',
      columns: ['SubjectName'],
    );
    print(result);
    // Extract the 'Name' values from the result and store them in a list
    final names = result.map((row) => row['Name'].toString()).toList();
    print(names);
    return names;
  }

  // Future<List<Map<String, String>>> getSubjectNames() async {
  //   // Replace this with the actual implementation to fetch data from the database
  //   final db = await database;
  //   final result = await db.query('Subject', columns: [
  //     'MotherNameBeneficiary',
  //     'ChildNameBeneficiary',
  //     'HusbandName'
  //   ]);
  //   print(result);
  //   final names = result.map((e) => null)
  //   return List.generate(
  //     100,
  //     (index) => {
  //       'motherName': 'Mother Name $index',
  //       'childName': 'Child Name $index',
  //       'husbandName': 'Husband Name $index',
  //     },
  //   );
  // }
  Future<List<Map<String, Object?>>> getFamilyDetails() async {
    final db = await database;
    final result = await db.query('Subject',
        columns: ['subject_id', 'SubjectName', 'ChildName', 'SpouseName']);
    return result;
  }

  Future<List<Map<String, Object?>>> getFamilyDetailsbyVillage(
      String village) async {
    final db = await database;
    final result = await db.query(
      'Subject',
      columns: [
        'subject_id',
        'SubjectName',
        'ChildName',
        'SpouseName',
        'Mobile'
      ],
      where: 'Village = ?',
      whereArgs: [village],
    );
    print('village memebers : $result');
    return result;
  }

  Future<List<Map<String, Object?>>> getVillageNames() async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT DISTINCT Village FROM Subject
  ''');
    print('villages : $result');
    return result;
  }

  Future<List<String>> getFormsNames() async {
    final db = await database;
    final result = await db.query(
      'survey_project',
      columns: ['Name'],
    );
    print(result);
    // Extract the 'Name' values from the result and store them in a list
    final names = result.map((row) => row['Name'].toString()).toList();
    print(names);
    return names;
  }

  Future<List<Map<String, dynamic>>> getFormWithName(String? name) async {
    final db = await database;
    final result = await db.query(
      'survey_project',
      where: 'Name = ?',
      whereArgs: [name],
    );
    print('The result is ');
    print(result);
    return result;
  }

  // Future<List<String>> getServicesEnrolledByID(
  //     String? subjectID) async {
  //   final db = await database;
  //   final result = await db.query(
  //     'service_enrollment',
  //     where: 'subject_id=?',
  //     whereArgs: [subjectID],
  //   );
  //   final names = result.map((row) => row['Name'].toString()).toList();
  //   print(names);
  //   return names;
  // }
  Future<List<String>> getServicesEnrolledByID(String subjectId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT survey_project.Name
    FROM survey_project
    INNER JOIN service_enrollment ON survey_project.sid = service_enrollment.sid
    WHERE service_enrollment.subject_id = ?
  ''', [subjectId]);

    List<String> projectNames = [];
    for (Map<String, dynamic> map in maps) {
      projectNames.add(map['Name'] as String);
    }

    return projectNames;
  }

  Future<List<String>> getUniqueServicesEnrolledByID(String subjectId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT DISTINCT survey_project.Name
    FROM survey_project
    INNER JOIN service_enrollment ON survey_project.sid = service_enrollment.sid
    WHERE service_enrollment.subject_id = ?
  ''', [subjectId]);

    Set<String> uniqueProjectNames = {};
    for (Map<String, dynamic> map in maps) {
      uniqueProjectNames.add(map['Name'] as String);
    }
    List<String> names = [];
    for (String s in uniqueProjectNames) {
      names.add(s);
    }
    return names;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getForms() async {
    final db = await database;
    return await db.query('survey_project');
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final db = await database;
    final users = await db.query(
      'users',
      where: 'Userid = ?',
      whereArgs: [userId],
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<int> updateUser(
      String userId, Map<String, dynamic> updatedUser) async {
    final db = await database;
    return await db.update(
      'users',
      updatedUser,
      where: 'Userid = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteUser(String userId) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'Userid = ?',
      whereArgs: [userId],
    );
  }

  Future<void> deleteDatabaseUtil() async {
    String path = join(await getDatabasesPath(), 'storage1.db');

    // Delete the database file
    await deleteDatabase(path);
    path = join(await getDatabasesPath(), 'storage1.db');
    await deleteDatabase(path);
    print('deleted database successfully');
  }
}
