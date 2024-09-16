import 'package:sk_ams/components/ARegisterFormComponent.dart';
import 'package:sk_ams/screens/ALoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:sk_ams/main.dart';

class ARegisterScreen extends StatefulWidget {
  const ARegisterScreen({super.key});

  @override
  _ARegisterScreenState createState() => _ARegisterScreenState();
}

class _ARegisterScreenState extends State<ARegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ALoginScreen())),
                  child: Text('Login',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: context.iconColor)),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Text('Register',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            const Text('Kindly fill your information for registration'),
            const SizedBox(height: 8),
            const MyForm(),
          ],
        ),
      ),
    );
  }
}
