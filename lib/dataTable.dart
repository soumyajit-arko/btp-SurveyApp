import 'package:flutter/material.dart';
import 'package:app_001/database_helper.dart';

class FamilyDetails {
  final String motherName;
  final String childName;
  final String husbandName;

  FamilyDetails({
    required this.motherName,
    required this.childName,
    required this.husbandName,
  });
}

class FamilyDataTablePage extends StatefulWidget {
  @override
  _FamilyDataTablePageState createState() => _FamilyDataTablePageState();
}

class _FamilyDataTablePageState extends State<FamilyDataTablePage> {
  List<FamilyDetails> familyList = [];
  List<FamilyDetails> filteredList = [];

  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'Mother Name';

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
              motherName: family['MotherNameBeneficiary'].toString(),
              childName: family['ChildNameBeneficiary'].toString(),
              husbandName: family['HusbandName'].toString(),
            ),
          )
          .toList();
      filteredList = familyList;
    });
  }

  void filterFamilyList(String query) {
    setState(() {
      if (selectedCategory == 'Mother Name') {
        filteredList = familyList
            .where((family) =>
                family.motherName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (selectedCategory == 'Child Name') {
        filteredList = familyList
            .where((family) =>
                family.childName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (selectedCategory == 'Husband Name') {
        filteredList = familyList
            .where((family) =>
                family.husbandName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Data Table'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  items: [
                    'Mother Name',
                    'Child Name',
                    'Husband Name',
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value ?? 'Mother Name';
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columns: const <DataColumn>[
                  DataColumn(label: Text('Mother Name')),
                  DataColumn(label: Text('Child Name')),
                  DataColumn(label: Text('Husband Name')),
                ],
                rows: filteredList
                    .map(
                      (family) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(family.motherName)),
                          DataCell(Text(family.childName)),
                          DataCell(Text(family.husbandName)),
                        ],
                        onSelectChanged: (isnotSelected) {
                          navigateToDetailsPage(context, family);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToDetailsPage(BuildContext context, FamilyDetails family) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FamilyDetailsPage(family: family),
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
              Text('Mother Name: ${family.motherName}'),
              Text('Child Name: ${family.childName}'),
              Text('Husband Name: ${family.husbandName}'),
            ],
          ),
        ),
      ),
    );
  }
}
