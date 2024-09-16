import 'package:flutter/material.dart';
import 'package:sk_ams/Fragments/components/active_booking_component.dart';

import '../models/active_bookings_model.dart';

class ActiveBookingsScreen extends StatefulWidget {
  const ActiveBookingsScreen({super.key});

  @override
  State<ActiveBookingsScreen> createState() => _ActiveBookingsScreenState();
}

class _ActiveBookingsScreenState extends State<ActiveBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activeBooking.isEmpty
          ? const Center(child: Text("No  Data"))
          : ListView.builder(
              padding:
                  const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 16),
              itemCount: activeBooking.length,
              itemBuilder: (BuildContext context, int index) {
                return ActiveBookingComponent(
                    activeBookingsModel: activeBooking[index], index);
              },
            ),
    );
  }
}
