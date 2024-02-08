import 'package:app_001/surveyor/form_details.dart';
import 'package:app_001/surveyor/take_survey_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'family_details.dart';

class SelectTimePeriodPage extends StatefulWidget {
  final FormDetails formName;
  final FamilyDetails familyDetails;
  final String nextPage;
  const SelectTimePeriodPage(
      {required this.formName,
      required this.familyDetails,
      required this.nextPage,
      super.key});
  @override
  _SelectTimePeriodPageState createState() => _SelectTimePeriodPageState();
}

class _SelectTimePeriodPageState extends State<SelectTimePeriodPage> {
  DateTime initialDateSelected = DateTime.now();
  DateTime finalDateSelected = DateTime.now();

  TextEditingController initialDateController = TextEditingController();
  TextEditingController finalDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Time Period'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDateSelector(
              'Start Date',
              initialDateSelected,
              (DateTime date) {
                setState(() {
                  initialDateSelected = date;
                });
              },
              initialDateController,
            ),
            SizedBox(height: 20),
            _buildDateSelector(
              'End Date',
              finalDateSelected,
              (DateTime date) {
                setState(() {
                  finalDateSelected = date;
                });
              },
              finalDateController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Process the selected dates here
                print('Initial Date: $initialDateSelected');
                print('Final Date: $finalDateSelected');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeSurveyPage(
                      formName: widget.formName,
                      familyDetails: widget.familyDetails,
                      nextPage: widget.nextPage,
                      startDate: _formatDate(initialDateSelected),
                      endDate: _formatDate(finalDateSelected),
                    ),
                  ),
                );
              },
              child: Text('Fill Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    String labelText,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
    TextEditingController dateController,
  ) {
    if (selectedDate != null) {
      dateController.text = _formatDate(selectedDate);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                child: Text(
                  labelText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                    context,
                    selectedDate,
                    onDateSelected,
                    dateController,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Select Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
      controller.text = _formatDate(pickedDate);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
