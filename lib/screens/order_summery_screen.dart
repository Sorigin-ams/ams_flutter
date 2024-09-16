import 'package:flutter/material.dart';
import 'package:sk_ams/models/active_bookings_model.dart';
import 'package:sk_ams/models/combos_services_model.dart';
import 'package:sk_ams/models/renovate_services_model.dart';
import 'package:sk_ams/screens/payment_screen.dart';

import '../custom_widget/space.dart';
import '../main.dart';
import '../Fragments/utils/colors.dart';

class OrderSummeryScreen extends StatefulWidget {
  final String area;
  final String bHK;
  final String weekday;
  final List<ActiveBookingsModel> list;
  final bool fromBooking;
  final bool fromRenovate;
  final int renovateIndex;

  const OrderSummeryScreen({
    super.key,
    this.area = "1590",
    this.bHK = "3 BHK",
    this.weekday = "Thursday",
    required this.list,
    this.fromBooking = false,
    this.fromRenovate = false,
    this.renovateIndex = 0,
  });

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  int index = 0;
  int itemCount = 1;
  int price = 0;

  @override
  void initState() {
    if (!widget.fromBooking) {
      if (widget.fromRenovate) {
        widget.list[0].serviceName =
            renovateServices[widget.renovateIndex].title;
        widget.list[0].serviceImage =
            renovateServices[widget.renovateIndex].imagePath!;
      } else {
        widget.list[0].serviceName = combosServices[widget.renovateIndex].title;
        widget.list[0].serviceImage =
            combosServices[widget.renovateIndex].imagePath!;
      }
    }

    widget.list[0];
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
          "Order Summery",
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
                    "\$ ${price.toString()}",
                    style: TextStyle(
                      color: appStore.isDarkModeOn
                          ? bottomContainerTextDark
                          : bottomContainerText,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            weekday: widget.weekday == ""
                                ? "Thursday"
                                : widget.weekday,
                            list: widget.list,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Proceed to Pay",
                      style: TextStyle(
                        color: appStore.isDarkModeOn
                            ? bottomContainerTextDark
                            : bottomContainerText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
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
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                    widget.list[index].serviceImage,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const Space(16),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.list[index].serviceName,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16),
                                ),
                                const Space(8),
                                Text(
                                  widget.list[index].name,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: appStore.isDarkModeOn
                                          ? cardTextDark
                                          : cardText,
                                      fontSize: 12),
                                ),
                                const Space(4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.watch_later_outlined,
                                        color: appStore.isDarkModeOn
                                            ? cardTextDark
                                            : cardText,
                                        size: 14),
                                    const Space(2),
                                    Text(widget.list[index].time,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10)),
                                    const Space(2),
                                    Text("on",
                                        style: TextStyle(
                                            color: appStore.isDarkModeOn
                                                ? cardTextDark
                                                : cardText,
                                            fontSize: 8)),
                                    const Space(2),
                                    Text(
                                      widget.weekday != ""
                                          ? widget.weekday
                                          : "Thursday",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
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
                                width: 1, color: itemCountContainerBorder),
                            color: itemCountContainer,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (itemCount != 1) {
                                    itemCount--;
                                    setState(() {});
                                  }
                                },
                                child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.remove,
                                        color: blackColor, size: 16)),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: whiteColor),
                                child: Text(itemCount.toString(),
                                    style: const TextStyle(
                                        color: blackColor, fontSize: 16)),
                              ),
                              InkWell(
                                onTap: () {
                                  itemCount++;
                                  setState(() {});
                                },
                                child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.add,
                                        color: blackColor, size: 16)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Space(28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Text(
                                widget.area != ""
                                    ? "${widget.area} Sqft"
                                    : "2000 Sqft",
                                style: TextStyle(
                                  color: appStore.isDarkModeOn
                                      ? cardTextDark
                                      : cardText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              VerticalDivider(
                                  thickness: 2,
                                  color: appStore.isDarkModeOn
                                      ? cardTextDark
                                      : cardText),
                              Text(
                                widget.bHK != "" ? widget.bHK : "1 BHK",
                                style: TextStyle(
                                  color: appStore.isDarkModeOn
                                      ? cardTextDark
                                      : cardText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("₹${widget.list[index]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Space(8),
            Card(
              color: appStore.isDarkModeOn ? cardColorDark : cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const Space(24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Address",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                          const Space(4),
                          Text(
                            "2nd Street,Shushruthi Nagar,E City",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: appStore.isDarkModeOn
                                  ? cardTextDark
                                  : cardText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Space(8),
                    const Icon(Icons.edit, size: 20),
                  ],
                ),
              ),
            ),
            const Space(8),
            Card(
              color: appStore.isDarkModeOn ? cardColorDark : cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const Icon(Icons.offline_share_outlined, size: 20),
                    const Space(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Apply Coupon",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        const Space(4),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.76,
                          child: const TextField(
                            decoration:
                                InputDecoration(border: UnderlineInputBorder()),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Space(8),
            Card(
              color: appStore.isDarkModeOn ? cardColorDark : cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: const Text(
                        "Detailed Bill",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            "Subtotal",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: appStore.isDarkModeOn
                                    ? cardTextDark
                                    : cardText,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          trailing: Text("₹${widget.list[0]}",
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 14)),
                        ),
                        ListTile(
                          title: Text(
                            "GST",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: appStore.isDarkModeOn
                                    ? cardTextDark
                                    : cardText,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          trailing: const Text("₹40",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14)),
                        ),
                        ListTile(
                          title: Text(
                            "Coupon Discount",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: appStore.isDarkModeOn
                                    ? cardTextDark
                                    : cardText,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          trailing: const Text("- ₹160",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    Divider(
                        indent: 10,
                        endIndent: 12,
                        color: appStore.isDarkModeOn ? cardTextDark : cardText),
                    ListTile(
                      title: const Text("Total",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      trailing: Text(
                        "₹${price.toString()}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Space(70),
          ],
        ),
      ),
    );
  }
}
