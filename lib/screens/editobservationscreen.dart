import 'package:flutter/material.dart';
import 'package:sk_ams/screens/edit_observation_details_screen.dart'; // Import the edit observation details screen

class EditObservationListScreen extends StatelessWidget {
  final List<Map<String, dynamic>>
      observations; // List of observations passed to this screen

  const EditObservationListScreen({
    super.key,
    required this.observations, // Required parameter for the list of observations
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Edit Observations",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount:
            observations.length, // Number of items in the observations list
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
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
                leading: const Icon(
                  Icons.edit,
                  size: 30,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  'Observation ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Click to edit details',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // Navigate to the EditObservationDetailsScreen with observation details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditObservationDetailsScreen(
                        observation: observations[index],
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
