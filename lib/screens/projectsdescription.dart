import 'package:flutter/material.dart';
import 'package:sk_ams/screens/inspections.dart';
import 'package:sk_ams/screens/Tasklistscreen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectName;


  const ProjectDetailScreen({super.key, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectName,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity, // Take full width of the screen
              margin: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InspectionFragment(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(

                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: isDarkMode
                      ? const Color(0xFF212121) // Dark mode button color
                      : const Color(0xFFF5F5F5), // Light gray for light mode
                  elevation: 10.0,
                  shadowColor: Colors.black45,
                ),
                child: Text(
                  'View Inspections',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black, // Adjusted for dark mode
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity, // Take full width of the screen
              margin: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskListScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 46.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: isDarkMode
                      ? const Color(0xFF424242) // Dark mode button color
                      : const Color(0xFFF5F5F5), // Light gray for light mode
                  elevation: 10.0,
                  shadowColor: Colors.black45,
                ),
                child: Text(
                  'View Tasks',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black, // Adjusted for dark mode
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200], // Background color for the body
    );
  }
}
