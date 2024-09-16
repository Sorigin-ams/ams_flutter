import 'package:flutter/material.dart';
import 'package:sk_ams/Fragments/components/payment_container.dart';
import 'package:sk_ams/screens/last_booking_screen.dart';

import '../custom_widget/space.dart';
import '../main.dart';
import '../models/active_bookings_model.dart';
import '../Fragments/utils/colors.dart';

class PaymentScreen extends StatefulWidget {
  final String weekday;
  final List<ActiveBookingsModel> list;

  const PaymentScreen({super.key, required this.list, required this.weekday});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();

  void setDate() {
    list[0].date = "13 January,2023";
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    if (widget.list[0].date == "") {
      widget.setDate();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: const Text(
          "Payment",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: appStore.isDarkModeOn
                    ? bottomContainerDark
                    : bottomContainerBorder,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rs.${widget.list[0]}",
                    style: TextStyle(
                      color: appStore.isDarkModeOn
                          ? bottomContainerTextDark
                          : bottomContainerText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      activeBooking.add(widget.list[0]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LastBookingScreen(
                            cancel: false,
                            weekday: widget.weekday,
                            date: widget.list[0].date,
                            time: widget.list[0].time,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Pay",
                      style: TextStyle(
                        color: appStore.isDarkModeOn
                            ? bottomContainerTextDark
                            : bottomContainerText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onClosing: () {},
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            PaymentContainer(
                title: "Credit & Debit Cards", icon: Icons.credit_card),
            Space(16),
            PaymentContainer(title: "Net Banking", icon: Icons.food_bank),
            Space(16),
            PaymentContainer(
                title: "Cash On Delivery", icon: Icons.delivery_dining),
            Space(16),
            PaymentContainer(title: "Wallets", icon: Icons.wallet),
            Space(16),
            PaymentContainer(
                title: "UPIs", icon: Icons.book_online_rounded, isUpi: true),
            Space(55),
          ],
        ),
      ),
    );
  }
}
