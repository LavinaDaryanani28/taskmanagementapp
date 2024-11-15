import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getUserAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('age');
  }

  static Future<void> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }

  static Future<void> saveUserAge(String age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('age', age);
  }
}
