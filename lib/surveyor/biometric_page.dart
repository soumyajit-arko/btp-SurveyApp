// import 'dart:io';
// import 'package:app_001/surveyor/hamburger_menu.dart';
// import 'package:app_001/surveyor/survery_page_util.dart';
// import 'package:app_001/utils/NetworkSpeedChecker.dart';
// import 'package:app_001/login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../Audio/audio_player.dart';
// import '../Audio/audio_recorder.dart';

// class BiometricPage extends StatefulWidget {
//   final String village;
//   final String nextPage;
//   const BiometricPage(
//       {required this.village, required this.nextPage, super.key});
//   @override
//   _BiometricPageState createState() => _BiometricPageState();
// }

// class _BiometricPageState extends State<BiometricPage> {
//   File? _image;

//   bool showPlayer = false;
//   String? audioPath;
//   @override
//   void initState() {
//     showPlayer = false;

//     super.initState();
//   }


//   Widget _buildSmallTextField(
//       TextEditingController controller, String labelText,
//       {TextInputType? keyboardType}) {
//     return Container(
//       width: 200,
//       height: 50,
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

 
//   Future<void> _getImageFromCamera() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.camera,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Widget _buildFormField(String labelText, TextEditingController controller,
//       {TextInputType? keyboardType}) {
//     return Container(
//       margin: EdgeInsets.symmetric(
//           vertical: 10), // Adjust vertical margin as needed
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 100, // Adjust the width according to your preference
//                 child: Text(
//                   labelText,
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//               SizedBox(
//                 width: 20, // Adjust the space between label and text field
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   keyboardType: keyboardType,
//                   decoration: InputDecoration(
//                     hintText: 'Enter $labelText',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: HamburgerMenu(
//         userName: LoginPage.userId,
//         email: LoginPage.username,
//         pages: [
//           SurveyorPageUtil(),
//           LoginPage(),
//           NetworkSpeedChecker(),
//         ],
//         icons: [
//           Icons.home,
//           Icons.logout,
//           Icons.network_cell_rounded,
//         ],
//         pageTitles: ['Home', 'Log out', 'Bandwidth'],
//       ),
//       appBar: AppBar(
//         title: Text('Biometric Page'),
//          actions: [
//           IconButton(
//               onPressed: () => {Navigator.pop(context)},
//               icon: Icon(Icons.arrow_back_rounded)),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const Text(
//                     'Take Biometric',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _image == null
//                       ? const Text('No image selected.')
//                       : Image.file(
//                           _image!,
//                           height: 100,
//                           width: 100,
//                         ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _getImageFromCamera,
//                     child: const Text("Take a Picture"),
//                   ),
//                   SizedBox(
//                     height: 200,
//                     child: Center(
//                       child: showPlayer
//                           ? Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 25),
//                               child: AudioPlayer(
//                                 source: audioPath!,
//                                 onDelete: () {
//                                   setState(() => showPlayer = false);
//                                 },
//                               ),
//                             )
//                           : Recorder(
//                               onStop: (path) {
//                                 print('Recorded file path: $path');
//                                 setState(() {
//                                   audioPath = path;
//                                   showPlayer = true;
//                                 });
//                               },
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () async {
//                       print('create subject is clicked');
//                       print('came out');
//                     },
//                     icon: const Icon(Icons.person, size: 30),
//                     label: const Text('Take Biometric'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
