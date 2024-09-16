import 'package:flutter/material.dart';
import 'package:sk_ams/screens/last_booking_screen.dart';
import 'package:sk_ams/Fragments/utils/colors.dart';

import '../custom_widget/space.dart';
import '../main.dart';
import '../models/active_bookings_model.dart';

class CancelBookingScreen extends StatefulWidget {
  final int activeId;

  const CancelBookingScreen({super.key, required this.activeId});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String? refundMethod;
  String? reasonForCancel;
  int itemCount = 1;

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Please select valid details'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: const Text(
          "Cancel Booking",
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 45),
                shape: const StadiumBorder(),
              ),
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Cancel Service")),
              onPressed: () {
                if (refundMethod == null) {
                  _showAlertDialog();
                } else if (reasonForCancel == null) {
                  _showAlertDialog();
                } else {
                  cancelBooking(widget.activeId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LastBookingScreen(cancel: true)),
                  );
                }
              },
            ),
          );
        },
        onClosing: () {},
      ),
      body: SingleChildScrollView(
        //padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: appStore.isDarkModeOn ? cardColorDark : cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.10,
                                      child: Image.asset(
                                          'assets/images/home.jpg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const Space(16),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activeBooking[widget.activeId]
                                            .serviceName,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16),
                                      ),
                                      const Space(4),
                                      Text(
                                        activeBooking[widget.activeId].name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            color: greyColor, fontSize: 12),
                                      ),
                                      const Space(4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.watch_later_outlined,
                                              color: greyColor, size: 14),
                                          const Space(2),
                                          Text(
                                            activeBooking[widget.activeId].time,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                          const Space(2),
                                          const Text("on",
                                              style: TextStyle(
                                                  color: greyColor,
                                                  fontSize: 8)),
                                          const Space(2),
                                          const Text("Thursday",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10)),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: (BorderRadius.circular(5)),
                                  border: Border.all(
                                      width: 1,
                                      color: itemCountContainerBorder),
                                  color: itemCountContainer,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.remove,
                                        color: blackColor, size: 16),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: whiteColor),
                                      child: Text(itemCount.toString(),
                                          style: const TextStyle(
                                              color: blackColor, fontSize: 16)),
                                    ),
                                    const Icon(Icons.add,
                                        color: blackColor, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Space(42),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Text("1590 Sqft",
                                        style: TextStyle(
                                            color: greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    VerticalDivider(
                                        thickness: 2, color: greyColor),
                                    Text("3BHK",
                                        style: TextStyle(
                                            color: greyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Text(
                                "₹${activeBooking[widget.activeId]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 18),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Space(32),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Summary",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    ],
                  ),
                  const Space(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Subtotal",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: greyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        "₹${activeBooking[widget.activeId]}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Space(8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GST",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: greyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text("₹160",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const Space(8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coupon Discount",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: greyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text("- ₹160",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const Space(8),
                  const Divider(indent: 8, endIndent: 8, color: greyColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20)),
                      Text(
                        "₹${activeBooking[widget.activeId]}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                    ],
                  ),
                  const Space(42),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Refund Method",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
            const Space(16),
            RadioListTile(
              title: const Text("Refund to Original Payment Method",
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              value: "OriginalPayment",
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              activeColor: orangeColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              groupValue: refundMethod,
              onChanged: (value) {
                refundMethod = value.toString();
                setState(() {});
              },
            ),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              title: const Text("Add to My Wallet",
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              activeColor: orangeColor,
              value: "MyWallet",
              groupValue: refundMethod,
              onChanged: (value) {
                refundMethod = value.toString();
                setState(() {});
              },
            ),
            const Space(32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Why are you cancelling this service",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
            const Space(8),
            RadioListTile(
              title: const Text("Booked by mistake"),
              value: "mistake",
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              activeColor: orangeColor,
              groupValue: reasonForCancel,
              onChanged: (value) {
                reasonForCancel = value.toString();
                setState(() {});
              },
            ),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              title: const Text("Not available on the date of service"),
              activeColor: orangeColor,
              value: "noAvailable",
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              groupValue: reasonForCancel,
              onChanged: (value) {
                setState(() {
                  reasonForCancel = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("No longer needed"),
              activeColor: orangeColor,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              value: "noNeeded",
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              groupValue: reasonForCancel,
              onChanged: (value) {
                reasonForCancel = value.toString();
                setState(() {});
              },
            ),
            const Space(80),
          ],
        ),
      ),
    );
  }
}
