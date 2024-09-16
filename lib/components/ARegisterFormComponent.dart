import 'package:sk_ams/screens/ADashboardScreen.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/main.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var viewPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          //4 textformfields
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelStyle: const TextStyle(color: Colors.grey),
                  labelText: 'Full Name',
                  hintText: 'Enter Full Name',
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: appStore.isDarkModeOn
                      ? context.cardColor
                      : appetitAppContainerColor,
                  filled: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  labelText: 'E-mail',
                  hintText: 'Enter proper email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: appStore.isDarkModeOn
                      ? context.cardColor
                      : appetitAppContainerColor,
                  filled: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // keyboardAppearance: ,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  labelText: 'Phone Number',
                  hintText: 'Enter 10-digit number',
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: appStore.isDarkModeOn
                      ? context.cardColor
                      : appetitAppContainerColor,
                  filled: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                obscureText: viewPassword,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  labelText: 'Password',
                  hintText: 'Enter your Password',
                  filled: true,
                  fillColor: appStore.isDarkModeOn
                      ? context.cardColor
                      : appetitAppContainerColor,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => viewPassword = !viewPassword),
                    icon: viewPassword
                        ? const Icon(Icons.visibility_off, color: Colors.grey)
                        : const Icon(Icons.visibility, color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter valid Password';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Successfully Registered')));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ADashboardScreen()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF65C004),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: const Text('Register',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          const Column(
            children: [
              Text('By registering you agree to our',
                  style: TextStyle(fontSize: 17)),
              Text('Terms and Conditions',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
