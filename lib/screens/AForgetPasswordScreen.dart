import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/main.dart';
import 'package:sk_ams/screens/AResetPasswordScreen.dart';

class AForgetPasswordScreen extends StatefulWidget {
  const AForgetPasswordScreen({super.key});

  @override
  _AForgetPasswordScreenState createState() => _AForgetPasswordScreenState();
}

class _AForgetPasswordScreenState extends State<AForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

  final String apiBaseUrl = 'https://example.com/api'; // Replace with actual API base URL

  bool isEmail(String input) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(input);
  }

  Future<void> sendOTP() async {
    String email = emailController.text.trim();
    if (email.isEmpty || !isEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    Uri url = Uri.parse('$apiBaseUrl/sendOtpEmail');

    try {
      final response = await http.post(url, body: json.encode({'email': email}), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Please try again.')),
        );
      }
    } catch (e) {
      print('Error sending OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> verifyOTP() async {
    String email = emailController.text.trim();
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    Uri url = Uri.parse('$apiBaseUrl/verifyOtpEmail');

    try {
      final response = await http.post(url, body: json.encode({'email': email, 'otp': otp}), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AResetPasswordScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect OTP. Please try again.')),
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      body: Form(
        key: myFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).viewPadding.top),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: appStore.isDarkModeOn ? context.cardColor : Colors.grey.shade300,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        child: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: appStore.isDarkModeOn ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter your email to receive an OTP for verification.',
                    style: TextStyle(
                      color: appStore.isDarkModeOn ? Colors.grey.shade400 : Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                            color: appStore.isDarkModeOn ? Colors.grey.shade400 : Colors.grey,
                          ),
                          label: const Text('Email'),
                          hintText: 'Enter your email address',
                          filled: true,
                          hintStyle: TextStyle(
                            color: appStore.isDarkModeOn ? Colors.grey.shade400 : Colors.grey,
                          ),
                          fillColor: appStore.isDarkModeOn ? Colors.grey.shade800 : Colors.grey.shade200,
                          suffixIcon: TextButton(
                            onPressed: sendOTP,
                            child: Text(
                              'Send OTP',
                              style: TextStyle(
                                color: appStore.isDarkModeOn ? Colors.deepPurple.shade300 : Colors.deepPurple.shade500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextFormField(
                      controller: otpController,
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: appStore.isDarkModeOn ? Colors.grey.shade400 : Colors.grey,
                        ),
                        label: const Text('OTP'),
                        hintText: 'Enter your OTP',
                        hintStyle: TextStyle(
                          color: appStore.isDarkModeOn ? Colors.grey.shade400 : Colors.grey,
                        ),
                        filled: true,
                        fillColor: appStore.isDarkModeOn ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onLongPress: verifyOTP,
                    onPressed: verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.white,
                        ),
                      ],
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
}
