import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sk_ams/screens/projectsdescription.dart';

class ServicesModel {
  final int id;
  final String title;
  final String project;
  final String description;
  final String image;
  final String icon;

  ServicesModel(
      this.id,
      this.title,
      this.description,
      this.project,
      this.image,
      this.icon,
      );

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      json['id'],
      json['title'],
      json['description'],
      json['project'],
      json['image'],
      json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project': project,
      'image': image,
      'icon': icon,
    };
  }
}

Future<List<ServicesModel>> getServices() async {
  try {
    final response = await http.get(Uri.parse('https://webigosolutions.in/apitest.php?type=project_list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      List<ServicesModel> services = data.map((json) => ServicesModel.fromJson(json)).toList();
      return services;
    } else {
      throw Exception('Failed to load projects');
    }
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}

Future<bool> hasInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<ServicesModel> _services = [];
  List<ServicesModel> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchTextChanged);
  }

  // Get file path for local storage
  Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  // Save data to both projects.json and inspections.json
  Future<void> _saveToFile(List<ServicesModel> services) async {
    try {
      // Save to projects.json
      final projectsFilePath = await _getFilePath('projects.json');
      final projectsFile = File(projectsFilePath);
      List<Map<String, dynamic>> jsonData =
      services.map((service) => service.toJson()).toList();
      await projectsFile.writeAsString(jsonEncode(jsonData));
      print("Data saved to file: $projectsFilePath");

      // Save to inspections.json
      final inspectionsFilePath = await _getFilePath('inspections.json');
      final inspectionsFile = File(inspectionsFilePath);
      await inspectionsFile.writeAsString(jsonEncode(jsonData));
      print("Data saved to file: $inspectionsFilePath");
    } catch (e) {
      print("Error saving data to file: $e");
    }
  }

  // Load data from the local file
  Future<List<ServicesModel>> _loadFromFile() async {
    try {
      final filePath = await _getFilePath('projects.json');
      final file = File(filePath);
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(content);
        return jsonData.map((json) => ServicesModel.fromJson(json)).toList();
      } else {
        print("File does not exist.");
        return [];
      }
    } catch (e) {
      print("Error reading data from file: $e");
      return [];
    }
  }

  // Load data (from API or local storage)
  Future<void> _loadData() async {
    if (await hasInternetConnection()) {
      List<ServicesModel> services = await getServices();
      setState(() {
        _services = services;
        _filteredServices = services;
      });
      await _saveToFile(services); // Save to local files (projects.json & inspections.json)
      print("Loaded services from API: ${jsonEncode(services.map((s) => s.toJson()).toList())}");
    } else {
      _showNoInternetPopup();
      List<ServicesModel> services = await _loadFromFile(); // Load from local file
      if (services.isEmpty) {
        _showNoDataPopup();
      }
      setState(() {
        _services = services;
        _filteredServices = services;
      });
      print("Loaded services from file: ${jsonEncode(services.map((s) => s.toJson()).toList())}");
    }
  }

  // Search filter
  void _onSearchTextChanged() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredServices = _services
          .where((service) =>
      service.title.toLowerCase().contains(searchText) ||
          service.description.toLowerCase().contains(searchText))
          .toList();
    });
  }

  // No Internet Popup
  void _showNoInternetPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet connection.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // No Data Popup
  void _showNoDataPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Data Available'),
        content: const Text('No data available in local storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Refresh data manually
  Future<void> _refreshData() async {
    if (await hasInternetConnection()) {
      await _loadData();
    } else {
      _showNoInternetPopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Projects',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filteredServices.isEmpty
          ? const Center(child: Text('No result found'))
          : ListView.builder(
        itemCount: _filteredServices.length,
        itemBuilder: (context, index) {
          final service = _filteredServices[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  service.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  service.description,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                leading: Image.asset(
                  service.icon,
                  width: 30,
                  height: 30,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreen(
                        projectName: service.project,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchFragment extends StatelessWidget {
  const SearchFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectListScreen();
  }
}

void main() {
  runApp(const MaterialApp(
    home: SearchFragment(),
  ));
}
