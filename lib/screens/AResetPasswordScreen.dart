import 'package:sk_ams/screens/ALoginScreen.dart'; // Import your login screen here
import 'package:flutter/material.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:nb_utils/nb_utils.dart'; // For shared preferences
import 'package:sk_ams/main.dart';

class AResetPasswordScreen extends StatefulWidget {
  const AResetPasswordScreen({super.key});

  @override
  State<AResetPasswordScreen> createState() => _AResetPasswordScreenState();
}

class _AResetPasswordScreenState extends State<AResetPasswordScreen> {
  var viewPassword1 = true;
  var viewPassword2 = true;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void resetPassword() async {
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter and confirm your new password')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match. Please try again.')),
      );
      return;
    }

    // Save the new password securely
    await setValue('userPassword', passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your account password has been reset successfully')),
    );

    // Optionally, navigate to another screen after a successful reset
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor = appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor;
    var textColor = appStore.isDarkModeOn ? Colors.white : Colors.black;
    var hintTextColor = appStore.isDarkModeOn ? Colors.grey.shade300 : Colors.grey;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: backgroundColor,
                ),
                child: const Icon(Icons.arrow_back_ios_outlined, color: appetitBrownColor),
              ),
            ),
            const SizedBox(height: 60),
            Text('Reset Password', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: textColor)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Enter your new password twice for confirmation for this account.',
                style: TextStyle(color: textColor),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: viewPassword1,
                decoration: InputDecoration(
                  filled: true,
                  labelStyle: TextStyle(color: hintTextColor),
                  fillColor: backgroundColor,
                  border: InputBorder.none,
                  labelText: 'Enter password',
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: hintTextColor),
                  suffixIcon: IconButton(
                    icon: viewPassword1
                        ? Icon(Icons.visibility_off_outlined, color: hintTextColor)
                        : Icon(Icons.visibility, color: hintTextColor),
                    onPressed: () => setState(() => viewPassword1 = !viewPassword1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                controller: confirmPasswordController,
                obscureText: viewPassword2,
                decoration: InputDecoration(
                  filled: true,
                  labelStyle: TextStyle(color: hintTextColor),
                  fillColor: backgroundColor,
                  border: InputBorder.none,
                  labelText: 'Confirm password',
                  hintText: 'Confirm your password',
                  hintStyle: TextStyle(color: hintTextColor),
                  suffixIcon: IconButton(
                    icon: viewPassword2
                        ? Icon(Icons.visibility_off_outlined, color: hintTextColor)
                        : Icon(Icons.visibility, color: hintTextColor),
                    onPressed: () => setState(() => viewPassword2 = !viewPassword2),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ALoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appetitBrownColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
