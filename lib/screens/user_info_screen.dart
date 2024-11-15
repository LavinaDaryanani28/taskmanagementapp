// lib/screens/user_info_screen.dart

import 'package:flutter/material.dart';
import '../services/shared_preferences_service.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Your Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Age",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Get username and age from text fields
                String username = usernameController.text;
                String age = ageController.text;

                // Save the username and age to SharedPreferences
                if (username.isNotEmpty && age.isNotEmpty) {
                  await SharedPreferencesService.saveUserName(username);
                  await SharedPreferencesService.saveUserAge(age);

                  // Navigate to Home Page
                  // Navigator.pushReplacement(context, '/home' as Route<Object?>);
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Show an error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter both username and age.'),
                  ));
                }
              },
              child: Text("Save Information"),
            ),
          ],
        ),
      ),
    );
  }
}
