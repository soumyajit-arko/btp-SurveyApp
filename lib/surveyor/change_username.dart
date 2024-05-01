import 'package:app_001/login_page.dart';
import 'package:app_001/surveyor/form_selection_survey.dart';
import 'package:app_001/surveyor/hamburger_menu.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/surveyor/village_data_table_page.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
import 'package:flutter/material.dart';
import 'package:app_001/backend/database_helper.dart';

class ChangeUserNamePage extends StatefulWidget {
  final String nextPage;
  const ChangeUserNamePage({required this.nextPage, super.key});
  @override
  _ChangeUserNamePageState createState() => _ChangeUserNamePageState();
}

class _ChangeUserNamePageState extends State<ChangeUserNamePage> {
  List<String> userNamesList = [];
  List<String> filteredList = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'User';

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {

    setState(() {
      userNamesList = LoginPage.usernames;
      filteredList = userNamesList;
    });
  }

  void filterFamilyList(String query) {
    setState(() {
      filteredList = userNamesList.where(
              (element) => element.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var dataTable = PaginatedDataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(label: Text('User')),
      ],
      source: _UserDataSource(
        filteredList,
        onRowClicked: (username) {
          navigateToFormsPage(
              context, username); // Navigate to details page on row click
        },
      ),
      // header: const Text('Family Details'),
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
        title: Text('User Data Table'),
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
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        filterFamilyList(query);
                      },
                      decoration: InputDecoration(
                        isDense: true,
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

  void navigateToFormsPage(BuildContext context, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VillageDataTablePage(nextPage: widget.nextPage),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final String user;

  UserDetailsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('User : $user'),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserDataSource extends DataTableSource {
  final List<String> _usersList;
  final Function(String) onRowClicked; // Add this callback

  _UserDataSource(this._usersList, {required this.onRowClicked});

  @override
  DataRow? getRow(int index) {
    if (index >= _usersList.length) {
      return null;
    }
    final village = _usersList[index];
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
  int get rowCount => _usersList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
