import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:sk_ams/screens/editobservationscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedObservations = prefs.getStringList('observations') ?? [];

    for (String observationJson in savedObservations) {
      Map<String, dynamic> observation = jsonDecode(observationJson);
      bool sent = await CreateObservationScreen.sendDataToApi(observation);
      if (sent) {
        savedObservations.remove(observationJson);
        await prefs.setStringList('observations', savedObservations);
        print('Successfully sent and removed an unsent observation.');
      } else {
        print('Failed to send an observation, will retry later.');
      }
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreateObservationScreen(),
    );
  }
}

class CreateObservationScreen extends StatefulWidget {
  const CreateObservationScreen({super.key});

  @override
  _CreateObservationScreenState createState() =>
      _CreateObservationScreenState();

  static Future<bool> sendDataToApi(Map<String, dynamic> observation) async {
    const String apiUrl = 'https://webigosolutions.in/api3.php';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    try {
      observation.forEach((key, value) {
        if (value is String) {
          request.fields[key] = value;
        }
      });

      List<dynamic> referenceImages = observation['referenceImages'] ?? [];
      for (var filePath in referenceImages) {
        if (filePath != null && await File(filePath).exists()) {
          request.files.add(await http.MultipartFile.fromPath('referenceImages[]', filePath));
        }
      }

      List<dynamic> evidenceImages = observation['evidenceImages'] ?? [];
      for (var filePath in evidenceImages) {
        if (filePath != null && await File(filePath).exists()) {
          request.files.add(await http.MultipartFile.fromPath('evidenceImages[]', filePath));
        }
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Data and files sent to API successfully');
        return true;
      } else {
        print('Failed to send data to API: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending data to API: $e');
      return false;
    }
  }
}

class _CreateObservationScreenState extends State<CreateObservationScreen> {
  final TextEditingController _inspectionByController = TextEditingController();
  final TextEditingController _inspectionTeamController = TextEditingController();
  final TextEditingController _inspectionDateController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _actionToBeTakenController = TextEditingController();
  final TextEditingController _impactOfDeviationsController = TextEditingController();
  final TextEditingController _evidenceForNCsClosureController = TextEditingController();

  String _criticality = 'High';
  String _status = 'Open';

  final List<File> _referenceImages = [];
  final List<File?> _evidenceImages = [];
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _observations = [];

