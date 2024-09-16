// lib/models/inspection_model.dart

import 'package:flutter/material.dart';

class InspectionModel {
  final int id;
  final String inspectionName;
  final String description;
  final String imageUrl;
  final IconData icon;

  InspectionModel({
    required this.id,
    required this.inspectionName,
    required this.description,
    required this.imageUrl,
    required this.icon,
  });
}

List<InspectionModel> inspections = [
  InspectionModel(
    id: 1,
    inspectionName: 'Inspection 1',
    description: 'Description of Inspection 1',
    imageUrl:
        'assets/icons/inspection.png', // Update the path based on your assets
    icon: Icons.report, // Example icon
  ),
  InspectionModel(
    id: 2,
    inspectionName: 'Inspection 2',
    description: 'Description of Inspection 2',
    imageUrl:
        'assets/icons/inspection.png', // Update the path based on your assets
    icon: Icons.report, // Example icon
  ),
  // Add more inspections as needed
];
