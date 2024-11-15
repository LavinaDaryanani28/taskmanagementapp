import 'dart:developer';
import 'package:flutter/material.dart';
import '../widgets/custom_bottom_navigation.dart';
import 'CategoryScreen.dart';
import 'add_task_page.dart';
import 'calendar_page.dart';
import 'home_page.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;

  // Pages for each tab in the navigation bar
  final List<Widget> _pages = [
    HomePageContent(),
    AddTaskPage(),
    CategoryScreen(),
    CalendarPage(),
  ];

  // Handles tab selection changes
  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      log("Invalid navigation index: $index");
    }
  }

  @override
  Widget build(BuildContext context) {
    log("its index page");
    return Scaffold(
      // Preserves the state of all tabs using IndexedStack
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
