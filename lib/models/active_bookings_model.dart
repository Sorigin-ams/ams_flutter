import 'package:sk_ams/Fragments/utils/images.dart';

List<ActiveBookingsModel> activeBooking = getActiveBooking();

class ActiveBookingsModel {
  int id;
  String serviceName;
  String serviceImage;
  String name;
  String date;
  String time;
  String status;

  ActiveBookingsModel(this.id, this.serviceName, this.serviceImage, this.name,
      this.date, this.time, this.status);
}

List<ActiveBookingsModel> getActiveBooking() {
  List<ActiveBookingsModel> list = List.empty(growable: true);
  list.add(
    ActiveBookingsModel(0, "Task Name", home, "Task assigner", "sep 4,2024",
        "4pm", "In Process"),
  );
  list.add(
    ActiveBookingsModel(
        1, "Task Name", home, "Task assigner", "Dec 4,2022", "6pm", "Assigned"),
  );
  list.add(
    ActiveBookingsModel(2, "Task Name", home, "Task assigner", "Feb 17,2022",
        "6am", "Assigned"),
  );
  return list;
}

void cancelBooking(int id) {
  activeBooking.removeAt(id);
}
