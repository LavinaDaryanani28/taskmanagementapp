import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import '../providers/category_provider.dart';
import '../providers/task_provider.dart';
import '../services/shared_preferences_service.dart';
// import '../widgets/category_container.dart';
import '../widgets/category_container.dart';
import '../widgets/summary_container.dart';
// import '../providers/task_provider.dart';
import '../widgets/search_bar.dart';

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String? username;
  String? age;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadTasks(); // Load tasks when the page is initialized
  }

  Future<void> _loadUserInfo() async {
    username = await SharedPreferencesService.getUserName();
    age = await SharedPreferencesService.getUserAge();
    setState(() {});
  }

  // Ensure tasks are loaded once and not continuously
  Future<void> _loadTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  void _handleSearch(String query) {
    // Handle the search logic here, e.g., filter tasks based on the query
    print('Searching for: $query');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;

    double horizontalPadding = screenWidth * 0.05;
    double verticalPadding = screenHeight * 0.02;

    // final categoryProvider = Provider.of<CategoryProvider>(context);
    // final taskProvider = Provider.of<TaskProvider>(context);

    // log(taskProvider.taskCounts.toString());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(
              top: topPadding + 20,
              left: horizontalPadding,
              right: horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                username != null && age != null
                    ? Text(
                  "Welcome, $username! Age: $age",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
                    : Text(
                  "Loading user info...",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "You have 5 tasks today.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(onSearch: _handleSearch),
            SizedBox(height: 20),
            Text("Summary", style: TextStyle(color: Colors.black, fontSize: 18)),
            SizedBox(height: 10),
            SummaryContainer(),
            SizedBox(height: 20),
            Text("Task Categories", style: TextStyle(color: Colors.black, fontSize: 18)),
            SizedBox(height: 10),
            // Ensure we are only waiting for the tasks to be loaded once
            CategoryContainer(
              // categories: categoryProvider.allCategories,
              // taskProvider: taskProvider,  // Pass taskProvider to update task counts dynamically
            ),
          ],
        ),
      ),
    );
  }
}
