import 'package:app_001/surveyor/form_selection_survey.dart';
import 'package:flutter/material.dart';
import 'package:app_001/backend/database_helper.dart';

class VillageDataTablePage extends StatefulWidget {
  final String nextPage;
  const VillageDataTablePage({required this.nextPage, super.key});
  @override
  _VillageDataTablePageState createState() => _VillageDataTablePageState();
}

class _VillageDataTablePageState extends State<VillageDataTablePage> {
  List<String> Villages = [];
  List<String> filteredList = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'Village';

  @override
  void initState() {
    super.initState();
    loadVillageDetails();
  }

  Future<void> loadVillageDetails() async {
    final dbHelper = DatabaseHelper.instance;
    // final villageDetails = await dbHelper.getVillageNames();
    final villageDetails = await dbHelper.getZoneNames();

    setState(() {
      Villages = villageDetails
          .map(
            (village) => village['name'].toString(),
          )
          .toList();
      filteredList = Villages;
    });
  }

  void filterFamilyList(String query) {
    setState(() {
      filteredList = Villages.where(
              (element) => element.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var dataTable = PaginatedDataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(label: Text('Village')),
      ],
      source: _VillageDataSource(
        filteredList,
        onRowClicked: (village) {
          navigateToFormsPage(
              context, village); // Navigate to details page on row click
        },
      ),
      // header: const Text('Family Details'),
      rowsPerPage: 10,
    );

    List<Widget> content = [dataTable];

    return Scaffold(
      appBar: AppBar(
        title: Text('Village Data Table'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // DropdownButton<String>(
                  //   value: selectedCategory,
                  //   items: [
                  //     'Beneficiary Name',
                  //     'Child Name',
                  //     'Spouse Name',
                  //   ].map((String category) {
                  //     return DropdownMenuItem<String>(
                  //       value: category,
                  //       child: Text(category),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? value) {
                  //     setState(() {
                  //       selectedCategory = value ?? 'Beneficiary Name';
                  //     });
                  //   },
                  // ),
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

  void navigateToFormsPage(BuildContext context, String village) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FormDataTablePage(village: village, nextPage: widget.nextPage),
      ),
    );
  }
}

class VillageDetailsPage extends StatelessWidget {
  final String village;

  VillageDetailsPage({required this.village});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Village Details'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Village : $village'),
            ],
          ),
        ),
      ),
    );
  }
}

class _VillageDataSource extends DataTableSource {
  final List<String> _villageList;
  final Function(String) onRowClicked; // Add this callback

  _VillageDataSource(this._villageList, {required this.onRowClicked});

  @override
  DataRow? getRow(int index) {
    if (index >= _villageList.length) {
      return null;
    }
    final village = _villageList[index];
    return DataRow(
      cells: [
        DataCell(Text(village)),
      ],
      onSelectChanged: (isSelected) {
        if (isSelected != null && isSelected) {
          onRowClicked(village); // Invoke the callback on row selection
        }
      },
    );
  }

  @override
  int get rowCount => _villageList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
