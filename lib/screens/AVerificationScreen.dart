import 'package:sk_ams/screens/AVerifyPhoneScreen.dart';
import 'package:flutter/material.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/main.dart';

class AVerificationScreen extends StatefulWidget {
  const AVerificationScreen({super.key});

  @override
  _AVerificationScreenState createState() => _AVerificationScreenState();
}

class _AVerificationScreenState extends State<AVerificationScreen> {
  List optionSelected = [
    const Color(0xFF462F4C),
    const Color(0xFFA485AE),
    const Color(0xFFF5DFD2)
  ];
  List optionNotSelected = [
    appetitAppContainerColor,
    const Color(0xFF64BE04),
    const Color(0xFF81BB4D)
  ];

  var selected = true;

  var p1selected = true; //by default true
  var p2selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            Container(
              decoration: BoxDecoration(
                color: appStore.isDarkModeOn
                    ? context.cardColor
                    : appetitAppContainerColor,
                borderRadius: BorderRadius.circular(25),
              ),
              width: 50,
              height: 50,
              child: InkWell(
                child: const Icon(Icons.arrow_back_ios_outlined,
                    color: appetitBrownColor),
                onTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 60),
            const Text('Verification Method',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
            const Text(
                '\nVerify your password either by using Phone number or by using email'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 170,
                      child: ElevatedButton(
                        onPressed: () {
                          if (p2selected == true) {
                            setState(() {
                              p2selected = false;
                              p1selected = !p1selected;
                            });
                          } else {
                            setState(() => p1selected = !p1selected);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p1selected
                              ? const Color(0xFF462F4C)
                              : appStore.isDarkModeOn
                                  ? context.cardColor
                                  : appetitAppContainerColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Icon with border
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: p1selected
                                      ? const Color(0xFFA485AE)
                                      : const Color(0xFF81BB4D),
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.email_outlined,
                                      size: 30,
                                      color: p1selected
                                          ? const Color(0xFF462F4C)
                                          : const Color(0xFFF9E3D5)),
                                ),
                              ),
                            ),

                            // Column(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Text('Email',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: p1selected
                                          ? const Color(0xFFF5DFD2)
                                          : appetitBrownColor)),
                            ),
                            Text('harshitrajput830@gmail.com',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: p1selected
                                        ? const Color(0xFFF5DFD2)
                                        : appetitBrownColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 170,
                      child: ElevatedButton(
                        onPressed: () {
                          if (p1selected == true) {
                            setState(() {
                              p1selected = false;
                              p2selected = !p2selected;
                            });
                          } else {
                            setState(() => p2selected = !p2selected);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p2selected
                              ? const Color(0xFF462F4C)
                              : appStore.isDarkModeOn
                                  ? context.cardColor
                                  : appetitAppContainerColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Icon with border
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16.0, bottom: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    color: p2selected
                                        ? const Color(0xFFA485AE)
                                        : const Color(0xFF81BB4D),
                                    width: 50,
                                    height: 50,
                                    child: Icon(Icons.call_outlined,
                                        size: 30,
                                        color: p2selected
                                            ? const Color(0xFF462F4C)
                                            : const Color(0xFFF9E3D5)),
                                  ),
                                ),
                              ),

                              // Column(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8),
                                child: Text('Phone',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: p2selected
                                            ? const Color(0xFFF5DFD2)
                                            : appetitBrownColor)),
                              ),
                              Text('+91 9854127545',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: p2selected
                                          ? const Color(0xFFF5DFD2)
                                          : appetitBrownColor)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 60,
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AVerifyPhoneScreen())),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
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
            )
          ],
        ),
      ),
    );
  }
}
