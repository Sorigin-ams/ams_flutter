import 'package:flutter/material.dart';
import 'package:sk_ams/Fragments/bookings_fragment.dart';
import 'package:sk_ams/screens/my_profile_screen.dart';
import 'package:sk_ams/screens/notification_screen.dart';
import 'package:sk_ams/Fragments/utils/colors.dart';
import 'package:sk_ams/Fragments/utils/images.dart';
import 'package:sk_ams/screens/ALoginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_widget/space.dart';

class AccountFragment extends StatefulWidget {
  const AccountFragment({super.key});

  @override
  State<AccountFragment> createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final response = await http.get(Uri.parse('https://yourapi.com/user/details'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['name'] ?? "User";
          userEmail = data['email'] ?? "user@example.com";
        });
      } else {
        // Handle error if the response is not successful
        throw Exception("Failed to load user data");
      }
    } catch (e) {
      // Display an error message if the API call fails
      print("Error loading user details: $e");
    }
  }

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to Logout?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ALoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: const Text(
          "Account",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                height: 90,
                width: 90,
                child: CircleAvatar(backgroundImage: AssetImage(userImage))),
            const Space(8),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            const Space(4),
            Text(userEmail,
                textAlign: TextAlign.start,
                style: const TextStyle(color: secondaryColor, fontSize: 12)),
            const Space(16),
            ListTile(
              horizontalTitleGap: 4,
              leading: const Icon(Icons.person, size: 20),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: const Text("My Profile"),
              trailing: const Icon(Icons.edit, size: 16),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyProfileScreen()));
              },
            ),
            ListTile(
              horizontalTitleGap: 4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.notifications, size: 20),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
            ),
            ListTile(
              horizontalTitleGap: 4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.calendar_month, size: 20),
              title: const Text("My Tasks"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const BookingsFragment(fromProfile: true)));
              },
            ),
            ListTile(
              horizontalTitleGap: 4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.mail, size: 20),
              title: const Text("Contact Us"),
              onTap: () {
                //
              },
            ),
            ListTile(
              horizontalTitleGap: 4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.question_mark, size: 20),
              title: const Text("Help Center"),
              onTap: () {
                //
              },
            ),
            ListTile(
              horizontalTitleGap: 4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.logout, size: 20),
              title: const Text("Log Out"),
              onTap: () {
                _showLogOutDialog(); // Call the logout confirmation dialog
              },
            ),
            const Space(16),
          ],
        ),
      ),
    );
  }
}
