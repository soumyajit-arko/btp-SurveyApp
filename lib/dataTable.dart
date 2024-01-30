import 'package:app_001/database_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pagination Table with Search'),
        ),
        body: PaginatedDataTableWithSearch(),
      ),
    );
  }
}

class PaginatedDataTableWithSearch extends StatefulWidget {
  @override
  _PaginatedDataTableWithSearchState createState() =>
      _PaginatedDataTableWithSearchState();
}

class _PaginatedDataTableWithSearchState
    extends State<PaginatedDataTableWithSearch> {
  TextEditingController searchController = TextEditingController();

  List<DataRow> _rows = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from the database when the widget is initialized
    fetchData();
  }

  void fetchData() async {
    try {
      List<Map<String, Object?>> familyDetails =
          await DatabaseHelper.instance.getFamilyDetails();

      setState(() {
        _rows = List<DataRow>.generate(
          familyDetails.length,
          (index) {
            // Access values using the keys from the Map
            String motherName =
                familyDetails[index]['MotherNameBeneficiary']?.toString() ?? '';
            String childName =
                familyDetails[index]['ChildNameBeneficiary']?.toString() ?? '';
            String husbandName =
                familyDetails[index]['HusbandName']?.toString() ?? '';

            return DataRow(
              cells: [
                DataCell(Text(motherName)),
                DataCell(Text(childName)),
                DataCell(Text(husbandName)),
              ],
              onSelectChanged: (isSelected) {
                if (isSelected != null && isSelected) {
                  navigateToDetailsPage(
                      context, motherName, childName, husbandName);
                }
              },
            );
          },
        );
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Perform search based on the entered text
                  performSearch();
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: PaginatedDataTable(
            columns: [
              DataColumn(label: Text('Mother Name')),
              DataColumn(label: Text('Child Name')),
              DataColumn(label: Text('Husband Name')),
            ],
            source: DataTableSourceWithSearch(rows: _rows),
            header: const Text('Family Details'),
            onPageChanged: (pageIndex) {
              // Handle page changes
            },
          ),
        ),
      ],
    );
  }

  void performSearch() {
    // Perform the search logic based on the entered text
    String searchText = searchController.text.toLowerCase();
    setState(() {
      _rows = List<DataRow>.generate(
        _rows.length,
        (index) {
          String motherName = (_rows[index].cells[0].child as Text).data ?? '';
          String childName = (_rows[index].cells[1].child as Text).data ?? '';
          String husbandName = (_rows[index].cells[2].child as Text).data ?? '';

          // Include the row in the search results if any of the names match the search text
          if (motherName.contains(searchText) ||
              childName.contains(searchText) ||
              husbandName.contains(searchText)) {
            return DataRow(
              cells: [
                DataCell(Text(motherName)),
                DataCell(Text(childName)),
                DataCell(Text(husbandName)),
              ],
              onSelectChanged: (isSelected) {
                if (isSelected != null && isSelected) {
                  navigateToDetailsPage(
                      context, motherName, childName, husbandName);
                }
              },
            );
          } else {
            return DataRow(cells: []);
          }
        },
      );
    });
  }

  void navigateToDetailsPage(BuildContext context, String motherName,
      String childName, String husbandName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          motherName: motherName,
          childName: childName,
          husbandName: husbandName,
        ),
      ),
    );
  }
}

class DataTableSourceWithSearch extends DataTableSource {
  final List<DataRow> rows;

  DataTableSourceWithSearch({required this.rows});

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    return rows[index];
  }

  @override
  int get rowCount => rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class DetailsPage extends StatelessWidget {
  final String motherName;
  final String childName;
  final String husbandName;

  DetailsPage({
    required this.motherName,
    required this.childName,
    required this.husbandName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Mother Name: $motherName'),
            Text('Child Name: $childName'),
            Text('Husband Name: $husbandName'),
          ],
        ),
      ),
    );
  }
}

// // Assume this class represents your database helper
// class DatabaseHelper {
//   // This is a placeholder for the actual implementation of getSubjectNames
//   static DatabaseHelper instance = DatabaseHelper();

//   Future<List<Map<String, String>>> getSubjectNames() async {
//     // Replace this with the actual implementation to fetch data from the database
//     await Future.delayed(Duration(seconds: 2));
//     return List.generate(
//       100,
//       (index) => {
//         'motherName': 'Mother Name $index',
//         'childName': 'Child Name $index',
//         'husbandName': 'Husband Name $index',
//       },
//     );
//   }
// }
