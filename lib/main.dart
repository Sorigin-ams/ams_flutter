import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/store/AppStore.dart';
import 'package:sk_ams/utils/utils/AConstants.dart';
import 'package:sk_ams/utils/utils/ADataProvider.dart';
import 'package:sk_ams/utils/utils/AppTheme.dart';
import 'package:sk_ams/screens/ALoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:sk_ams/service.dart';
import 'package:sk_ams/screens/ADashboardScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'package:sk_ams/utils/utils/LanguageDataModel.dart' as localLanguageModel;

AppStore appStore = AppStore();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     bool success = await _sendDataToApi(inputData!);
//     // bool success = await createobsevation._sendDataToApi(inputData!);
//     return success;
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize WorkManager for background tasks
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  await requestNotificationPermission();
  PushNotificationService().init();
  await initializeLocalNotifications();
  // await showTestNotification();
  await initialize(aLocaleLanguageList: languageList());
  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await getAndStoreFCMToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(message.notification?.title, message.notification?.body);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> getAndStoreFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    String? token = await messaging.getToken();
    print("FCM Token: $token");
    if (token != null) {
      await sendTokenToAPI(token);
    }
  } catch (e) {
    print("Error getting FCM token: $e");
  }
}

Future<void> sendTokenToAPI(String token) async {
  final String apiUrl = 'https://webigosolutions.in/api3.php?token=$token';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        print("Token stored successfully");
      } else {
        print("API Error: ${responseBody['message']}");
      }
    } else {
      print("Failed to store token, HTTP Status: ${response.statusCode}");
    }
  } catch (error) {
    print("Error sending token to API: $error");
  }
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(String? title, String? body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id', 'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics, payload: 'Default_Sound');
}

// Future<void> showTestNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'test_channel_id', 'Test Channel',
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: false,
//   );
//
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );
//
//   await flutterLocalNotificationsPlugin.show(
//       0, 'Test Notification', 'This is a test notification', platformChannelSpecifics,
//       payload: 'Test_Payload');
// }

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return Observer(
//       builder: (_) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Inspection App${!isMobile ? ' ${platformName()}' : ''}',
//         home: isLoggedIn ? const ADashboardScreen() : const ALoginScreen(),
//         theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
//         navigatorKey: navigatorKey,
//         scrollBehavior: SBehavior(),
//         supportedLocales: localLanguageModel.LanguageDataModel.languageLocales(),
//         localeResolutionCallback: (locale, supportedLocales) => locale,
//       ),
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inspection App${!isMobile ? ' ${platformName()}' : ''}',
        // Decide which screen to show based on login status
        home: isLoggedIn ? const ADashboardScreen() : const ALoginScreen(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales:
        localLanguageModel.LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
