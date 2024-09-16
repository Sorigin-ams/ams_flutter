// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'walkthroghscreen.dart';

class ASplashScreen extends StatefulWidget {
  const ASplashScreen({super.key});

  @override
  _ASplashScreenState createState() => _ASplashScreenState();
}

class _ASplashScreenState extends State<ASplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AWalkThroughScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/logo.png', // Use the logo.png image
              height: 200, // Adjust the height as needed
              width: 200, // Adjust the width as needed
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/icon.png',
              fit: BoxFit.cover,
              height: 120,
              width: 120,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/icon.png',
              fit: BoxFit.cover,
              height: 130,
              width: 130,
            ),
          ),
        ],
      ),
    );
  }
}
