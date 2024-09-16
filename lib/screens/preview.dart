import 'package:flutter/material.dart';

class InspectionDetailsScreen extends StatelessWidget {
  final String inspectionName;
  final String wtgCapacity;
  final String closedNCs;
  final String siteName;
  final String openNCs;
  final String inspectionBy;
  final String inspectionTeam;
  final String dateOfInspection;
  final String taskDone;

  const InspectionDetailsScreen({
    super.key,
    required this.inspectionName,
    required this.wtgCapacity,
    required this.closedNCs,
    required this.siteName,
    required this.openNCs,
    required this.inspectionBy,
    required this.inspectionTeam,
    required this.dateOfInspection,
    required this.taskDone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Inspection Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField("WTG Name:", inspectionName),
            _buildField("WTG Capacity (MW):", wtgCapacity),
            _buildField("Closed NCs:", closedNCs),
            _buildField("Site Name:", siteName),
            _buildField("Open NCs:", openNCs),
            _buildField("Inspection By (Cu.):", inspectionBy),
            _buildField("Inspection Team (OEM):", inspectionTeam),
            _buildField("Date of Inspection:", dateOfInspection),
            _buildField("Task Done:", taskDone),
            const SizedBox(height: 24), // Adds space before the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement the PDF download logic here
                  },
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text(
                    "Download PDF",
                    style: TextStyle(
                      color: Colors.white, // White text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300], // Red background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement the Excel download logic here
                  },
                  icon: const Icon(Icons.table_chart,
                      color: Colors.white), // Excel icon
                  label: const Text(
                    "Download Excel",
                    style: TextStyle(
                      color: Colors.white, // White text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300], // Red background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipRect(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
