import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanagement/providers/category_provider.dart';
import 'package:taskmanagement/providers/task_provider.dart';
import 'package:taskmanagement/screens/index.dart';
import 'package:taskmanagement/screens/user_info_screen.dart';
import 'package:taskmanagement/services/shared_preferences_service.dart';

void main() async {
  // Ensures the widget binding is initialized before performing any async work
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch user information and determine the initial route
  String? username;
  try {
    username = await SharedPreferencesService.getUserName();
  } catch (e) {
    debugPrint('Error fetching username: $e');
    username = null; // Fallback to null in case of an error
  }

  // Run the app with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MyApp(initialRoute: username == null ? '/user_info' : '/home'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("its main page");
    return MaterialApp(
      title: 'Flutter Task Management',
      debugShowCheckedModeBanner: false, // Hides the debug banner in production
      initialRoute: initialRoute,
      routes: {
        '/': (context) => Index(), // Main screen
        '/user_info': (context) => UserInfoScreen(), // User information screen
        '/home': (context) => Index(), // Home screen after login
      },
    );
  }
}
