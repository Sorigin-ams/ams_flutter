import 'package:flutter/material.dart';

class InspectionAndTasksScreen extends StatelessWidget {
  const InspectionAndTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspections and Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the upcoming inspections screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpcomingInspectionScreen(),
                  ),
                );
              },
              child: const Text('View Upcoming Inspection'),
            ),
            const SizedBox(height: 20), // Add some space between the buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to the tasks screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TasksScreen(),
                  ),
                );
              },
              child: const Text('View Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingInspectionScreen extends StatelessWidget {
  const UpcomingInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Inspections'),
      ),
      body: const Center(
        child: Text('Upcoming Inspections Content'),
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: const Center(
        child: Text('Tasks Content'),
      ),
    );
  }
}
