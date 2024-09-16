import 'package:flutter/material.dart';
import 'package:sk_ams/screens/tasklistscreen.dart'; // Import TaskListScreen

class BookingsFragment extends StatefulWidget {
  final bool fromProfile;

  const BookingsFragment({super.key, required this.fromProfile});

  @override
  State<BookingsFragment> createState() => _BookingsFragmentState();
}

class _BookingsFragmentState extends State<BookingsFragment> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TaskListScreen(), // Directly show TaskListScreen without AppBar
    );
  }
}
