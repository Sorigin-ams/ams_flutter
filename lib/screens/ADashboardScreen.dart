import 'package:flutter/material.dart';
import 'package:sk_ams/Fragments/account_fragment.dart';
import 'package:sk_ams/Fragments/bookings_fragment.dart';
import 'package:sk_ams/Fragments/home_fragment.dart';
import 'package:sk_ams/Fragments/search_fragment.dart'; // Import SearchFragment

class ADashboardScreen extends StatefulWidget {
  const ADashboardScreen({super.key});

  @override
  State<ADashboardScreen> createState() => _ADashboardScreenState();
}

class _ADashboardScreenState extends State<ADashboardScreen> {
  DateTime? _currentBackPressTime;

  final _pageItem = [
    const HomeFragment(),
    const SearchFragment(), // Now properly defined
    const BookingsFragment(fromProfile: false),
    const AccountFragment(),
  ];
  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();

        if (_currentBackPressTime == null ||
            now.difference(_currentBackPressTime!) >
                const Duration(seconds: 2)) {
          _currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
            ),
          );
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: _pageItem[_selectedItem],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: const IconThemeData(size: 30, opacity: 1),
          unselectedIconTheme: const IconThemeData(size: 28, opacity: 0.5),
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          showUnselectedLabels: true,
          elevation: 40,
          selectedFontSize: 16,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 20),
              activeIcon: Icon(Icons.home_rounded, size: 20),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined, size: 20),
              activeIcon: Icon(Icons.account_balance_wallet, size: 20),
              label: "Projects",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 20),
              activeIcon: Icon(Icons.calendar_month_outlined, size: 20),
              label: "Tasks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 20),
              activeIcon: Icon(Icons.person, size: 20),
              label: "Account",
            ),
          ],
          currentIndex: _selectedItem,
          onTap: (setValue) {
            _selectedItem = setValue;
            setState(() {});
          },
        ),
      ),
    );
  }
}
