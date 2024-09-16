import 'package:sk_ams/screens/AResetPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/main.dart';

class AVerifyPhoneScreen extends StatelessWidget {
  const AVerifyPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            ClipRRect(
              child: Container(
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
            ),
            const SizedBox(height: 60),
            const Text('Verify Phone',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Text('Enter the OTP sent to your current active device '),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: appStore.isDarkModeOn
                      ? context.cardColor
                      : appetitAppContainerColor,
                  labelText: 'Enter OTP',
                  alignLabelWithHint: false,
                  hintText: 'Enter OTP sent',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AResetPasswordScreen())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Verify and continue  ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Icon(Icons.arrow_forward_ios_outlined, size: 15),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
