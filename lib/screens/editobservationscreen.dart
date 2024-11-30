import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditObservationListScreen extends StatefulWidget {
  const EditObservationListScreen({super.key});

  @override
  _EditObservationListScreenState createState() => _EditObservationListScreenState();
}

class _EditObservationListScreenState extends State<EditObservationListScreen> {
  List<Map<String, dynamic>> _observations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedObservations();
  }

  Future<void> _loadSavedObservations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedObservations = prefs.getStringList('observations') ?? [];

    setState(() {
      _observations = savedObservations
          .map((observationJson) => jsonDecode(observationJson) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _deleteObservation(int index) async {
    setState(() {
      _observations.removeAt(index);
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedObservations =
    _observations.map((observation) => jsonEncode(observation)).toList();
    await prefs.setStringList('observations', updatedObservations);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Observation deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Observations',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: _observations.isEmpty
          ? const Center(
        child: Text(
          'No observations found',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: _observations.length,
        itemBuilder: (context, index) {
          final observation = _observations[index];
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
                  'Observation ${index + 1}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildObservationDetail('Inspector:', observation['inspectionBy']),
                    _buildObservationDetail('Inspection Date:', observation['inspectionDate']),
                    _buildObservationDetail('Status:', observation['status']),
                    _buildObservationDetail('Criticality:', observation['criticality']),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black),
                  onPressed: () {
                    _deleteObservation(index);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildObservationDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: EditObservationListScreen(),
  ));
}
