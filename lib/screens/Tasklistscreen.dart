import 'package:flutter/material.dart';
import 'package:sk_ams/screens/taskviewscreen.dart'; // Import the task view screen


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Map<String, dynamic>>> _tasks;
  List<Map<String, dynamic>> _allTasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tasks = _fetchTasksFromApi();
    _tasks.then((taskList) {
      setState(() {
        _allTasks = taskList;
        _filteredTasks = taskList; // Initially show all tasks
      });
    });
    _searchController.addListener(_filterTasks);
  }

  Future<List<Map<String, dynamic>>> _fetchTasksFromApi() async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      final List<Map<String, dynamic>> sampleTasks = [
        {'name': 'Task 1', 'details': 'Details for Task 1'},
        {'name': 'Task 2', 'details': 'Details for Task 2'},
        {'name': 'Task 3', 'details': 'Details for Task 3'},
        {'name': 'Task 4', 'details': 'Details for Task 4'},
        {'name': 'Task 5', 'details': 'Details for Task 5'},
      ];

      return sampleTasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      return []; // Return an empty list on error
    }
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTasks = _allTasks; // Show all tasks if no search query
      } else {
        _filteredTasks = _allTasks
            .where((task) =>
            task['name'].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _refreshTasks() async {
    final updatedTasks = await _fetchTasksFromApi();
    setState(() {
      _allTasks = updatedTasks;
      _filteredTasks = updatedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Task List",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
            onPressed: _refreshTasks, // Manually trigger refresh
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTasks, // Pull-to-refresh functionality
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _tasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tasks available'));
            } else if (_filteredTasks.isEmpty) {
              return const Center(child: Text('No results found'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(
                          Icons.task,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          task['name'] ?? 'Unnamed Task',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          'Click to view details',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                        onTap: () {
                          _showTaskOptionsDialog(context, task);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _showTaskOptionsDialog(BuildContext context, Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: Text('Would you like to accept the task: ${task['name']}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the task view screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskViewScreen(
                      taskName: task['name'] ?? 'Unnamed Task',
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose search controller
    super.dispose();
  }
}
