import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  final List<String> _defaultCategories = [
    'Personal',
    'Work',
    'Birthday',
    'Wishlist'
  ];
  List<String> _customCategories = [];

  CategoryProvider() {
    _loadCategories();
  }

  List<String> get allCategories => _defaultCategories + _customCategories;
  List<String> get defaultCategories => _defaultCategories;
  List<String> get customCategories => _customCategories;

  Future<void> _loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoriesJson = prefs.getString('customCategories');
    if (categoriesJson != null) {
      _customCategories = List<String>.from(jsonDecode(categoriesJson));
      notifyListeners();
    }
  }

  void addCategory(String newCategory) {
    if (newCategory.isNotEmpty && !_customCategories.contains(newCategory)) {
      _customCategories.add(newCategory);
      _saveCategories();
      notifyListeners();
    }
  }

  void deleteCategory(String category) {
    _customCategories.remove(category);
    _saveCategories();
    notifyListeners();
  }

  Future<void> _saveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String categoriesJson = jsonEncode(_customCategories);
    await prefs.setString('customCategories', categoriesJson);
  }

  // Future<int> getTaskCountForCategory(String category) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? tasks = prefs.getStringList(category); // Assuming tasks are stored by category
  //   return tasks?.length ?? 0;
  // }
}
