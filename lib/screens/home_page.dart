import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/task_provider.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/category_container.dart';
import '../widgets/summary_container.dart';
import '../widgets/search_bar.dart';

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String? username;
  String? age;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([
        _loadUserInfo(),
        _loadTasks(),
        Provider.of<CategoryProvider>(context, listen: false).loadCategories(),
      ]);
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load data: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  Future<void> _loadUserInfo() async {
    try {
      username = await SharedPreferencesService.getUserName();
      age = await SharedPreferencesService.getUserAge();
    } catch (e) {
      throw Exception("Error loading user info: $e");
    }
  }

  Future<void> _loadTasks() async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).loadTasks();
    } catch (e) {
      throw Exception("Error loading tasks: $e");
    }
  }

  void _handleSearch(String query) {
    // Handle the search logic here, e.g., filter tasks based on the query
    debugPrint('Searching for: $query');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;

    double horizontalPadding = screenWidth * 0.05;
    double verticalPadding = screenHeight * 0.02;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("Loading...", style: TextStyle(color: Colors.black)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("Error", style: TextStyle(color: Colors.black)),
        ),
        body: Center(
          child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
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
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )
                    : const Text(
                  "Welcome!",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                // const Text(
                //   "You have tasks to complete today.",
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 26,
                //       fontWeight: FontWeight.bold),
                // ),
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
            const SizedBox(height: 20),
            const Text(
              "Summary",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 10),
            SummaryContainer(),
            const SizedBox(height: 20),
            const Text(
              "Task Categories",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 10),
            CategoryContainer(),
          ],
        ),
      ),
    );
  }
}
