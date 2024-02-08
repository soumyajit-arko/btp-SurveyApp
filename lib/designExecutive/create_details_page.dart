import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
import 'dart:convert';

class CreateDetailsPage extends StatefulWidget {
  final String formName;
  final String formDescription;
  final List<Map<String, dynamic>> questions;
  CreateDetailsPage(this.formName, this.formDescription, this.questions,
      {super.key});

  @override
  State<CreateDetailsPage> createState() => _CreateDetailsPageState();
}

class _CreateDetailsPageState extends State<CreateDetailsPage> {
  // Questions
  List<Map<String, dynamic>> details = [];
  String? selectedType = 'Single Choice';
  List<String> options = [];
  TextEditingController questionController = TextEditingController();
  TextEditingController attributeUnitController = TextEditingController();
  bool isRequired = false;
  TextEditingController optionController = TextEditingController();
  List<TextEditingController> optionControllers = [];

  void init() {
    super.initState();
    DatabaseHelper.instance.initDatabase();
  }

  Map<String, dynamic> deepCopyQuestion(Map<String, dynamic> originalQuestion) {
    return {
      'question': originalQuestion['question'],
      'type': originalQuestion['type'],
      'unit': originalQuestion['unit'],
      'options': originalQuestion['options'],
      'required': originalQuestion['required']
    };
  }

  void addQuestion() {
    if (questionController.text.isNotEmpty) {
      final question = {
        'question': questionController.text,
        'type': selectedType,
        'unit': attributeUnitController.text,
        'options': options.join(','),
        'required': isRequired ? 1 : 0
      };
      Map<String, dynamic> q = deepCopyQuestion(question);
      setState(() {
        details.add(q);
        questionController.clear();
        optionControllers.clear();
        options.clear();
        isRequired = false;
        attributeUnitController.clear();
        optionControllers.add(TextEditingController());
      });
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    optionController.dispose();
    super.dispose();
  }

  void _clearFields() async {
    details.clear();
  }

  Widget _buildSmallTextField(
      TextEditingController controller, String labelText) {
    return Container(
      width: 300, // Set the desired width
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void createForm() async {
      String formName = widget.formName;
      String description = widget.formDescription;
      String template = json.encode(widget.questions);
      String details_source = json.encode(details);

      await DatabaseHelper.instance.insertForm({
        'Name': formName,
        'Description': description,
        'template_source': template,
        'details_source': details_source,
      });
      final sid = await DatabaseHelper.instance.getSidByName(formName);
      print('sid : ');
      print(sid);
      int sid_int = int.parse(sid);
      for (int i = 0; i < details.length; ++i) {
        final Map<String, dynamic> element = details[i];
        await DatabaseHelper.instance.insertField({
          'Name': formName,
          'sid': sid_int,
          'source_type': 1,
          'attribute_name': element['question'],
          'attribute_datatype': element['type'],
          'attribute_unit': element['unit'],
          'attribute_values': element['options'],
          'required_value': element['required'],
        });
      }
      for (int i = 0; i < widget.questions.length; ++i) {
        final Map<String, dynamic> element = widget.questions[i];
        await DatabaseHelper.instance.insertField({
          'Name': formName,
          'sid': sid_int,
          'source_type': 0,
          'attribute_name': element['question'],
          'attribute_datatype': element['type'],
          'attribute_unit': element['unit'],
          'attribute_values': element['options'],
          'required_value': element['required'],
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Created form successfully'),
        ),
      );

      _clearFields();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Details Form'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Select the type of question:',
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<String>(
                  value: selectedType,
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(color: Colors.blue, fontSize: 18),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  items: <String>[
                    'Single Choice',
                    'Multiple Choice',
                    'Text Answer',
                    'Integer Answer',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue;
                      options.clear();
                    });
                  },
                ),
                _buildSmallTextField(questionController, 'Question'),
                SizedBox(
                  height: 10,
                ),
                _buildSmallTextField(attributeUnitController, 'Attribute Unit'),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: isRequired,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isRequired = !isRequired;
                        });
                      },
                    ),
                    const Text(
                      'Required Value',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                if (selectedType == 'Single Choice' ||
                    selectedType == 'Multiple Choice')
                  Column(
                    children: <Widget>[
                      const Text(
                        'Enter options:',
                        style: TextStyle(fontSize: 18),
                      ),
                      for (var i = 0; i < options.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 200, // Set the desired width
                            child: TextField(
                              controller: optionControllers[i],
                              onChanged: (text) {
                                options[i] = text;
                              },
                              decoration: InputDecoration(
                                labelText: 'Option ${i + 1}',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            options.add('');
                            optionControllers.add(
                                TextEditingController()); // Add a new controller
                          });
                        },
                        icon: Icon(Icons.add, size: 30), // Add an "add" icon
                        label: Text('Add Option'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ElevatedButton.icon(
                  onPressed: addQuestion,
                  icon: Icon(Icons.add, size: 30), // Add a "question" icon
                  label: Text('Add Question'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: createForm,
                  icon: Icon(Icons.create, size: 30), // Add a "create" icon
                  label: Text('Save Form'),
                ),
              ],
            )),
          ),
          // Positioned(
          //   top: 10, // Adjust top position as needed
          //   right: 10, // Adjust right position as needed
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => LoginPage(),
          //         ),
          //       );
          //     },
          //     icon: Icon(Icons.logout, size: 30), // Add a logout icon
          //     label: Text('Logout'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
