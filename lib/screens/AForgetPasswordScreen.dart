import 'package:flutter/material.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/main.dart';
import 'package:sk_ams/screens/AResetPasswordScreen.dart';

class AForgetPasswordScreen extends StatefulWidget {
  const AForgetPasswordScreen({super.key});

  @override
  _AForgetPasswordScreenState createState() => _AForgetPasswordScreenState();
}

class _AForgetPasswordScreenState extends State<AForgetPasswordScreen> {
  final TextEditingController emailOrMobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

  // Placeholder for the OTP service or method
  final OTPService otpService = OTPService();

  // Method to check if input is an email or a mobile number
  bool isEmail(String input) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(input);
  }

  // Send OTP method
  void sendOTP() async {
    String input = emailOrMobileController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email or mobile number')),
      );
      return;
    }

    bool isEmailInput = isEmail(input);

    if (isEmailInput) {
      // Sending OTP via email
      bool res = await otpService.sendOtpViaEmail(input);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP to your email')),
        );
      }
    } else {
      // Sending OTP via mobile
      bool res = await otpService.sendOtpViaMobile(input);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your mobile')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP to your mobile')),
        );
      }
    }
  }

  // Verify OTP method
  void verifyOTP() {
    String input = emailOrMobileController.text.trim();
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    bool isEmailInput = isEmail(input);
    bool res;

    if (isEmailInput) {
      res = otpService.verifyOtpForEmail(input, otp);
    } else {
      res = otpService.verifyOtpForMobile(input, otp);
    }

    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified successfully')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AResetPasswordScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      color: appStore.isDarkModeOn
                          ? context.cardColor
                          : appetitAppContainerColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        child: const Icon(Icons.arrow_back_ios_outlined,
                            color: appetitBrownColor),
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
                  const Text('Forgot Password',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  const Text(
                      'Enter your email or mobile number to receive an OTP for verification.'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: emailOrMobileController,
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelStyle: const TextStyle(color: Colors.grey),
                          label: const Text('Email or Mobile'),
                          hintText: 'Enter email or mobile number',
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.grey),
                          fillColor: appStore.isDarkModeOn
                              ? context.cardColor
                              : appetitAppContainerColor,
                          suffixIcon: TextButton(
                              onPressed: sendOTP,
                              child: Text('Send OTP',
                                  style: TextStyle(
                                      color: Colors.deepPurple.shade500))),
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
                        labelStyle: const TextStyle(color: Colors.grey),
                        label: const Text('OTP'),
                        hintText: 'Enter your OTP',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: appStore.isDarkModeOn
                            ? context.cardColor
                            : appetitAppContainerColor,
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
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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

// Placeholder OTP service class
class OTPService {
  Future<bool> sendOtpViaEmail(String email) async {
    // Add your email sending logic here
    return true;
  }

  Future<bool> sendOtpViaMobile(String mobile) async {
    // Add your mobile sending logic here
    return true;
  }

  bool verifyOtpForEmail(String email, String otp) {
    // Add your OTP verification logic for email here
    return true;
  }

  bool verifyOtpForMobile(String mobile, String otp) {
    // Add your OTP verification logic for mobile here
    return true;
  }
}
