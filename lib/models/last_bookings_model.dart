import 'package:sk_ams/Fragments/utils/images.dart';

import 'active_bookings_model.dart';

List<LastBookingsModel> lastBooking = getLastBooking();

class LastBookingsModel {
  int id;
  String serviceName;
  String name;
  String date;
  String time;
  String status;

  //Todo add Image
  LastBookingsModel(
      this.id, this.serviceName, this.name, this.date, this.time, this.status);
}

List<LastBookingsModel> getLastBooking() {
  List<LastBookingsModel> list = List.empty(growable: true);
  list.add(
    LastBookingsModel(
        0, "Task Name", "Task assigner", "sep 4,2024", "4pm", "Completed"),
  );
  list.add(
    LastBookingsModel(
        1, "Task Name", "Task assigner", "Dec 4,2022", "6am", "Cancelled"),
  );
  list.add(
    LastBookingsModel(
        2, "Task Name", "Task assigner", "Completed", "Dec 4,2022", "6am"),
  );
  return list;
}

void againBooking(int id) {
  int newId = activeBooking.last.id++;
  activeBooking.add(
    ActiveBookingsModel(
      newId,
      lastBooking[id].serviceName,
      home,
      lastBooking[id].name,
      lastBooking[id].date,
      lastBooking[id].time,
      "In Process",
    ),
  );
}
