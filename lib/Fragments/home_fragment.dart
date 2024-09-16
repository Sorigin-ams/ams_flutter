import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:sk_ams/Fragments/bookings_fragment.dart';

import 'package:sk_ams/models/customer_details_model.dart';

import 'package:sk_ams/screens/notification_screen.dart';


import 'package:sk_ams/Fragments/utils/images.dart';

import 'package:sk_ams/Fragments/utils/widgets.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:sk_ams/screens/inspections.dart';

import '../../custom_widget/space.dart';

import '../main.dart';

import '../screens/my_profile_screen.dart';

import '../Fragments/utils/colors.dart';

import 'package:sk_ams/Fragments/search_fragment.dart';

import 'package:sk_ams/screens/Tasklistscreen.dart';
import 'package:sk_ams/screens/ALoginScreen.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final List<String> bannerList = [banner1, banner2, banner];
  final PageController offerPagesController =
      PageController(viewportFraction: 0.93, keepPage: true, initialPage: 1);

  String searchQuery = '';
  final List<String> allTitles = [
    "View Assigned Projects",
    "View Upcoming Scheduled Inspections",
    "Tasks Lists",
  ];

  @override
  void dispose() {
    offerPagesController.dispose();
    super.dispose();
  }

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to Logout?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ALoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<String> _searchResults() {
    if (searchQuery.isEmpty) {
      return allTitles;
    }
    return allTitles
        .where(
            (title) => title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _searchResults();

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: transparent,
          iconTheme: const IconThemeData(size: 28, color: Colors.black),
          title: Text(
            "Inspection App",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: appStore.isDarkModeOn ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, size: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()),
                );
              },
            ),
            Observer(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: Switch(
                    value: appStore.isDarkModeOn,
                    onChanged: (value) {
                      appStore.toggleDarkMode(value: value);
                    },
                  ),
                );
              },
            ),
          ],
          shape: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 40, bottom: 24),
                color: appStore.isDarkModeOn ? Colors.black : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 // // children: [
                 //    Container(
                 //      padding: const EdgeInsets.all(16),
                 //      decoration: BoxDecoration(
                 //        shape: BoxShape.circle,
                 //        color:
                 //            appStore.isDarkModeOn ? whiteColor : Colors.black,
                 //      ),
                 //      child: Text(
                 //        "K",
                 //        style: TextStyle(
                 //            fontSize: 24.0,
                 //            color: appStore.isDarkModeOn
                 //                ? Colors.black
                 //                : whiteColor),
                 //        textAlign: TextAlign.center,
                 //      ),
                 //    ),
                 //    const Space(4),
                 //    Text(
                 //      getName,
                 //      style: TextStyle(
                 //          fontSize: 18,
                 //          color:
                 //              appStore.isDarkModeOn ? whiteColor : Colors.black,
                 //          fontWeight: FontWeight.bold),
                 //    ),
                 //    const Space(4),
                 //    Text(getEmail,
                 //        style: const TextStyle(color: secondaryColor)),
                 //  ],
                ),
              ),
              drawerWidget(
                drawerTitle: "My Profile",
                drawerIcon: Icons.person,
                drawerOnTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyProfileScreen()));
                },
              ),
              drawerWidget(
                drawerTitle: "Notifications",
                drawerIcon: Icons.notifications,
                drawerOnTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
              ),
              drawerWidget(
                drawerTitle: "My Tasks",
                drawerIcon: Icons.calendar_month,
                drawerOnTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const BookingsFragment(fromProfile: true)),
                  );
                },
              ),
              drawerWidget(
                drawerTitle: "Contact Us",
                drawerIcon: Icons.mail,
                drawerOnTap: () {
                  Navigator.pop(context);
                },
              ),
              drawerWidget(
                drawerTitle: "Help Center",
                drawerIcon: Icons.question_mark_rounded,
                drawerOnTap: () {
                  Navigator.pop(context);
                },
              ),
              drawerWidget(
                drawerTitle: "Logout",
                drawerIcon: Icons.logout,
                drawerOnTap: () {
                  Navigator.pop(context);
                  _showLogOutDialog();
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    keyboardType: TextInputType.name,
                    style: const TextStyle(fontSize: 17),
                    decoration: commonInputDecoration(
                      suffixIcon: Icon(Icons.search,
                          size: 20,
                          color: appStore.isDarkModeOn
                              ? Colors.white
                              : Colors.black),
                      hintText: "Search",
                    ),
                  ),
                ),
                const Space(16),
                SizedBox(
                  height: 170,
                  child: PageView.builder(
                    controller: offerPagesController,
                    itemCount: bannerList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Image.asset(bannerList[index],
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SmoothPageIndicator(
                  controller: offerPagesController,
                  count: bannerList.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 7,
                    dotWidth: 8,
                    activeDotColor:
                        appStore.isDarkModeOn ? Colors.white : Colors.black,
                    expansionFactor: 2.2,
                  ),
                ),
                const Space(16),
                if (searchResults.isEmpty)
                  const Center(
                      child: Text("No results found",
                          style: TextStyle(fontSize: 16, color: Colors.grey)))
                else
                  ...searchResults.map((title) {
                    switch (title) {
                      case "View Assigned Projects":
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16.0), // Add space below the widget
                          child: _buildListTile(
                            context,
                            title: title,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProjectListScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      case "View Upcoming Scheduled Inspections":
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildListTile(
                            context,
                            title: title,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const InspectionFragment(),
                                ),
                              );
                            },
                          ),
                        );
                      case "Tasks Lists":
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildListTile(
                            context,
                            title: title,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TaskListScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      default:
                        return Container(); // Placeholder if needed
                    }
                  }),
                const Space(16),
              ],
            ),
          ),
        ));
  }

  Widget _buildListTile(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: appStore.isDarkModeOn ? Colors.black12 : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
