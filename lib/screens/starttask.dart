import 'package:flutter/material.dart';
import 'dart:convert'; // For encoding and decoding JSON
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'task_form.dart'; // Import the TaskFormScreen
import 'package:http/http.dart' as http;
import 'package:sk_ams/screens/Tasklistscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // For file handling
import 'package:permission_handler/permission_handler.dart';


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
  List<String> tasks =
  []; // Task list (will be fetched from API or local storage)
  Map<String, List<String>> subtasks =
  {}; // Subtask list (will be fetched from API or local storage

  @override
  void initState() {
    super.initState();
    _loadDataFromLocalStorage(); // Load data from local storage
    _fetchDataFromApi(); // Fetch data from API on screen load
  }

  // Function to load data from local storage
  Future<void> _loadDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve saved tasks and subtasks from local storage
    final String? storedTasks = prefs.getString('tasks');
    final String? storedSubtasks = prefs.getString('subtasks');

    // If data exists in local storage, decode it and update the state
    if (storedTasks != null && storedSubtasks != null) {
      setState(() {
        tasks = List<String>.from(
            json.decode(storedTasks)); // Convert JSON to List<String>
        subtasks = Map<String, List<String>>.from(
            json.decode(storedSubtasks)); // Convert JSON to Map
        isLoading = false; // Set loading state to false since data is available
      });

      // Initialize checked subtasks based on loaded data
      subtasks.values.expand((subtasks) => subtasks).forEach((subtask) {
        checkedSubtasks[subtask] = false;
      });
    }
  }

  bool _validateFields() {
    // Check if all tasks are checked
    for (String task in tasks) {
      if (!_isTaskChecked(task)) {
        return false; // Found a task that is not checked
      }

      // Check if all subtasks for the task are also checked
      final subtasksForTask = subtasks[task] ?? [];
      for (String subtask in subtasksForTask) {
        if (!(checkedSubtasks[subtask] ?? false)) {
          return false; // Found a subtask that is not checked
        }
      }
    }

    return true; // All checks passed
  }

  // Function to fetch data from the API and save it to local storage
  Future<void> _fetchDataFromApi() async {
    try {
      // Simulate API call with Future.delayed
      await Future.delayed(
        const Duration(seconds: 2), // Simulate network delay
      );

      // Uncomment and replace this section with actual API call
      /*
      final response = await http.get('https://your-api-url.com/tasks');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          tasks = data['tasks'];
          subtasks = data['subtasks'];

          // Save tasks and subtasks to local storage
          _saveDataToLocalStorage();

          isLoading = false; // Set loading state to false once data is loaded
        });
      } else {
        throw Exception('Failed to load tasks');
      }
      */

      // Temporary hardcoded sample data for demonstration (remove this later)
      setState(() {
        tasks = ['API Task 1', 'API Task 2', 'API Task 3'];
        subtasks = {
          'API Task 1': ['API Subtask 1.1', 'API Subtask 1.2'],
          'API Task 2': ['API Subtask 2.1', 'API Subtask 2.2'],
          'API Task 3': ['API Subtask 3.1', 'API Subtask 3.2'],
        };

        // Save tasks and subtasks to local storage
        _saveDataToLocalStorage();

        // Initialize checked subtasks based on new data
        subtasks.values.expand((subtasks) => subtasks).forEach((subtask) {
          checkedSubtasks[subtask] = false;
        });

        isLoading = false; // Set loading state to false once data is loaded
      });
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Set loading state to false in case of an error
      });
    }
  }

  Map<String, dynamic> _buildTaskData() {
    return {
      "projects": [ // Single main array for projects
        {
          "project_name": "Project name",
          // Replace with actual project name
          "description": "Project description",
          // Replace with actual project description
          "inspections": [
            {
              "inspection_name": "Inspection name",
              // Replace with actual inspection name
              "description": "Inspection description",
              // Replace with actual description
              "tasks": tasks.map((task) {
                // Gather subtasks for the current task
                final taskSubtasks = subtasks[task]?.map((subtask) {
                  final isChecked = checkedSubtasks[subtask] ?? false;

                  return {
                    "name": subtask,
                    "response": isChecked
                        ? {
                      "taskName": subtask,
                      "details": "Some details",
                      // Replace with actual details
                      "taskCategory": "Category A",
                      // Replace with actual category
                      "taskDate": DateTime.now().toIso8601String(),
                      "photosDuringInspection": ["/path/to/photo1.jpg"],
                      // Replace as needed
                      "photosAfterRectification": [],
                      // Replace as needed
                      "additionalPhotos": []
                      // Replace as needed
                    }
                        : null,
                  };

                }).toList();

                return {
                  "name": task,
                  "subtasks": taskSubtasks ?? [],
                  // Include subtasks within the task
                };
              }).toList(),
            }
          ]
        }
      ]
    };
  }


  // Function to save data to local storage
  Future<void> _saveDataToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert tasks and subtasks to JSON strings and save them
    await prefs.setString('tasks', json.encode(tasks));
    await prefs.setString('subtasks', json.encode(subtasks));
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

      // If all subtasks for the task are checked, update the checkedTasks array
      if (_isTaskChecked(task)) {
        if (!_checkedTasks.contains(task)) {
          _checkedTasks.add(task);
        }
      } else {
        // If not all subtasks are checked, remove the task from checkedTasks
        _checkedTasks.remove(task);
      }

      // Log the updated state to the console
      print('Checked Tasks and Subtasks: $_checkedTasks');
    });
  }

  Future<void> _updateProjectJson(Map<String, dynamic> taskData) async {
    try {
      // Get the file path for projects.json
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/projects.json';
      final file = File(filePath);

      // Check if the file exists
      if (!await file.exists()) {
        print('projects.json file does not exist.');
        return;
      }

      // Read the existing content of the file
      final content = await file.readAsString();
      final data = json.decode(content) as List<dynamic>;

      // Find the target project (e.g., Project 1)
      final targetProject = data.firstWhere(
            (project) => project['project'] == 'Project 1', // Modify this as needed
        orElse: () => null,
      );

      if (targetProject == null) {
        print('Target project not found.');
        return;
      }

      // Debugging: Check the existing structure of the target project
      print('Target project before update: ${json.encode(targetProject)}');

      // Initialize createinspection and tasks if not present
      if (targetProject['createinspection'] == null) {
        targetProject['createinspection'] = {'tasks': []};
      }

      // Add the new task data to the createinspection tasks array
      final List<dynamic> tasks = targetProject['createinspection']['tasks'];
      tasks.add(taskData);

      // Debugging: Check the updated tasks array
      print('Updated tasks array: ${json.encode(tasks)}');

      // Write the updated content back to the file
      await file.writeAsString(json.encode(data));
      print('Task data added to projects.json successfully.');
    } catch (e) {
      print('Error updating projects.json: $e');
    }
  }
  Future<void> _sendDataToApiIfConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    final taskData = _buildTaskData(); // Prepare task data

    print('Updated taskData: ${json.encode(taskData)}'); // Log the structured data

    if (connectivityResult != ConnectivityResult.none) {
      // Online: Send data to API and save locally
      await _sendDataToApi(taskData);
    } else {
      // Offline: Notify user about offline saving
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text(
                'You are offline. Your response cannot be saved online. Data will be stored locally.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    // Save task data locally to `task_data.txt`
    await _saveDataToFileManager(json.encode(taskData));

    // Update `projects.json` with the new task
    await _updateProjectJson(taskData);
  }
  Future<void> _saveDataToFileManager(String data) async {
    try {
      // Check and request storage permissions
      if (await _requestStoragePermission()) {
        // Get the external storage directory
        final directory = Directory('/storage/emulated/0/Download'); // Downloads folder

        // Ensure the directory exists
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Create the file
        final filePath = '${directory.path}/task_data.txt';
        final file = File(filePath);

        // Write the data to the file
        await file.writeAsString(data);

        // Log the success and file path
        print('File saved successfully at: $filePath');
      } else {
        print('Storage permission denied');
      }
    } catch (e) {
      print('Error saving file to file manager: $e');
    }
  }


// Request storage permission
  Future<bool> _requestStoragePermission() async {
    // Request storage permission
    var status = await Permission.storage.request();

    if (status.isGranted) {
      return true; // Permission granted
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permanently denied
      await openAppSettings();
    }
    return false; // Permission denied
  }

  // Function to send data to API
  Future<void> _sendDataToApi(Map<String, dynamic> data) async {
    const String apiUrl =
        'https://webigosolutions.in/api3.php'; // Replace with your API endpoint

    try {
      // Convert the data map to JSON
      String jsonBody = json.encode(data);

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonBody,
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Successfully sent the data
        print('Data sent successfully: ${response.body}');
      } else {
        // Handle the error
        print('Failed to send data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error sending data to API: $e');
    }
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
                    'Select Tasks',
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
                        if (!_validateFields()) {
                          // Show an error message if validation fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete all mandatory tasks and subtasks before proceeding.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return; // Exit the method if validation fails
                        }

                        // Attempt to send data to API or save locally if offline
                        _sendDataToApiIfConnected();
                        print('Final Checked Tasks: $_checkedTasks');

                        // Show the dialog for next action
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Task Completed'),
                              content: const Text('Do you want to go to the next task or go back to the task list?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Back to Task List'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => const TaskListScreen()),
                                    ); // Navigate to TaskListScreen
                                  },
                                ),
                                TextButton(
                                  child: const Text('Next Task'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => const StartTaskScreen()),
                                    ); // Navigate to the next StartTaskScreen
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
          color: Theme.of(context).cardColor, // Background color for card
          child: Column(
            children: [
              ListTile(
                leading: Checkbox(
                  value: _isTaskChecked(task),
                  onChanged: null, // Disable manual checking
                ),
                title: Text(
                  task,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color, // Text color for dark mode
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).iconTheme.color,
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
                    color: Theme.of(context)
                        .colorScheme
                        .surface, // Background color for subtasks
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
                            title: Text(
                              subtask,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color, // Text color for dark mode
                              ),
                            ),
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
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(taskName: subtask),
                  ),
                );

                // Check if the task form was successfully submitted
                if (result == true) {
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

                    // Log the updated state to the console
                    print('Checked Tasks after edit: $_checkedTasks');
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
