// import 'package:flutter/material.dart';
// import 'package:sk_ams/screens/create_observation_screen.dart';
// import 'package:sk_ams/screens/editobservationscreen.dart'; // Correct import
// import 'package:sk_ams/screens/inspection_list_screen.dart';
//
// import 'package:sk_ams/main.dart';
// import 'package:sk_ams/screens/preview.dart';
// import 'package:flutter/material.dart';
// import 'package:sk_ams/screens/create_observation_screen.dart';
//
// class StartInspscreen extends StatefulWidget {
//   final int index;
//   final bool fromProfile;
//
//   const StartInspscreen({
//     super.key,
//     required this.index,
//     required this.fromProfile,
//   });
//
//   @override
//   State<StartInspscreen> createState() => _StartInspscreenState();
// }
//
// class _StartInspscreenState extends State<StartInspscreen> {
//   List<Map<String, dynamic>> observations = []; // Add or fetch observations here
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(
//           color: appStore.isDarkModeOn ? Colors.white : Colors.black,
//         ),
//         title: Text(
//           "Inspections",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w900,
//             fontSize: 18,
//             color: appStore.isDarkModeOn ? Colors.white : Colors.black,
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Image.asset(
//             'assets/images/plumber.jpg',
//             width: double.infinity,
//             height: 200,
//             fit: BoxFit.cover,
//           ),
//           const SizedBox(height: 16),
//           _buildOption(
//             icon: Icons.add,
//             text: "Create observation",
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CreateObservationScreen(),
//                 ),
//               );
//             },
//           ),
//           _buildOption(
//             icon: Icons.edit,
//             text: "Edit observation",
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>  EditObservationListScreen(),
//                 ),
//               );
//             },
//           ),
//           _buildOption(
//             icon: Icons.visibility,
//             text: "Preview observation",
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PreviewScreen(
//                     observations: observations, // Pass the observations list
//                   ),
//                 ),
//               );
//             },
//           ),
//           _buildOption(
//             icon: Icons.download,
//             text: "Download inspections (PDF/Excel)",
//             onTap: () {
//               // Implement navigation or functionality for Download inspections
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOption({
//     required IconData icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: appStore.isDarkModeOn
//               ? Colors.black
//               : Colors.grey.withOpacity(0.2),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: 24),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
