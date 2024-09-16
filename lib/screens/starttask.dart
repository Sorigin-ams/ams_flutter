import 'package:flutter/material.dart';
import 'task_form.dart'; // Import the TaskFormScreen

class StartTaskScreen extends StatefulWidget {
  const StartTaskScreen({super.key});

  @override
  _StartTaskScreenState createState() => _StartTaskScreenState();
}

class _StartTaskScreenState extends State<StartTaskScreen> {
  String? expandedTask; // Track the task whose dropdown is currently open
  bool isLoading = true; // Track loading state

  // To track which subtasks are checked
  final Map<String, bool> checkedSubtasks = {};

  // To track fully checked tasks
  final List<String> _checkedTasks = [];

  // Arrays for main tasks and subtasks
  // Initializing with sample data; replace this with actual data from the API
  List<String> tasks = [];
  Map<String, List<String>> subtasks = {};

  @override
  void initState() {
    super.initState();
    _fetchDataFromApi();
  }

  // Function to fetch data from the API
  Future<void> _fetchDataFromApi() async {
    try {
      // Simulate API call with Future.delayed
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate network delay

      // Update tasks and subtasks with API data
      setState(() {
        tasks = ['API Task 1', 'API Task 2', 'API Task 3'];
        subtasks = {
          'API Task 1': ['API Subtask 1.1', 'API Subtask 1.2'],
          'API Task 2': ['API Subtask 2.1', 'API Subtask 2.2'],
          'API Task 3': ['API Subtask 3.1', 'API Subtask 3.2'],
        };

        // Initialize checked subtasks based on new data
        subtasks.values.expand((subtasks) => subtasks).forEach((subtask) {
          checkedSubtasks[subtask] = false;
        });

        // Set loading state to false once data is loaded
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
      // Optionally, you might want to set isLoading to false here too
    }
  }

  // Check if all subtasks for a task are checked
  bool _isTaskChecked(String task) {
    final subtasksForTask = subtasks[task] ?? [];
    return subtasksForTask
        .every((subtask) => checkedSubtasks[subtask] ?? false);
  }

  // Handle checking/unchecking the task's checkbox
  void _onSubtaskCheckboxChanged(String subtask, bool? value) {
    setState(() {
      checkedSubtasks[subtask] = value ?? false;

      // Find the task corresponding to this subtask
      final task = subtasks.entries
          .firstWhere((entry) => entry.value.contains(subtask))
          .key;

      // If the subtask is checked, add it to _checkedTasks; otherwise, remove it
      if (checkedSubtasks[subtask] == true) {
        if (!_checkedTasks.contains(subtask)) {
          _checkedTasks.add(subtask);
        }
      } else {
        _checkedTasks.remove(subtask);
      }

      // If all subtasks for the task are checked, add the task to checkedTasks
      if (_isTaskChecked(task)) {
        if (!_checkedTasks.contains(task)) {
          _checkedTasks.add(task);
        }
      } else {
        // If not all subtasks are checked, remove the task from checkedTasks
        _checkedTasks.remove(task);
      }

      // Log the checkedTasks array to the console
      print('Checked Tasks and Subtasks: $_checkedTasks');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Task'),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Checklist Form',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Task (required):',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTaskList(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle complete task action
                        print('Final Checked Tasks: $_checkedTasks');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.green[400], // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Complete Task',
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

  // Function to build the task list with dropdown arrows
  Widget _buildTaskList() {
    return Column(
      children: tasks.map((String task) {
        final isExpanded = expandedTask == task;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              ListTile(
                leading: Checkbox(
                  value: _isTaskChecked(task),
                  onChanged: null, // Disable manual checking
                ),
                title: Text(
                  task,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    if (expandedTask == task) {
                      expandedTask = null;
                    } else {
                      expandedTask = task;
                    }
                  });
                },
              ),
              if (isExpanded)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Column(
                    children: subtasks[task]?.map((String subtask) {
                          return ListTile(
                            leading: Checkbox(
                              value: checkedSubtasks[subtask] ?? false,
                              onChanged: (bool? value) {
                                _onSubtaskCheckboxChanged(subtask, value);
                              },
                            ),
                            title: Text(subtask),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(subtask);
                              },
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Function to show an edit dialog
  void _showEditDialog(String subtask) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Subtask'),
          content: Text('Would you like to edit the subtask: $subtask?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Edit'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                // Navigate to TaskFormScreen and wait for the result
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(taskName: subtask),
                  ),
                );

                // After returning from TaskFormScreen, mark the checkbox as checked
                setState(() {
                  checkedSubtasks[subtask] = true;

                  // Update the checkedTasks array
                  final task = subtasks.entries
                      .firstWhere((entry) => entry.value.contains(subtask))
                      .key;

                  if (_isTaskChecked(task)) {
                    if (!_checkedTasks.contains(task)) {
                      _checkedTasks.add(task);
                    }
                  } else {
                    _checkedTasks.remove(task);
                  }

                  // Log the checkedTasks array to the console
                  print('Checked Tasks: $_checkedTasks');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
