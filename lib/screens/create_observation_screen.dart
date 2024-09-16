import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sk_ams/screens/editobservationscreen.dart';

class CreateObservationScreen extends StatefulWidget {
  const CreateObservationScreen({super.key});

  @override
  _CreateObservationScreenState createState() =>
      _CreateObservationScreenState();
}

class _CreateObservationScreenState extends State<CreateObservationScreen> {
  final TextEditingController _inspectionByController = TextEditingController();
  final TextEditingController _inspectionTeamController =
      TextEditingController();
  final TextEditingController _inspectionDateController =
      TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _actionToBeTakenController =
      TextEditingController();
  final TextEditingController _impactOfDeviationsController =
      TextEditingController();
  final TextEditingController _evidenceForNCsClosureController =
      TextEditingController();

  String _criticality = 'High';
  String _status = 'Open';

  final List<File> _referenceImages = [];
  final List<File?> _evidenceImages = []; // List to hold evidence images

  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _observations =
      []; // List to store observations

  Future<void> _pickImage(
      ImageSource source, String imageType, int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Process the image to add watermark and timestamp
        File watermarkedImage = await _addWatermark(imageFile);

        setState(() {
          if (imageType == 'reference') {
            _referenceImages.add(watermarkedImage);
          } else if (imageType == 'evidence') {
            if (index < _evidenceImages.length) {
              _evidenceImages[index] = watermarkedImage;
            } else {
              _evidenceImages.add(watermarkedImage);
            }
          }
        });
      }
    } catch (e) {
      // Handle errors here, such as permissions issues
      print('Error picking image: $e');
    }
  }

  Future<File> _addWatermark(File imageFile) async {
    // Load the image file
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;

    // Load the watermark image
    img.Image watermark = img.decodeImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    )!;

    // Resize the watermark image to be smaller
    watermark = img.copyResize(watermark, width: 200, height: 50);

    // Add watermark to image at the bottom-right corner
    img.drawImage(image, watermark,
        dstX: image.width - watermark.width - 10,
        dstY: image.height - watermark.height - 10);

    // Add timestamp to image
    String timestamp = DateTime.now().toIso8601String();
    img.drawString(image, img.arial_24, 10, image.height - 30, timestamp,
        color: img.getColor(255, 255, 255)); // Use 'getColor'

    // Save the image
    File watermarkedFile = File('${imageFile.path}_watermarked.png');
    watermarkedFile.writeAsBytesSync(img.encodePng(image));

    return watermarkedFile;
  }

  void _viewImage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('View Image'),
          ),
          body: Center(
            child: Image.file(image),
          ),
        ),
      ),
    );
  }

  void _deleteImage(String imageType, int index) {
    setState(() {
      if (imageType == 'reference') {
        _referenceImages.removeAt(index);
      } else if (imageType == 'evidence') {
        if (index < _evidenceImages.length) {
          _evidenceImages[index] = null;
        }
      }
    });
  }

  void _addMoreEvidenceImage() {
    setState(() {
      _evidenceImages.add(null); // Add a new placeholder for the next image
    });
  }

  void _submitForm() {
    // Collect the data
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

    // Add observation to the list
    setState(() {
      _observations.add(observation);
    });

    // Reset the form or navigate to another screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditObservationListScreen(
          observations: _observations,
        ),
      ),
    );
  }

  void _showImageSourceDialog(String imageType, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery, imageType, index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera, imageType, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Create Observation",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_inspectionByController, 'Inspection By'),
            const SizedBox(height: 12),
            _buildTextField(_inspectionTeamController, 'Inspection Team'),
            const SizedBox(height: 12),
            _buildDatePickerField(_inspectionDateController, 'Inspection Date'),
            const SizedBox(height: 12),
            _buildTextField(_observationsController, 'Observations'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                      'Criticality', ['High', 'Medium', 'Low'], (value) {
                    setState(() {
                      _criticality = value!;
                    });
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown('Status', ['Open', 'Closed'], (value) {
                    setState(() {
                      _status = value!;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildImagePicker('Reference Photos', 'reference'),
            const SizedBox(height: 12),
            _buildTextField(_targetDateController, 'Target Date for Closure'),
            const SizedBox(height: 12),
            _buildTextField(_actionToBeTakenController, 'Action to be Taken'),
            const SizedBox(height: 12),
            _buildTextField(
                _impactOfDeviationsController, 'Impact of Deviations'),
            const SizedBox(height: 12),
            _buildTextField(
                _evidenceForNCsClosureController, 'Evidence for NCs Closure'),
            const SizedBox(height: 24),
            _buildEvidenceImagePicker(),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor:
                      Colors.green[400], // Change background color to green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Add elevation for shadow effect
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18, // Increase font size
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.white, // Change text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePickerField(
      TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate = pickedDate.toIso8601String().split('T')[0];
          setState(() {
            controller.text = formattedDate;
          });
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(
      String labelText, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: options.first,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImagePicker(String label, String imageType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _referenceImages.map((image) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => _viewImage(image),
                  child: Image.file(image,
                      width: 100, height: 100, fit: BoxFit.cover),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteImage(
                        'reference', _referenceImages.indexOf(image)),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => _showImageSourceDialog(imageType, 0),
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Image'),
        ),
      ],
    );
  }

  Widget _buildEvidenceImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Evidence Photos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          children: _evidenceImages.asMap().entries.map((entry) {
            int index = entry.key;
            File? image = entry.value;
            return Column(
              children: [
                if (image != null)
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _viewImage(image),
                        child: Image.file(image,
                            width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteImage('evidence', index),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showImageSourceDialog('evidence', index),
                  icon: const Icon(Icons.add_a_photo),
                  label: Text('Add Evidence Image ${index + 1}'),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _addMoreEvidenceImage,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '+ Add More Evidence',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
