import 'package:flutter/material.dart';
import 'package:sk_ams/screens/ADashboardScreen.dart';
import 'package:sk_ams/Fragments/utils/colors.dart';

import '../custom_widget/space.dart';
import '../main.dart';

class LastBookingScreen extends StatelessWidget {
  final bool cancel;
  final String time;
  final String weekday;
  final String date;

  const LastBookingScreen({
    super.key,
    this.cancel = false,
    this.time = "07:15",
    this.weekday = "Thursday",
    this.date = "4 january,2022",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.06),
                shape: const StadiumBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Go Back Home", style: TextStyle(fontSize: 16)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const ADashboardScreen()),
                  (route) => false,
                );
              },
            ),
          );
        },
        onClosing: () {},
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 0.6,
                        spreadRadius: 1),
                  ],
                  color: appStore.isDarkModeOn ? Colors.black : whiteColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.done,
                    size: 80,
                    color: appStore.isDarkModeOn ? whiteColor : blackColor),
              ),
              const Space(16),
              Text(cancel ? "Cancelled!!" : "Confirmed",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 32)),
              const Space(32),
              Text(
                cancel
                    ? "Your booking has been cancelled successfully"
                    : "Your booking has been confirmed for $date",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: greyColor),
              ),
              Visibility(
                visible: cancel ? false : true,
                child: Column(
                  children: [
                    const Space(8),
                    const Text(
                      "You will get an email with the booking details",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Space(32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined, color: greyColor),
                        const Space(4),
                        Text(time,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        const Space(4),
                        const Text("on",
                            style: TextStyle(color: greyColor, fontSize: 13)),
                        const Space(4),
                        Text(weekday,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ],
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
