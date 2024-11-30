// import 'package:flutter/material.dart';
// import 'package:sk_ams/screens/preview.dart'; // Import the inspection details screen
//
// class InspectionListScreen extends StatelessWidget {
//   const InspectionListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Example inspection list
//     final inspections = List.generate(10, (index) => 'Inspection ${index + 1}');
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           "Inspection List",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w900,
//             fontSize: 18,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: inspections.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(16),
//               leading: const Icon(
//                 Icons.description,
//                 size: 40,
//                 color: Colors.blueAccent,
//               ),
//               title: Text(
//                 inspections[index],
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               subtitle: const Text(
//                 'Click to view details',
//                 style: TextStyle(
//                   color: Colors.grey,
//                 ),
//               ),
//               onTap: () {
//                 // Navigate to the details screen with dummy data
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => InspectionDetailsScreen(
//                       inspectionName: 'Inspection ${index + 1}',
//                       wtgCapacity: '150 MW',
//                       closedNCs: '10',
//                       siteName: 'Site ${index + 1}',
//                       openNCs: '5',
//                       inspectionBy: 'John Doe',
//                       inspectionTeam: 'Team A',
//                       dateOfInspection: '2024-08-19',
//                       taskDone: '1/82',
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
