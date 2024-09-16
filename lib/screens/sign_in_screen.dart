import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sk_ams/screens/otp_verification_screen.dart';
import 'package:sk_ams/screens/sign_up_screen.dart';
import 'package:sk_ams/Fragments/utils/constant.dart';
import 'package:sk_ams/Fragments/utils/widgets.dart';
import '../custom_widget/space.dart';
import '../main.dart';
import '../Fragments/utils/colors.dart';
import '../Fragments/utils/images.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  Country? _selectedCountry;

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    _selectedCountry = country;
    setState(() {});
  }

  bool checkPhoneNumber(String phoneNumber) {
    String regexPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    var regExp = RegExp(regexPattern);

    if (phoneNumber.isEmpty) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerSheet(context);
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness:
              appStore.isDarkModeOn ? Brightness.light : Brightness.dark),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Space(60),
                  Text("Welcome back!",
                      style: TextStyle(
                          fontSize: mainTitleTextSize,
                          fontWeight: FontWeight.bold)),
                  const Space(8),
                  Text("Please Login to your account",
                      style: TextStyle(fontSize: 14, color: subTitle)),
                  const Space(16),
                  Image.asset(splash_logo,
                      width: 100, height: 100, fit: BoxFit.cover),
                ],
              ),
              const Space(70),
              Form(
                key: _loginFormKey,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 16),
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  decoration: commonInputDecoration(
                    hintText: "Enter mobile number",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () => _showCountryPicker(),
                        child: Text(
                          _selectedCountry == null
                              ? "+91"
                              : _selectedCountry!.callingCode,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Space(16),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: const StadiumBorder(),
                    backgroundColor: appStore.isDarkModeOn
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.black,
                  ),
                  onPressed: () {
                    if (_loginFormKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const OTPVerificationScreen()),
                      );
                    }
                  },
                  child: const Text("Log In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
                ),
              ),
              const Space(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                            thickness: 1.2,
                            color: Colors.grey.withOpacity(0.2))),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Text("Or Login With",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Expanded(
                        child: Divider(
                            thickness: 1.2,
                            color: Colors.grey.withOpacity(0.2))),
                  ],
                ),
              ),
              const Space(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(icGoogle,
                      scale: 24,
                      color: appStore.isDarkModeOn ? blackColor : blackColor),
                  const Space(40),
                  Image.asset(icInstagram,
                      scale: 24,
                      color: appStore.isDarkModeOn ? blackColor : blackColor),
                ],
              ),
              const Space(32),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account?", style: TextStyle(fontSize: 16)),
                    Space(4),
                    Text('Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
