import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sk_ams/main.dart';
import 'package:sk_ams/screens/otp_verification_screen.dart';
import 'package:sk_ams/screens/sign_in_screen.dart';
import 'package:sk_ams/Fragments/utils/constant.dart';
import 'package:sk_ams/Fragments/utils/widgets.dart';

import '../custom_widget/space.dart';
import '../Fragments/utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool agreeWithTeams = false;
  bool _securePassword = true;
  bool _secureConfirmPassword = true;

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool? checkBoxValue = false;

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const SingleChildScrollView(
            child: ListBody(
                children: [Text('Please agree the terms and conditions')]),
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Space(42),
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: mainTitleTextSize, fontWeight: FontWeight.bold),
                ),
              ),
              const Space(60),
              Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 16),
                      decoration: commonInputDecoration(hintText: "Username"),
                    ),
                    const Space(16),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(hintText: "Email"),
                    ),
                    const Space(16),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      style: const TextStyle(fontSize: 20),
                      decoration:
                          commonInputDecoration(hintText: "Mobile Number"),
                    ),
                    const Space(16),
                    TextFormField(
                      controller: _passController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _securePassword,
                      style: const TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(
                        hintText: "Password",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: IconButton(
                            icon: Icon(
                                _securePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18),
                            onPressed: () {
                              _securePassword = !_securePassword;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    const Space(16),
                    TextFormField(
                      controller: _confirmPassController,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _secureConfirmPassword,
                      style: const TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(
                        hintText: "Re-enter Password",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: IconButton(
                            icon: Icon(
                                _secureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18),
                            onPressed: () {
                              _secureConfirmPassword = !_secureConfirmPassword;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    const Space(16),
                    Theme(
                      data: ThemeData(
                          unselectedWidgetColor: appStore.isDarkModeOn
                              ? Colors.white
                              : blackColor),
                      child: CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        activeColor: Colors.black,
                        title: const Text("I agree to the Terms and Conditions",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        value: checkBoxValue,
                        dense: true,
                        onChanged: (newValue) {
                          setState(() {
                            checkBoxValue = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    const Space(16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          textStyle: const TextStyle(fontSize: 25),
                          shape: const StadiumBorder(),
                          backgroundColor: appStore.isDarkModeOn
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.black,
                        ),
                        onPressed: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            if (agreeWithTeams == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OTPVerificationScreen()),
                              );
                            } else {
                              _showAlertDialog();
                            }
                          }
                        },
                        child: const Text("Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                      ),
                    ),
                    const Space(20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Have an account?",
                              style: TextStyle(fontSize: 16)),
                          Space(4),
                          Text('Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
