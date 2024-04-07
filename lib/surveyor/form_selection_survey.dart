import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/form_details.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
// import 'package:app_001/surveyor/selectTimePeriodPage.dart';
import 'package:app_001/surveyor/subject_selection_survey.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
// import 'package:app_001/surveyor/take_survey_page.dart';
// import 'family_details.dart';
import 'package:flutter/material.dart';
import 'package:app_001/backend/database_helper.dart';

// import 'service_enrolled_subjects.dart';

class FormDataTablePage extends StatefulWidget {
  // final FamilyDetails family;
  final String village;
  final String nextPage;
  const FormDataTablePage(
      {required this.village, required this.nextPage, super.key});
  // const FormDataTablePage({required this.family, required this.nextPage, super.key});
  @override
  _FormDataTablePageState createState() => _FormDataTablePageState();
}

class _FormDataTablePageState extends State<FormDataTablePage> {
  List<FormDetails> formList = [];
  List<FormDetails> filteredList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('printting ');
    print(widget.village);
    loadFormDetails();
  }

  Future<void> loadFormDetails() async {
    final dbHelper = DatabaseHelper.instance;
    List<String> formDetails;
    // if (widget.nextPage == 'survey') {
    //   formDetails =
    //       await dbHelper.getValidServicesForSubject(widget.family.subjectID);
    // } else {
    formDetails = await dbHelper.getFormsNames();
    // await dbHelper.getUniqueServicesEnrolledByID(widget.family.subjectID);
    // await dbHelper.getServicesEnrolledByID(widget.family.subjectID);
    // }

    setState(() {
      formList = formDetails
          .map(
            (form) => FormDetails(
              formName: form.toString(),
            ),
          )
          .toList();
      filteredList = formList;
    });
  }

  void filterFormList(String query) {
    setState(() {
      filteredList = formList
          .where((form) =>
              form.formName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var dataTable = PaginatedDataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(label: Text('Form Name')),
      ],
      source: _FormDataSource(
        filteredList,
        onRowClicked: (form) {
          navigateToDetailsPage(context, form);
          // navigateToDetailsPage(context, form,
          //     widget.family); // Navigate to details page on row click
        },
      ),
      rowsPerPage: 10,
    );

    List<Widget> content = [dataTable];

    return Scaffold(
      drawer: HamburgerMenu(
        userName: LoginPage.userId,
        email: LoginPage.username,
        pages: [
          SurveyorPageUtil(),
          LoginPage(),
          NetworkSpeedChecker(),
        ],
        icons: [
          Icons.home,
          Icons.logout,
          Icons.network_cell_rounded,
        ],
        pageTitles: ['Home', 'Log out', 'Bandwidth'],
      ),
      appBar: AppBar(
        title: Text('Form Data Table'),
        actions: [
          IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back_rounded)),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        filterFormList(query);
                      },
                      decoration: InputDecoration(
                        labelText: 'Search by Form Name',
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

  void navigateToDetailsPage(BuildContext context, FormDetails form) {
    // if (widget.nextPage == 'service registraion') {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FamilyDataTablePage(
              formName: form,
              village: widget.village,
              nextPage: widget.nextPage)),
    );
    //   } else if (widget.nextPage == "survey") {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => FamilyDataTablePage(
    //               formName: form,
    //               village: widget.village,
    //               nextPage: widget.nextPage)),
    //     );
    //     // Navigator.push(
    //     //   context,
    //     //   MaterialPageRoute(
    //     //     builder: (context) => TakeSurveyPage(
    //     //       formName: form,
    //     //       // familyDetails: family,
    //     //       nextPage: widget.nextPage,
    //     //     ),
    //     //   ),
    //     // );
    //   } else {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ServiceEnrolledPage(
    //           nextPage: widget.nextPage,
    //           formDetails: form,
    //         ),
    //       ),
    //     );
    //   }
  }
}

class FormDetailsPage extends StatelessWidget {
  final FormDetails form;

  FormDetailsPage({required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Details'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Form Name: ${form.formName}'),
              // Add more details as needed
            ],
          ),
        ),
      ),
    );
  }
}

class _FormDataSource extends DataTableSource {
  final List<FormDetails> _formList;
  final Function(FormDetails) onRowClicked; // Add this callback

  _FormDataSource(this._formList, {required this.onRowClicked});

  @override
  DataRow? getRow(int index) {
    if (index >= _formList.length) {
      return null;
    }
    final form = _formList[index];
    return DataRow(
      cells: [
        DataCell(Text(form.formName)),
      ],
      onSelectChanged: (isSelected) {
        if (isSelected != null && isSelected) {
          onRowClicked(form); // Invoke the callback on row selection
        }
      },
    );
  }

  @override
  int get rowCount => _formList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
