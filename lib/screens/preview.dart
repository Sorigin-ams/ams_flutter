import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> observations;

  const PreviewScreen({super.key, required this.observations});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<Map<String, dynamic>> _observations = [];

  @override
  void initState() {
    super.initState();
    _loadObservations(); // Load saved observations on start
  }

  // Load observations from shared preferences
  Future<void> _loadObservations() async {
    final prefs = await SharedPreferences.getInstance();
    final observationsString = prefs.getString('observations');
    if (observationsString != null) {
      setState(() {
        _observations = List<Map<String, dynamic>>.from(
          json.decode(observationsString),
        );
      });
    } else {
      setState(() {
        _observations = widget.observations;
      });
    }
  }

  // Save observations to shared preferences
  Future<void> _saveObservations() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('observations', json.encode(_observations));
  }

  // Delete an observation
  void _deleteObservation(int index) {
    setState(() {
      _observations.removeAt(index);
    });
    _saveObservations();
  }

  // Toggle observation status
  void _toggleStatus(int index) {
    setState(() {
      _observations[index]['isSent'] = !_observations[index]['isSent'];
    });
    _saveObservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Observations'),
      ),
      body: ListView.builder(
        itemCount: _observations.length,
        itemBuilder: (context, index) {
          var observation = _observations[index];
          bool isSent = observation['isSent'] ?? false;

          return ListTile(
            title: Text("Observation by ${observation['inspectionBy']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isSent ? 'Status: Sent' : 'Status: Pending'),
                if (observation['response'] != null)
                  Text('Response: ${observation['response']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: isSent ? Colors.grey : Colors.blue,
                  ),
                  onPressed: !isSent
                      ? () {
                    _toggleStatus(index); // Toggle status on resend
                  }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteObservation(index);
                  },
                ),
              ],
            ),
            onTap: () {
              // Additional actions if needed
            },
          );
        },
      ),
    );
  }
}
