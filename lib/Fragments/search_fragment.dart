import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sk_ams/screens/projectsdescription.dart'; // Import the projectdescription.dart file

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

Future<void> fetchAndSaveServices() async {
  try {
    final response = await http.get(Uri.parse('https://webigosolutions.in/apitest.php?type=project_list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      List<ServicesModel> services = data.map((json) => ServicesModel.fromJson(json)).toList();

      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/services.json';
      final file = File(path);
      final jsonData = jsonEncode(services.map((service) => service.toJson()).toList());
      await file.writeAsString(jsonData);

      print('Data saved to $path');
    } else {
      throw Exception('Failed to load projects');
    }
  } catch (e) {
    print('Error fetching and saving services: $e');
  }
}

Future<List<ServicesModel>> loadServicesFromFile() async {
  try {
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/services.json';
    final file = File(path);

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      print('Data loaded from $path');
      return jsonData.map((jsonItem) => ServicesModel.fromJson(jsonItem)).toList();
    } else {
      print('File not found at $path');
      return [];
    }
  } catch (e) {
    print('Error loading data from file: $e');
    return [];
  }
}

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<ServicesModel>> _futureServices;
  List<ServicesModel> _allServices = []; // All services
  List<ServicesModel> _filteredServices = []; // Filtered services
  final TextEditingController _searchController = TextEditingController(); // Search bar controller

  @override
  void initState() {
    super.initState();
    _futureServices = loadServicesFromFile();
    _futureServices.then((services) {
      setState(() {
        _allServices = services;
        _filteredServices = services; // Initially, show all services
      });
    });
    _searchController.addListener(_filterServices); // Add listener for search
  }

  // Filter services based on search input
  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredServices = _allServices; // Show all services if no search query
      } else {
        _filteredServices = _allServices
            .where((service) =>
        service.title.toLowerCase().contains(query) ||
            service.description.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _refreshData() async {
    await fetchAndSaveServices();
    _futureServices = loadServicesFromFile();
    _futureServices.then((services) {
      setState(() {
        _allServices = services;
        _filteredServices = services; // Reset after refresh
      });
    });
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredServices.isEmpty
                ? const Center(child: Text('No projects found')) // Show if no results
                : ListView.builder(
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                final service = _filteredServices[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose search controller
    super.dispose();
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
