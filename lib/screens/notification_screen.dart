import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _initializeNotifications();
    _fetchNotificationsFromAPI(); // Simulating API call to fetch notifications
  }

  // Initialize local notifications
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Method to show notification in notification bar
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // Simulate fetching notifications from API
  Future<void> _fetchNotificationsFromAPI() async {
    // This is where your API call would be placed to fetch notifications
    // Simulating response
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    List<String> apiNotifications = List.generate(5, (index) => 'New Notification from API $index');

    setState(() {
      notifications.addAll(apiNotifications);
    });

    // Save the new notifications to the file
    await _saveNotifications();

    // Push the first notification to the notification bar (as an example)
    if (apiNotifications.isNotEmpty) {
      _showNotification("New Notification", apiNotifications.first);
    }
  }

  Future<void> _loadNotifications() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          notifications = List<String>.from(json.decode(contents));
        });
      } else {
        notifications = []; // Start with an empty notification list
        await _saveNotifications();
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notifications.json');
  }

  Future<void> _saveNotifications() async {
    try {
      final file = await _getLocalFile();
      await file.writeAsString(json.encode(notifications));
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  void clearNotification(int index) {
    setState(() {
      notifications.removeAt(index);
      _saveNotifications();
    });
  }

  void clearAllNotifications() {
    setState(() {
      notifications.clear();
      _saveNotifications();
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.ac_unit_sharp, size: 20),
                    const Space(16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Task completed", style: TextStyle(fontWeight: FontWeight.bold)),
                          Space(8),
                          Text(
                            "Thank you, response submitted successfully",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
// above is my notification screen. now i wnat to fetch notiifications from api nad want to display on notification bar and