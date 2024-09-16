import 'package:flutter/material.dart';
import 'package:sk_ams/models/inspection_model.dart'; // Ensure this import is correct
import 'package:sk_ams/screens/start_insp.dart'; // Import the start_insp.dart file

class InspectionFragment extends StatefulWidget {
  const InspectionFragment({super.key});

  @override
  State<InspectionFragment> createState() => _InspectionFragmentState();
}

class _InspectionFragmentState extends State<InspectionFragment> {
  @override
  void initState() {
    super.initState();
    _fetchDataFromApi(); // Fetch data when the screen is initialized
  }

  // Method to fetch data from the API
  Future<void> _fetchDataFromApi() async {
    try {
      // Simulate API call with Future.delayed
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate network delay

      // In a real scenario, you would parse the response and update the inspections list
      setState(() {
        // Update the list with fetched data
        // Example:
        // inspections = fetchedData.map((data) => InspectionModel.fromJson(data)).toList();
      });
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
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
            // Dynamically generate the list of inspections
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
                        child: Image.asset(inspection.imageUrl),
                      ),
                      title: Text(
                        inspection.inspectionName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        inspection.description,
                        style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[700]),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartInspscreen(
                                fromProfile: false,
                                index: 0,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? Colors.blueGrey[800]
                              : Colors.green[400],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Start'),
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
