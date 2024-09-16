import 'package:flutter/material.dart';
import 'package:sk_ams/Fragments/components/profile_widget.dart';
import 'package:sk_ams/Fragments/components/text_field_widget.dart';
import 'package:sk_ams/models/customer_details_model.dart';
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
              child: const Text("Save", style: TextStyle(fontSize: 16)),
              onPressed: () {
                if (customerName != "") {
                  setName(customerName);
                }
                if (customerEmail != "") {
                  setEmail(customerEmail);
                }
                if (customerMobile != "") {
                  setMobile(customerMobile);
                }
                if (customerDesignation != "") {
                  setDesignation(customerDesignation);
                }
                if (customerRole != "") {
                  setRole(customerRole);
                }
                setState(() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ADashboardScreen()),
                    (route) => false,
                  );
                });
              },
            ),
          );
        },
        onClosing: () {},
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          ProfileWidget(imagePath: userImage, onClicked: () {}),
          const SizedBox(height: 20),
          TextFieldWidget(
            label: "Full Name",
            text: getName,
            onChanged: (name) {
              customerName = name;
            },
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Email",
            text: getEmail,
            onChanged: (email) {
              customerEmail = email;
            },
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Mobile",
            text: getMobile,
            // maxLines: 5,
            onChanged: (mobile) {
              customerMobile = mobile;
            },
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Designation",
            text: getMobile,
            // maxLines: 2,
            onChanged: (designation) {
              customerDesignation = designation;
            },
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: "Role",
            text: getMobile,
            // maxLines: 5,
            onChanged: (role) {
              customerRole = role;
            },
          ),
        ],
      ),
    );
  }
}
