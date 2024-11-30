import 'package:flutter/material.dart';

class ObservationEditScreen extends StatefulWidget {
  final Map<String, dynamic>? observation;

  const ObservationEditScreen({super.key, this.observation});

  @override
  _ObservationEditScreenState createState() => _ObservationEditScreenState();
}

class _ObservationEditScreenState extends State<ObservationEditScreen> {
  final TextEditingController _inspectionByController = TextEditingController();
  final TextEditingController _inspectionTeamController = TextEditingController();
  final TextEditingController _inspectionDateController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _actionToBeTakenController = TextEditingController();
  final TextEditingController _impactOfDeviationsController = TextEditingController();
  final TextEditingController _evidenceForNCsClosureController = TextEditingController();

  String? _criticality;
  String? _status;
  List<String> _referenceImages = [];
  List<String> _evidenceImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.observation != null) {
      _inspectionByController.text = widget.observation!['inspectionBy'] ?? '';
      _inspectionTeamController.text = widget.observation!['inspectionTeam'] ?? '';
      _inspectionDateController.text = widget.observation!['inspectionDate'] ?? '';
      _observationsController.text = widget.observation!['observations'] ?? '';
      _targetDateController.text = widget.observation!['targetDate'] ?? '';
      _actionToBeTakenController.text = widget.observation!['actionToBeTaken'] ?? '';
      _impactOfDeviationsController.text = widget.observation!['impactOfDeviations'] ?? '';
      _evidenceForNCsClosureController.text = widget.observation!['evidenceForNCsClosure'] ?? '';
      _criticality = widget.observation!['criticality'];
      _status = widget.observation!['status'];
      _referenceImages = List<String>.from(widget.observation!['referenceImages'] ?? []);
      _evidenceImages = List<String>.from(widget.observation!['evidenceImages'] ?? []);
    }
  }

  void _submitForm() {
    Map<String, dynamic> observation = {
      'inspectionBy': _inspectionByController.text,
      'inspectionTeam': _inspectionTeamController.text,
      'inspectionDate': _inspectionDateController.text,
      'observations': _observationsController.text,
      'targetDate': _targetDateController.text,
      'actionToBeTaken': _actionToBeTakenController.text,
      'impactOfDeviations': _impactOfDeviationsController.text,
      'evidenceForNCsClosure': _evidenceForNCsClosureController.text,
      'criticality': _criticality,
      'status': _status,
      'referenceImages': _referenceImages,
      'evidenceImages': _evidenceImages,
    };

    Navigator.pop(context, observation); // Return the observation data back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Observation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _inspectionByController,
                decoration: const InputDecoration(labelText: 'Inspection By'),
              ),
              TextField(
                controller: _inspectionTeamController,
                decoration: const InputDecoration(labelText: 'Inspection Team'),
              ),
              TextField(
                controller: _inspectionDateController,
                decoration: const InputDecoration(labelText: 'Inspection Date'),
              ),
              TextField(
                controller: _observationsController,
                decoration: const InputDecoration(labelText: 'Observations'),
              ),
              TextField(
                controller: _targetDateController,
                decoration: const InputDecoration(labelText: 'Target Date'),
              ),
              TextField(
                controller: _actionToBeTakenController,
                decoration: const InputDecoration(labelText: 'Action to be Taken'),
              ),
              TextField(
                controller: _impactOfDeviationsController,
                decoration: const InputDecoration(labelText: 'Impact of Deviations'),
              ),
              TextField(
                controller: _evidenceForNCsClosureController,
                decoration: const InputDecoration(labelText: 'Evidence for NCs Closure'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}