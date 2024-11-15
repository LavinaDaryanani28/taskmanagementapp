import 'package:flutter/material.dart';
import 'package:taskmanagement/services/shared_preferences_service.dart';

class Trial2 extends StatefulWidget {
  const Trial2({super.key});

  @override
  State<Trial2> createState() => _Trial2State();
}

class _Trial2State extends State<Trial2> {
  String? username;
  String? age;
  @override
  void initState() {
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;

    double horizontalPadding = screenWidth * 0.05;
    double verticalPadding = screenHeight * 0.02;
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
      ),
    );
  }

  Future<void> _loadUserInfo() async {
    username = await SharedPreferencesService.getUserName();
    age = await SharedPreferencesService.getUserAge();
    setState(() {});
  }

  void _handleSearch(String query) {
    // Handle the search logic here, e.g., filter tasks based on the query
    print('Searching for: $query');
  }
}
