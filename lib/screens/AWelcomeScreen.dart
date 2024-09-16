import 'package:flutter/material.dart';
import 'package:sk_ams/screens/ALoginScreen.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/main.dart'; // Import where appStore is defined

class AWelcomeScreen extends StatefulWidget {
  const AWelcomeScreen({super.key});

  @override
  _AWelcomeScreenState createState() => _AWelcomeScreenState();
}

class _AWelcomeScreenState extends State<AWelcomeScreen> {
  @override
  void dispose() {
    setStatusBarColor(Colors.transparent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Container(
          decoration: BoxDecoration(
            color: appStore.isDarkModeOn
                ? context.cardColor
                : appetitAppContainerColor,
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.only(left: 8.0, top: 8),
          height: 50,
          width: 50,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_outlined,
                color: appetitBrownColor, size: 20),
          ),
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text('inspection app',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: context.iconColor)),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: appStore.isDarkModeOn
                  ? context.cardColor
                  : appetitAppContainerColor,
              borderRadius: BorderRadius.circular(25),
            ),
            margin: const EdgeInsets.only(top: 8, right: 8),
            width: 50,
            height: 50,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              child: const Icon(Icons.help_outline_outlined,
                  color: appetitBrownColor, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Image with content
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/createaccount.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.40), BlendMode.darken),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w600)),
                  16.height,
                  const Text('Login to access your account',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            // Direct to Login Screen
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ALoginScreen())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81BB4D),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 8),
                    Text('Login',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
