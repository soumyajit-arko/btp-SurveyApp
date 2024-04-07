import 'package:app_001/admin/admin_page_util.dart';
import 'package:app_001/surveyor/data_download_page.dart';
import 'package:app_001/surveyor/subject_register_page.dart';
import 'package:app_001/surveyor/survery_page_util.dart';
import 'package:app_001/utils/NetworkSpeedChecker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HamburgerMenu extends StatelessWidget {
  final String userName;
  final String email;
  final List<Widget> pages;
  final List<IconData> icons;
  final List<String> pageTitles;
  // final VoidCallback onDownloadPressed;

  HamburgerMenu({
    required this.userName,
    required this.email,
    required this.pages,
    required this.icons,
    required this.pageTitles,
    // required this.onDownloadPressed,
  });
  Future<void> checkNetworkSpeed(BuildContext context) async {
    final url =
        "https://images.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png";
    // 'https://drive.google.com/file/d/1lEn1DtJQW6-nTcoS_FG7-EB3Kamy0147/view?usp=sharing';
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final elapsed = stopwatch.elapsedMilliseconds;
        final speedInKbps =
            ((response.bodyBytes.length / 1024) / (elapsed / 1000)) *
                8; // Calculate download speed in Kbps

        // Show download speed in an AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Network Speed'), // Set the dialog title
              content: Text(
                  // Display download speed
                  'Download speed: ${speedInKbps.toStringAsFixed(2)} Kbps'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'), // Button to close the dialog
                ),
              ],
            );
          },
        );
      } else {
        // Show an error dialog if the download failed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'), // Set the error dialog title
              content: Text(
                  // Display error message
                  'Failed to download the file. Status code: ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'), // Button to close the dialog
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show an error dialog in case of an exception
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'), // Set the exception dialog title
            content: Text('Error: $e'), // Display the exception message
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'), // Button to close the dialog
              ),
            ],
          );
        },
      );
    }
  }

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
              itemCount: pages.length + 3,
              itemBuilder: (BuildContext context, int index) {
                if (index == pages.length + 2) {
                  // Display the download button at the end
                  return ListTile(
                    leading: Icon(Icons.download), // Icon for download button
                    title: Text('Download'), // Text for download button
                    onTap: () async {
                      await DataDownloadPageState.download_villages();
                      await DataDownloadPageState.download_forms();
                      await DataDownloadPageState.getSubjects();
                      await DataDownloadPageState.getAllServices();
                      await DataDownloadPageState.getAllResponses();
                    },
                  );
                } else if (index == pages.length + 1) {
                  // Display the download button at the end
                  return ListTile(
                    leading: Icon(Icons.upload), // Icon for download button
                    title: Text('Upload'), // Text for download button
                    onTap: () async {
                      // await DataDownloadPageState.download_villages();
                      // await DataDownloadPageState.download_forms();
                      // await DataDownloadPageState.getSubjects();
                      // await DataDownloadPageState.getAllServices();
                      // await DataDownloadPageState.getAllResponses();
                    },
                  );
                } else if (index == pages.length) {
                  // Display the download button at the end
                  return ListTile(
                    leading: Icon(Icons.person), // Icon for download button
                    title:
                        Text('Enroll Beneficiary'), // Text for download button
                    onTap: () async {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubjectRegisterPage()),
                      );
                      // await DataDownloadPageState.download_villages();
                      // await DataDownloadPageState.download_forms();
                      // await DataDownloadPageState.getSubjects();
                      // await DataDownloadPageState.getAllServices();
                      // await DataDownloadPageState.getAllResponses();
                    },
                  );
                } else {
                  return ListTile(
                    leading: Icon(icons[index]),
                    title: Text(pageTitles[index]),
                    onTap: () {
                      if (pages[index] is NetworkSpeedChecker) {
                        // If the Bandwidth button is pressed, call checkNetworkSpeed directly
                        checkNetworkSpeed(context);
                      } else if (pageTitles[index] == 'Download') {
                        // onDownloadPressed();
                      } else {
                        // If any other button is pressed, navigate to the corresponding page
                        Navigator.of(context).pop(); // Close the drawer
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => pages[index]),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