  @override
  void initState() {
    super.initState();

    Workmanager().registerPeriodicTask(
      'sendUnsentObservations',
      'sendUnsentObservationsTask',
      frequency: const Duration(hours: 1),
    );

    _sendUnsentObservations();

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        _sendUnsentObservations();
      }
    });
  }

  Future<void> _sendUnsentObservations() async {
    if (await _isOnline()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedObservations = prefs.getStringList('observations') ?? [];

      for (String observationJson in List.from(savedObservations)) {
        Map<String, dynamic> observation = jsonDecode(observationJson);
        bool sent = await CreateObservationScreen.sendDataToApi(observation);
        if (sent) {
          savedObservations.remove(observationJson);
          await prefs.setStringList('observations', savedObservations);
          print('Successfully sent and removed an unsent observation.');
        } else {
          print('Failed to send an observation, will retry later.');
        }
      }
    }
  }

  Future<bool> _isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  Future<void> _pickImage(ImageSource source, String imageType, int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        File watermarkedImage = await _addWatermark(imageFile);
        File localImage = await _saveImageLocally(watermarkedImage);
        await GallerySaver.saveImage(watermarkedImage.path, albumName: 'TaskImages');

        setState(() {
          if (imageType == 'reference') {
            _referenceImages.add(localImage);
          } else if (imageType == 'evidence') {
            if (index < _evidenceImages.length) {
              _evidenceImages[index] = localImage;
            } else {
              _evidenceImages.add(localImage);
            }
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<File> _addWatermark(File imageFile) async {
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
    img.Image watermark = img.decodeImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    )!;
    watermark = img.copyResize(watermark, width: 200, height: 50);
    img.drawImage(image, watermark,
        dstX: image.width - watermark.width - 10,
        dstY: image.height - watermark.height - 10);

    String timestamp = DateTime.now().toIso8601String();
    img.drawString(image, img.arial_24, 10, image.height - 30, timestamp,
        color: img.getColor(255, 255, 255));

    File watermarkedFile = File('${imageFile.path}_watermarked.png');
    watermarkedFile.writeAsBytesSync(img.encodePng(image));

    return watermarkedFile;
  }

  Future<File> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    String newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_image.png';
    File localImage = imageFile.copySync(newPath);
    return localImage;
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
      _evidenceImages.add(null);
    });
  }

  void _submitForm() async {
    Map<String, dynamic> observation = {
      'inspectionBy': _inspectionByController.text,
      'inspectionTeam': _inspectionTeamController.text,
      'inspectionDate': _inspectionDateController.text,
      'observations': _observationsController.text,
      'targetDate': _targetDateController.text,
      'actionToBeTaken': _actionToBeTakenController.text,
      'impactOfDeviations': _impactOfDeviationsController.text,
      'evidenceForNCsClosure': _evidenceForNCsClosureController.text,
      'referenceImages': _referenceImages.map((file) => file.path).toList(),
      'evidenceImages': _evidenceImages.map((file) => file?.path).toList(),
    };

    // Save the observation locally and log it
    await _saveObservationLocally(observation);

    print("Observation saved: $observation"); // Log to verify data

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditObservationListScreen(),
      ),
    );
  }


  Future<void> _saveObservationLocally(Map<String, dynamic> observation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load existing observations or initialize to an empty list
    List<String> savedObservations = prefs.getStringList('observations') ?? [];
    print("Loaded observations before adding new: $savedObservations");

    // Add the new observation as a JSON-encoded string
    savedObservations.add(jsonEncode(observation));

    // Save the updated list back to SharedPreferences
    bool result = await prefs.setStringList('observations', savedObservations);
    if (result) {
      print("New observation saved successfully. Current list: $savedObservations");
    } else {
      print("Error: Observation did not save.");
    }
  }

  Future<bool> _sendDataToApi(Map<String, dynamic> observation) async {
    const String apiUrl = 'https://webigosolutions.in/api3.php';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    try {
      // Add observation fields to request
      observation.forEach((key, value) {
        if (value is String) {
          request.fields[key] = value;
        }
      });

      // Add reference images
      List<dynamic> referenceImages = observation['referenceImages'] ?? [];
      for (var filePath in referenceImages) {
        if (filePath != null && await File(filePath).exists()) {
          request.files.add(await http.MultipartFile.fromPath('referenceImages[]', filePath));
        }
      }

      // Add evidence images
      List<dynamic> evidenceImages = observation['evidenceImages'] ?? [];
      for (var filePath in evidenceImages) {
        if (filePath != null && await File(filePath).exists()) {
          request.files.add(await http.MultipartFile.fromPath('evidenceImages[]', filePath));
        }
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Data and files sent to API successfully');
        return true;
      } else {
        print('Failed to send data to API: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending data to API: $e');
      return false;
    }
  }


  Future<void> _saveDataLocally(Map<String, dynamic> observation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedObservations = prefs.getStringList('observations') ?? [];

    // Add the new observation to the list
    savedObservations.add(jsonEncode(observation));

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('observations', savedObservations);
  }


  Future<void> _removeSentObservation(Map<String, dynamic> observation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedObservations = prefs.getStringList('observations') ?? [];
    savedObservations.remove(jsonEncode(observation));
    await prefs.setStringList('observations', savedObservations);
  }







  void _showImageSourceDialog(String imageType, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, imageType, index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, imageType, index);
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
            _buildTextField(_targetDateController, 'Target Date'),
            const SizedBox(height: 12),
            _buildTextField(_actionToBeTakenController, 'Action to be taken'),
            const SizedBox(height: 12),
            _buildTextField(_impactOfDeviationsController,
                'Impact of deviations (if any)'),
            const SizedBox(height: 12),
            _buildTextField(_evidenceForNCsClosureController,
                'Evidence for NCs closure'),
            const SizedBox(height: 12),
            const Text(
              'Evidence Photos',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            Column(
              children: _evidenceImages.asMap().entries.map((entry) {
                int index = entry.key;
                File? image = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: image != null
                            ? GestureDetector(
                          onTap: () => _viewImage(image),
                          child: Image.file(
                            image,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                            : GestureDetector(
                          onTap: () =>
                              _showImageSourceDialog('evidence', index),
                          child: Container(
                            height: 100,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.add_a_photo),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteImage('evidence', index),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _addMoreEvidenceImage,
              child: const Text('Add More Evidence Image'),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Observation'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText) {
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
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (selectedDate != null) {
          setState(() {
            controller.text = selectedDate.toString().substring(0, 10);
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String labelText, List<String> options,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      value: options.first,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImagePicker(String labelText, String imageType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _referenceImages.map((image) {
            return GestureDetector(
              onTap: () => _viewImage(image),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(
                    image,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteImage(imageType, _referenceImages.indexOf(image)),
                    ),
                  ),
                ],
              ),
            );
          }).toList()
            ..add(
              GestureDetector(
                onTap: () => _showImageSourceDialog(imageType, 0),
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }
}
// above inspection by field add two fileds of inspection name and inspection details. and its hould be atomatically filed with data from previous screen.