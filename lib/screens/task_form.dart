import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

class TaskFormScreen extends StatefulWidget {
  final String taskName;

  const TaskFormScreen({super.key, required this.taskName});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  String _details = '';
  List<File> _photosDuringInspection = [];
  List<File> _photosAfterRectification = [];
  DateTime? _taskDate;
  String _taskCategory = 'Visual';

  final ImagePicker _picker = ImagePicker();
  final List<File> _additionalPhotos = [];

  @override
  void initState() {
    super.initState();
    _taskName = widget.taskName;
  }

  Future<void> _pickImage(ImageSource source, String imageType) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        File watermarkedImage = await _addWatermark(imageFile);

        setState(() {
          if (imageType == 'during') {
            _photosDuringInspection.add(watermarkedImage);
          } else if (imageType == 'after') {
            _photosAfterRectification.add(watermarkedImage);
          } else if (imageType == 'additional') {
            _additionalPhotos.add(watermarkedImage);
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

  void _showImageSourceDialog(String imageType) {
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
                  _pickImage(ImageSource.gallery, imageType);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera, imageType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePicker(String label, String imageType, List<File> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        if (images.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: images.map((photo) {
              return GestureDetector(
                onTap: () => _viewImage(photo),
                child: Image.file(
                  photo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showImageSourceDialog(imageType),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Photos',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        if (_additionalPhotos.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _additionalPhotos.map((photo) {
              return GestureDetector(
                onTap: () => _viewImage(photo),
                child: Image.file(
                  photo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _showImageSourceDialog('additional'),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Add Additional Photo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
      ],
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
          "Task Form",
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField('Task Name', _taskName, enabled: false),
              const SizedBox(height: 12),
              _buildDropdown(
                'Task Category',
                [
                  'Visual',
                  'Cleaning',
                  'Paint',
                  'Corrosion',
                  'Hardware Tightness & Torque Markings'
                ],
                    (value) {
                  setState(() {
                    _taskCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildTextField('Details', _details, onSaved: (value) {
                _details = value!;
              }),
              const SizedBox(height: 12),
              _buildImagePicker('Photos during the Inspection', 'during', _photosDuringInspection),
              const SizedBox(height: 12),
              _buildImagePicker('Photos After the Rectification', 'after', _photosAfterRectification),
              const SizedBox(height: 12),
              _buildAdditionalImagePicker(),
              const SizedBox(height: 12),
              _buildDatePickerField('Task Date'),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: Colors.green[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, {bool enabled = true, void Function(String?)? onSaved}) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
    );
  }

  Widget _buildDropdown(String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: _taskCategory,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePickerField(String label) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _taskDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            _taskDate = pickedDate;
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          controller: TextEditingController(
            text: _taskDate != null ? _taskDate.toString() : '',
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Submit form data and images to server or save locally
    }
  }
}
