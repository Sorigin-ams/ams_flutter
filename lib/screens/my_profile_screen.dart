import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sk_ams/Fragments/components/profile_widget.dart';
import 'package:sk_ams/Fragments/components/text_field_widget.dart';
import 'package:sk_ams/screens/ADashboardScreen.dart';
import 'package:sk_ams/Fragments/utils/colors.dart';
import 'package:sk_ams/Fragments/utils/images.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String customerName = "";
  String customerEmail = "";
  String customerMobile = "";
  String customerDesignation = "";
  String customerRole = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() => _isLoading = true);
      final response = await http.get(Uri.parse('https://yourapi.com/user/details'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          customerName = data['name'] ?? "";
          customerEmail = data['email'] ?? "";
          customerMobile = data['mobile'] ?? "";
          customerDesignation = data['designation'] ?? "";
          customerRole = data['role'] ?? "";
        });
      } else {
        throw Exception("Failed to load user profile");
      }
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserProfile() async {
    try {
      setState(() => _isLoading = true);
      final response = await http.put(
        Uri.parse('https://yourapi.com/user/update'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': customerName,
          'email': customerEmail,
          'mobile': customerMobile,
          'designation': customerDesignation,
          'role': customerRole,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ADashboardScreen()),
              (route) => false,
        );
      } else {
        throw Exception("Failed to save user profile");
      }
    } catch (e) {
      print("Error saving profile: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: const Text(
          "My Profile",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 45),
                shape: const StadiumBorder(),
              ),
              onPressed: _saveUserProfile,
              child: const Text("Save", style: TextStyle(fontSize: 16)),
            ),
          );
        },
        onClosing: () {},
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfileWidget(imagePath: userImage, onClicked: () {}),
          const SizedBox(height: 20),
          TextFieldWidget(
            label: "Full Name",
            text: customerName,
            onChanged: (name) => setState(() => customerName = name),
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Email",
            text: customerEmail,
            onChanged: (email) => setState(() => customerEmail = email),
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Mobile",
            text: customerMobile,
            onChanged: (mobile) => setState(() => customerMobile = mobile),
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Designation",
            text: customerDesignation,
            onChanged: (designation) => setState(() => customerDesignation = designation),
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Role",
            text: customerRole,
            onChanged: (role) => setState(() => customerRole = role),
          ),
        ],
      ),
    );
  }
}
