import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class PastResponseWidget extends StatefulWidget {
//   final List<Map<String, dynamic>> pastResponses;
//   final Function(Map<String, dynamic>) onSelect;
//   final Map<String, dynamic>? defaultOption;

//   const PastResponseWidget({
//     Key? key,
//     required this.pastResponses,
//     required this.onSelect,
//     this.defaultOption,
//   }) : super(key: key);

//   @override
//   _PastResponseWidgetState createState() => _PastResponseWidgetState();
// }

// class _PastResponseWidgetState extends State<PastResponseWidget> {
//   Map<String, dynamic>? selectedResponse;

// String formatDate(DateTime dateTime) {
//   return DateFormat('dd-MM-yyyy').format(dateTime);
// }

//   @override
//   void initState() {
//     super.initState();
//     selectedResponse = widget.defaultOption;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         DropdownButtonFormField<Map<String, dynamic>>(
//           value: selectedResponse,
//           onChanged: (Map<String, dynamic>? value) {
//             setState(() {
//               selectedResponse = value;
//               widget.onSelect(value!);
//             });
//           },
//           hint: Text(
//             'Select a past response',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           items: [
//             if (widget.defaultOption != null)
//               DropdownMenuItem<Map<String, dynamic>>(
//                 value: widget.defaultOption,
//                 child: Text(formatDate(
//                     DateTime.parse(widget.defaultOption!['survey_datetime']))),
//               ),
//             ...widget.pastResponses.map(
//               (response) => DropdownMenuItem<Map<String, dynamic>>(
//                 value: response,
//                 child: Text(
// '${DateFormat("dd-MM-yyyy").format(DateTime.parse(response['survey_datetime']))} '
// '${DateFormat("HH:mm:ss").format(DateTime.parse(response['survey_datetime']))}',
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (selectedResponse != null) ...[
//           SizedBox(height: 8),
//           Text(
//             'Past Response -',
//             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: (jsonDecode(selectedResponse!['survey_data']) as Map<String, dynamic>).entries
//                 .map((entry) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${entry.key}: ',
//                             style: TextStyle(
//                               // fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Expanded(
//                             child: Text(
//                               '${entry.value}',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ],
//       ],
//     );
//   }
// }

class PastResponseWidget extends StatefulWidget {
  final List<Map<String, dynamic>> pastResponses;
  final Function(Map<String, dynamic>) onSelect;
  final Map<String, dynamic>? defaultOption;
  final String careTaker;
  const PastResponseWidget({
    Key? key,
    required this.pastResponses,
    required this.onSelect,
    required this.careTaker,
    this.defaultOption,
  }) : super(key: key);

  @override
  _PastResponseWidgetState createState() => _PastResponseWidgetState();
}

class _PastResponseWidgetState extends State<PastResponseWidget> {
  int selectedIndex = 0;
  String formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (selectedIndex > 0) {
                  setState(() {
                    selectedIndex--;
                    widget.onSelect(widget.pastResponses[selectedIndex]);
                  });
                }
              },
            ),
            SizedBox(width: 8),
            Text(
              '${DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.pastResponses[selectedIndex]['survey_datetime']))} ' +
                  '${DateFormat("HH:mm:ss").format(DateTime.parse(widget.pastResponses[selectedIndex]['survey_datetime']))}',
              style: TextStyle(fontWeight: FontWeight.bold),
              // textAlign: TextAlign.right,
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                if (selectedIndex < widget.pastResponses.length - 1) {
                  setState(() {
                    selectedIndex++;
                    widget.onSelect(widget.pastResponses[selectedIndex]);
                  });
                }
              },
            ),
          ],
        ),
        if (widget.defaultOption != null) ...[
          SizedBox(height: 8),
          Text(
            'Default Response -',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (jsonDecode(widget.defaultOption!['survey_data'])
                    as Map<String, dynamic>)
                .entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key}: ',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                          Expanded(
                            child: Text(
                              '${entry.value}',
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
        if (widget.defaultOption == null && selectedIndex >= 0) ...[
          SizedBox(height: 8),
          Text(
            'Previous Caretaker - ${widget.careTaker}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                (jsonDecode(widget.pastResponses[selectedIndex]['survey_data'])
                        as Map<String, dynamic>)
                    .entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}: ',
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Expanded(
                                child: Text(
                                  '${entry.value}',
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
          ),
        ],
      ],
    );
  }
}
