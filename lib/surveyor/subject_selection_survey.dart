import 'package:app_001/surveyor/form_selection_survey.dart';
import 'package:flutter/material.dart';
import 'package:app_001/backend/database_helper.dart';
import 'family_details.dart';

class FamilyDataTablePage extends StatefulWidget {
  final String nextPage;
  const FamilyDataTablePage({required this.nextPage,super.key});
  @override
  _FamilyDataTablePageState createState() => _FamilyDataTablePageState();
}

class _FamilyDataTablePageState extends State<FamilyDataTablePage> {
  List<FamilyDetails> familyList = [];
  List<FamilyDetails> filteredList = [];

  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'Beneficiary Name';

  @override
  void initState() {
    super.initState();
    loadFamilyDetails();
  }

  Future<void> loadFamilyDetails() async {
    final dbHelper = DatabaseHelper.instance;
    final familyDetails = await dbHelper.getFamilyDetails();

    setState(() {
      familyList = familyDetails
          .map(
            (family) => FamilyDetails(
              subjectID: family['subject_id'].toString(),
              subjectName: family['SubjectName'].toString(),
              spouseName: family['SpouseName'].toString(),
              childName: family['ChildName'].toString(),
            ),
          )
          .toList();
      filteredList = familyList;
    });
  }

  void filterFamilyList(String query) {
    setState(() {
      if (selectedCategory == 'Beneficiary Name') {
        filteredList = familyList
            .where((family) =>
                family.subjectName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (selectedCategory == 'Child Name') {
        filteredList = familyList
            .where((family) =>
                family.childName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (selectedCategory == 'Spouse Name') {
        filteredList = familyList
            .where((family) =>
                family.spouseName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var dataTable = PaginatedDataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(label: Text('Beneficiary Name')),
        DataColumn(label: Text('Child Name')),
        DataColumn(label: Text('Spouse Name')),
      ],
      source: _FamilyDataSource(
        filteredList,
        onRowClicked: (family) {
          navigateToDetailsPage(
              context, family); // Navigate to details page on row click
        },
      ),
      // header: const Text('Family Details'),
      rowsPerPage: 10,
    );

    List<Widget> content = [dataTable];

    return Scaffold(
      appBar: AppBar(
        title: Text('Family Data Table'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: [
                      'Beneficiary Name',
                      'Child Name',
                      'Spouse Name',
                    ].map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value ?? 'Beneficiary Name';
                      });
                    },
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        filterFamilyList(query);
                      },
                      decoration: InputDecoration(
                        labelText: 'Search by $selectedCategory',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: content.map((widget) => widget).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToDetailsPage(BuildContext context, FamilyDetails family) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormDataTablePage(family: family,nextPage: widget.nextPage),
      ),
    );
  }
}

class FamilyDetailsPage extends StatelessWidget {
  final FamilyDetails family;

  FamilyDetailsPage({required this.family});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Details'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Mother Name: ${family.subjectName}'),
              Text('Child Name: ${family.childName}'),
              Text('Husband Name: ${family.spouseName}'),
            ],
          ),
        ),
      ),
    );
  }
}

class _FamilyDataSource extends DataTableSource {
  final List<FamilyDetails> _familyList;
  final Function(FamilyDetails) onRowClicked; // Add this callback

  _FamilyDataSource(this._familyList, {required this.onRowClicked});

  @override
  DataRow? getRow(int index) {
    if (index >= _familyList.length) {
      return null;
    }
    final family = _familyList[index];
    return DataRow(
      cells: [
        DataCell(Text(family.subjectName)),
        DataCell(Text(family.childName)),
        DataCell(Text(family.spouseName)),
      ],
      onSelectChanged: (isSelected) {
        if (isSelected != null && isSelected) {
          onRowClicked(family); // Invoke the callback on row selection
        }
      },
    );
  }

  @override
  int get rowCount => _familyList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
