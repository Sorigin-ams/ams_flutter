import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../custom_widget/space.dart';
import '../main.dart';
import '../Fragments/utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        print('File exists: ${file.path}');
        final contents = await file.readAsString();
        setState(() {
          notifications = List<String>.from(json.decode(contents));
        });
      } else {
        print('File does not exist, creating new file.');
        notifications = List.generate(20, (index) => 'Notification $index');
        await _saveNotifications();
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    print('Application documents directory: ${directory.path}');
    return File('${directory.path}/notifications.json'); // Path to the file where notifications are stored
  }

  Future<void> _saveNotifications() async {
    try {
      final file = await _getLocalFile();
      print('Saving notifications to file: ${file.path}');
      await file.writeAsString(json.encode(notifications));
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  void clearNotification(int index) {
    setState(() {
      notifications.removeAt(index); // Remove notification from list
      _saveNotifications(); // Update the file after removal
    });
  }

  void clearAllNotifications() {
    setState(() {
      notifications.clear(); // Clear all notifications from list
      _saveNotifications(); // Update the file after clearing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: const Text(
          "Notification",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: clearAllNotifications,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications"))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
                color: appStore.isDarkModeOn ? cardColorDark : cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.ac_unit_sharp, size: 20),
                      const Space(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Task completed",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Space(8),
                            Text(
                              "Thank you, response submitted successfully",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => clearNotification(index),
                        tooltip: 'Clear',
                      ),
                    ],
                  ),
                )
            ),
          );
        },
      ),
    );
  }
}
