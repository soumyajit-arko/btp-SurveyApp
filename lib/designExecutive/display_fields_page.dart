import 'package:flutter/material.dart';
import '../backend/database_helper.dart';

import '../login_page.dart';

class DisplayFieldsPage extends StatefulWidget {
  const DisplayFieldsPage({super.key});

  @override
  State<DisplayFieldsPage> createState() => _DisplayFieldsPageState();
}

class _DisplayFieldsPageState extends State<DisplayFieldsPage> {
  List<Map<String, dynamic>> fieldsList = [];
  @override
  void initState() {
    super.initState();

    _loadFields();
  }

  void _loadFields() async {
    fieldsList = await DatabaseHelper.instance.getFields();
    // print(fieldsList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Form'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Display Details of Fields',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                fieldsList.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Text('fid')),
                            DataColumn(label: Text('sid')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('attribute_name')),
                            DataColumn(label: Text('attribute_datatype')),
                            DataColumn(label: Text('attribute_unit')),
                            DataColumn(label: Text('attribute_values')),
                            DataColumn(label: Text('required_value')),
                            DataColumn(label: Text('InstanceTime')),
                          ],
                          rows: fieldsList
                              .map(
                                (form_) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(form_['fid'].toString())),
                                    DataCell(Text(form_['sid'].toString())),
                                    DataCell(Text(form_['Name'].toString())),
                                    DataCell(Text(form_['source_type'].toString())),
                                    DataCell(Text(
                                        form_['attribute_name'].toString())),
                                    DataCell(Text(form_['attribute_datatype']
                                        .toString())),
                                    DataCell(Text(
                                        form_['attribute_unit'].toString())),
                                    DataCell(Text(
                                        form_['attribute_values'].toString())),
                                    DataCell(Text(
                                        form_['required_value'].toString())),
                                    DataCell(
                                        Text(form_['InstanceTime'].toString())),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : Container(),
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
