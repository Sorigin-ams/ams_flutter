import 'package:flutter/material.dart';
import 'package:sk_ams/custom_widget/space.dart';
import 'package:sk_ams/main.dart';
import 'package:sk_ams/models/active_bookings_model.dart';
import 'package:sk_ams/Fragments/utils/colors.dart';
import 'package:sk_ams/Fragments/utils/images.dart';

class ActiveBookingComponent extends StatelessWidget {
  final ActiveBookingsModel? activeBookingsModel;
  final int index;

  const ActiveBookingComponent(this.index,
      {super.key, this.activeBookingsModel});

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
                    activeBookingsModel!.serviceName,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    activeBookingsModel!.status,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: activeBookingsModel!.status == "In Process"
                          ? orangeColor
                          : blueColor,
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
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.height * 0.06,
                      child: Image.asset(home, fit: BoxFit.cover),
                    ),
                  ),
                  const Space(8),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        activeBookingsModel!.name,
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
                            activeBookingsModel!.date,
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
                            activeBookingsModel!.time,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
