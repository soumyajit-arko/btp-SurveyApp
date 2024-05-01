import 'package:app_001/designExecutive/create_details_page.dart';
import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
import 'dart:convert';

class CreateFormsPage extends StatefulWidget {
  final String formName;
  final String formDescription;
  CreateFormsPage(this.formName, this.formDescription);

  @override
  State<CreateFormsPage> createState() => _CreateFormsPageState();
}

class _CreateFormsPageState extends State<CreateFormsPage> {
  // Questions
  List<Map<String, dynamic>> questions = [];
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
      'attrname': originalQuestion['attrname'],
      'attrtype': originalQuestion['attrtype'],
      'attrunit': originalQuestion['attrunit'],
      'attrvalues': originalQuestion['attrvalues'],
      'attrreq': originalQuestion['attrreq']
    };
  }

  void addQuestion() {
    if (questionController.text.isNotEmpty) {
      final question = {
        'attrname': questionController.text,
        'attrtype': selectedType,
        'attrunit': attributeUnitController.text,
        'attrvalues': options.join(','),
        'attrreq': isRequired ? 1 : 0
      };
      Map<String, dynamic> q = deepCopyQuestion(question);
      setState(() {
        questions.add(q);
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

  void createForm() async {
    String formName = widget.formName;
    String description = widget.formDescription;
    String template = json.encode(questions);

    await DatabaseHelper.instance.insertForm({
      'Name': formName,
      'Description': description,
      'template_source': template
    });
    final sid = await DatabaseHelper.instance.getSidByName(formName);
    print('sid : ');
    print(sid);
    int sid_int = int.parse(sid);
    for (int i = 0; i < questions.length; ++i) {
      final Map<String, dynamic> element = questions[i];
      await DatabaseHelper.instance.insertField({
        'Name': formName,
        'sid': sid_int,
        'attribute_name': element['attrname'],
        'attribute_datatype': element['attrtype'],
        'attribute_unit': element['attrunit'],
        'attribute_values': element['attrvalues'],
        'required_value': element['attrreq'],
      });
    }
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Created form successfully'),
    //   ),
    // );

    _clearFields();
  }

  void _clearFields() async {
    questions.clear();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service Questions'),
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
                    'Check Box',
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
                if(selectedType!='Check Box')
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
                                isDense: true,
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateDetailsPage(
                                widget.formName,
                                widget.formDescription,
                                questions)));
                  },
                  // onPressed: createForm,
                  icon: Icon(Icons.create, size: 30), // Add a "create" icon
                  label: Text('Create Details Form'),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
