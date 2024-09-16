import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks & Inspections',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks & Inspections'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: const Text('Tasks'),
              leading: const Icon(Icons.task, size: 40),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TasksScreen(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: const Text('Inspections'),
              //leading: Icon(Icons.inspection.png, size: 40),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InspectionsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
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
        child: Text('Tasks List will be shown here'),
      ),
    );
  }
}

class InspectionsScreen extends StatelessWidget {
  const InspectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspections'),
      ),
      body: const Center(
        child: Text('Inspections List will be shown here'),
      ),
    );
  }
}
