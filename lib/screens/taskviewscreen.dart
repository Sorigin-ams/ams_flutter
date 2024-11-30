import 'package:flutter/material.dart';
import 'package:sk_ams/screens/starttask.dart'; // Import the StartTaskScreen
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing

class TaskViewScreen extends StatefulWidget {
  final String taskName;

  const TaskViewScreen({super.key, required this.taskName});

  @override
  _TaskViewScreenState createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  late Future<Map<String, String>> taskDetails;

  @override
  void initState() {
    super.initState();
    taskDetails = _fetchDataFromApi();
  }

  Future<Map<String, String>> _fetchDataFromApi() async {
    try {
      // Replace with your API URL
      final response = await http.get(Uri.parse('https://example.com/api/task'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Map the response to match your Table structure
        return {
          'Site': data['site'] ?? 'N/A',
          'Location Number': data['location_number'] ?? 'N/A',
          'WTG Model': data['wtg_model'] ?? 'N/A',
          'Date Of Inspection': data['date_of_inspection'] ?? 'N/A',
          'Inspection Team Members':
          (data['inspection_team_members'] as List<dynamic>).join(', ') ?? 'N/A',
          'Service Provider':
          (data['service_provider'] as List<dynamic>).join(', ') ?? 'N/A',
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Provide default or error values if needed
      return {
        'Site': 'Error',
        'Location Number': 'Error',
        'WTG Model': 'Error',
        'Date Of Inspection': 'Error',
        'Inspection Team Members': 'Error',
        'Service Provider': 'Error',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Use theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.taskName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'AMS Audit Checklist',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<Map<String, String>>(
              future: taskDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                } else {
                  final taskDetails = snapshot.data!;
                  return Table(
                    columnWidths: const {
                      0: FixedColumnWidth(150),
                      1: FlexColumnWidth(), // Adjust column width dynamically
                    },
                    border: TableBorder.all(),
                    children: taskDetails.entries.map((entry) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(entry.key),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(entry.value),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StartTaskScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.green[400],
                ),
                child: const Text(
                  'Start Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
