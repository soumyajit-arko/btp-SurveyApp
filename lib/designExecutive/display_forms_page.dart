import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
import 'display_template_page.dart';

class DisplayFormsPage extends StatefulWidget {
  const DisplayFormsPage({super.key});

  @override
  State<DisplayFormsPage> createState() => _DisplayFormsPageState();
}

class _DisplayFormsPageState extends State<DisplayFormsPage> {
  List<Map<String, dynamic>> formsList = [];
  @override
  void initState() {
    super.initState();

    _loadForms();
  }

  void _loadForms() async {
    print('loaded forms list : ');
    final fL = await DatabaseHelper.instance.getForms();
    print(formsList);
    setState(() {
      formsList = fL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Forms'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Display Details of Forms',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  formsList.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Id')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Survey template')),
                              DataColumn(label: Text('Details')),
                              DataColumn(label: Text('Creation date')),
                            ],
                            rows: formsList
                                .map(
                                  (form_) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(form_['sid'].toString())),
                                      DataCell(Text(form_['name'].toString())),
                                      DataCell(Text(
                                          form_['description'].toString())),
                                      DataCell(
                                        const Text("View the survey form"),
                                        onTap: () {
                                          // Handle navigation to a new page displaying the content
                                          String templateSource =
                                              form_['template_source']
                                                  .toString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TemplateSourcePage(
                                                      "Survey Form",
                                                      templateSource),
                                            ),
                                          );
                                        },
                                      ),
                                      DataCell(
                                        const Text("View the details form"),
                                        onTap: () {
                                          // Handle navigation to a new page displaying the content
                                          String detailsSource =
                                              form_['details_source']
                                                  .toString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TemplateSourcePage(
                                                      "Details Form",
                                                      detailsSource),
                                            ),
                                          );
                                        },
                                      ),
                                      DataCell(Text(
                                          form_['creation_date'].toString())),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
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
