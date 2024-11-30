// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:sk_ams/models/project_model.dart';
//
// class JSONStorage {
//   static Future<File> _getFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return File('${directory.path}/projects.json');
//   }
//
//   static Future<List<Project>> readProjects() async {
//     try {
//       final file = await _getFile();
//       if (await file.exists()) {
//         final content = await file.readAsString();
//         final List<dynamic> jsonList = jsonDecode(content)['projects'];
//         return jsonList.map((e) => Project.fromJson(e)).toList();
//       }
//     } catch (e) {
//       print('Error reading projects: $e');
//     }
//     return [];
//   }
//
//   static Future<void> saveProjects(List<Project> projects) async {
//     final file = await _getFile();
//     final jsonString = jsonEncode({'projects': projects.map((e) => e.toJson()).toList()});
//     await file.writeAsString(jsonString);
//     print('Projects saved to ${file.path}');
//   }
// }
