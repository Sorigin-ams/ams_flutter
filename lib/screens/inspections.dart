import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Ensure you have this dependency in your pubspec.yaml
import 'package:sk_ams/screens/create_observation_screen.dart'; // Import the CreateObservationScreen


class InspectionFragment extends StatefulWidget {
  const InspectionFragment({super.key});

  @override
  State<InspectionFragment> createState() => _InspectionFragmentState();
}

class _InspectionFragmentState extends State<InspectionFragment> {
  List<Map<String, dynamic>> inspections = []; // List to hold inspection data

  @override
  void initState() {
    super.initState();
    _fetchDataFromApi(); // Fetch data when the screen is initialized
  }

  // Method to fetch data from the API and store it in a local file
  Future<void> _fetchDataFromApi() async {
    try {
      await Future.delayed(const Duration(seconds: 2));  // Simulate network delay

      // Hardcoded inspection data
      List<Map<String, dynamic>> fetchedData = [
        {
          'id': 1,
          'inspectionName': 'Inspection 1',
          'description': 'Description of Inspection 1',
          'imageUrl': 'assets/icons/inspection.png',
          'icon': 'Icons.report',
          'responses': [],  // Ensure responses field is there
        },
        {
          'id': 2,
          'inspectionName': 'Inspection 2',
          'description': 'Description of Inspection 2',
          'imageUrl': 'assets/icons/inspection.png',
          'icon': 'Icons.report',
          'responses': [],  // Ensure responses field is there
        },
      ];

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/inspections.json';
      final file = File(filePath);

      // Check if the file exists
      if (await file.exists()) {
        final existingData = jsonDecode(await file.readAsString());
        // Only update if the fetched data is different
        if (jsonEncode(existingData) != jsonEncode(fetchedData)) {
          await file.writeAsString(jsonEncode(fetchedData));
          inspections = fetchedData;
        } else {
          inspections = existingData;
        }
      } else {
        await file.writeAsString(jsonEncode(fetchedData));
        inspections = fetchedData;
      }

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'Icons.report':
        return Icons.report;
    // Add more cases for other icons as needed
      default:
        return Icons.help; // Default icon if not found
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent, // Transparent background
        title: Text(
          "Inspections",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // // Dynamically generate the list of inspections
            ...inspections.map((inspection) => Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(inspection['imageUrl']),
                  ),
                  title: Text(
                    inspection['inspectionName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    inspection['description'],
                    style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[700]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.preview, color: isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {
                          // Handle preview action
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Here you can collect the response for the inspection
                          String response = "Response for ${inspection['inspectionName']}";  // Example response

                          // Find the inspection by id and add the response
                          final inspectionIndex = inspections.indexWhere((inspection) => inspection['id'] == inspection['id']);
                          if (inspectionIndex != -1) {
                            inspections[inspectionIndex]['responses'].add(response);  // Add the response to the corresponding inspection

                            // Save the updated data to the JSON file
                            final directory = await getApplicationDocumentsDirectory();
                            final filePath = '${directory.path}/inspections.json';
                            final file = File(filePath);

                            // Write the updated inspections list to the file
                            await file.writeAsString(jsonEncode(inspections));

                            // Navigate to the CreateObservationScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateObservationScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.blueGrey[800] : Colors.green[400],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Start'),
                      ),

                    ],
                  ),
                  onTap: () {
                    // Handle the tap action if needed
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
// if i m clicking on inspect 1 strt button then the response from that will be stored in array inside the inspection 1.
// if i m clicking on inspect 2 strt button then the response from that will be stored in array inside the inspection 2.
// the inspection array stored in /data/data/com.example.sk_ams/app_flutter/inspections.json