import 'package:flutter/material.dart';

class EditObservationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>
      observation; // Using a Map to pass all observation details

  const EditObservationDetailsScreen({
    super.key,
    required this.observation,
  });

  @override
  _EditObservationDetailsScreenState createState() =>
      _EditObservationDetailsScreenState();
}

class _EditObservationDetailsScreenState
    extends State<EditObservationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _observationName;
  late String _inspectionBy;
  late String _inspectionTeam;
  late String _inspectionDate;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with observation data
    _observationName = widget.observation['observationName'] ?? '';
    _inspectionBy = widget.observation['inspectionBy'] ?? '';
    _inspectionTeam = widget.observation['inspectionTeam'] ?? '';
    _inspectionDate = widget.observation['inspectionDate'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Edit Observation",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(
                  label: "Observation Name",
                  initialValue: _observationName,
                  onSaved: (value) => _observationName = value!,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: "Inspection By",
                  initialValue: _inspectionBy,
                  onSaved: (value) => _inspectionBy = value!,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: "Inspection Team",
                  initialValue: _inspectionTeam,
                  onSaved: (value) => _inspectionTeam = value!,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: "Inspection Date",
                  initialValue: _inspectionDate,
                  onSaved: (value) => _inspectionDate = value!,
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement saving logic here, such as updating the database or state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved!')),
      );
    }
  }
}
