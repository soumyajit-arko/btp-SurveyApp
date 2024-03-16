import 'package:flutter/material.dart';
import 'dart:convert';

class SurveyData extends StatefulWidget {
  // const SurveyData({super.key});
  final String currsurveyData;
  SurveyData(this.currsurveyData);
  @override
  State<SurveyData> createState() => _SurveyDataState();
}

class _SurveyDataState extends State<SurveyData> {
  List<MapEntry<String, dynamic>> entries = [];

  @override
  void initState() {
    super.initState();
    displayResponseData();
  }

  void displayResponseData() {
    final data = json.decode(widget.currsurveyData);
    entries = data.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('S.No')),
                  DataColumn(label: Text('Question')),
                  DataColumn(label: Text('Value')),
                ],
                rows: List<DataRow>.generate(
                  entries.length,
                  (index) {
                    final entry = entries[index];
                    final key = entry.key;
                    final value = entry.value.toString();
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(key)),
                        DataCell(Text(value)),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
