import 'package:sk_ams/components/ADiscussionComponent.dart';
import 'package:flutter/material.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/main.dart';

class ADiscussionScreen extends StatelessWidget {
  const ADiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: appStore.isDarkModeOn
                          ? context.cardColor
                          : appetitAppContainerColor,
                      child: const Icon(Icons.arrow_back_ios_outlined,
                          color: appetitBrownColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Discussion",
                    style:
                        TextStyle(fontSize: 35, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  //List of elements
                  const ADiscussionComponent(),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn
                            ? context.cardColor
                            : appetitAppContainerColor,
                        filled: true,
                        labelText: 'Discuss here',
                        labelStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.send_outlined,
                            color: Colors.orange.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}