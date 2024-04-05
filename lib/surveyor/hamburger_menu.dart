import 'package:app_001/admin/admin_page_util.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  final String userName;
  final String email;
  final List<Widget> pages;
  final List<IconData> icons;
  final List<String> pageTitles;

  HamburgerMenu({
    required this.userName,
    required this.email,
    required this.pages,
    required this.icons,
    required this.pageTitles,
  });

  // Widget hamburgerMenu(BuildContext context) {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         UserAccountsDrawerHeader(
  //           accountName: Text(userName),
  //           accountEmail: Text(email),
  //           currentAccountPicture: CircleAvatar(
  //             backgroundColor: Colors.orange,
  //             child: Text(
  //               "J",
  //               style: TextStyle(fontSize: 40.0),
  //             ),
  //           ),
  //         ),
  //         // Rest of the drawer content
  //         ListTile(
  //           leading: Icon(Icons.home),
  //           title: Text('Home'),
  //           onTap: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => SurveyorPageUtil()));
  //           },
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.settings),
  //           title: Text('Settings'),
  //           onTap: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => AdminPageUtil()));
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(icons[index]),
                  title: Text(pageTitles[index]),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => pages[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
