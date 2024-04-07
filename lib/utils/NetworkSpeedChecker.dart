import 'package:app_001/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkSpeedChecker extends StatelessWidget {
// Function to check network speed(Future Method)
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
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('Network Download Speed Checker'), // Set the app title
      // ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Trigger the network speed check when the button is pressed
            checkNetworkSpeed(context);
          },
          child: Text('Check Network Speed'), // Button text
        ),
      ),
    );
  }
}
