import 'package:flutter/material.dart';
import 'package:sk_ams/custom_widget/space.dart';
import 'package:sk_ams/main.dart';
import 'package:sk_ams/models/last_bookings_model.dart';
import 'package:sk_ams/Fragments/utils/colors.dart';
import 'package:sk_ams/Fragments/utils/images.dart';

class BookingHistoryComponent extends StatelessWidget {
  final LastBookingsModel? lastBookings;
  final int index;

  const BookingHistoryComponent(this.index, {super.key, this.lastBookings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color: appStore.isDarkModeOn ? cardColorDark : cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lastBooking[index].serviceName,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    lastBooking[index].status,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: lastBooking[index].status == "Completed"
                          ? greenColor
                          : redColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Space(4),
              Divider(color: dividerColor, thickness: 1),
              const Space(2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.height * 0.07,
                      child: Image.asset(home, fit: BoxFit.cover),
                    ),
                  ),
                  const Space(8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lastBooking[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const Space(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            color: orangeColor,
                            size: 16,
                          ),
                          const Space(2),
                          Text(
                            lastBooking[index].date,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Space(2),
                          const Text(
                            "at",
                            style: TextStyle(color: orangeColor, fontSize: 12),
                          ),
                          const Space(2),
                          Text(
                            lastBooking[index].time,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const Space(4),
              const Align(
                alignment: Alignment.centerRight,
              ),
              const Space(4),
              Divider(color: dividerColor, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}
