import 'package:flutter/material.dart';

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

class CreateSurveyFormPage extends StatefulWidget {
  @override
  _CreateSurveyFormPageState createState() => _CreateSurveyFormPageState();
}

class _CreateSurveyFormPageState extends State<CreateSurveyFormPage> {
  final TextEditingController fieldNameController = TextEditingController();
  final TextEditingController fieldTypeController = TextEditingController();
  final TextEditingController fieldUnitController = TextEditingController();
  bool? isRequired = false;

  List<Field> fields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Fields to Survey')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: fieldNameController,
              decoration: InputDecoration(labelText: 'Field Name'),
            ),
            TextField(
              controller: fieldTypeController,
              decoration: InputDecoration(labelText: 'Field Type'),
            ),
            TextField(
              controller: fieldUnitController,
              decoration: InputDecoration(labelText: 'Field Unit'),
            ),
            CheckboxListTile(
              title: Text('Required'),
              value: isRequired,
              onChanged: (bool? newValue) {
                setState(() {
                  isRequired = newValue;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add the field to the list
                addField();
              },
              child: Text('Add Field'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the fields and navigate back to the previous page
                saveFieldsAndNavigateBack();
              },
              child: Text('Save Fields'),
            ),
            // List of added fields
            if (fields.isNotEmpty)
              Column(
                children: fields
                    .map((field) => ListTile(
                          title: Text(field.name),
                          subtitle: Text(
                              'Type: ${field.attributeType}, Required: ${field.isRequired}'),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  void addField() {
    String name = fieldNameController.text;
    String type = fieldTypeController.text;
    String unit = fieldUnitController.text;

    // Create a new field and add it to the list
    Field newField = Field(
      name: name,
      attributeType: type,
      attributeUnit: unit,
      isRequired: isRequired ?? false,
    );
    setState(() {
      fields.add(newField);
    });

    // Clear text fields for the next input
    fieldNameController.clear();
    fieldTypeController.clear();
    fieldUnitController.clear();
    setState(() {
      isRequired = false;
    });
  }

  void saveFieldsAndNavigateBack() {
    // Save the fields to your survey or database (you can add this logic)

    // Navigate back to the previous page (SurveyFormPage)
    Navigator.pop(context);
  }
}
