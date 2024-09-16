import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_ams/Fragments/bookings_fragment.dart';
import 'package:sk_ams/screens/my_profile_screen.dart';
import 'package:sk_ams/screens/notification_screen.dart';
import 'package:sk_ams/Fragments/utils/colors.dart';
import 'package:sk_ams/Fragments/utils/images.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('savedEmail') ??
          ""; // Assuming savedEmail is used as the username
      userEmail = prefs.getString('savedEmail') ??
          ""; // You might want to use another key if you store the name separately
    });
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
            Text(userName, // Display userName from SharedPreferences
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            const Space(4),
            Text(userEmail, // Display userEmail from SharedPreferences
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
            const Space(16),
          ],
        ),
      ),
    );
  }
}
