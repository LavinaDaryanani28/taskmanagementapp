import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  // Default categories (predefined and immutable)
  static const List<String> _defaultCategories = [
    'Work',
    'Personal',
    'Shopping',
    'Fitness',
  ];

  List<String> _customCategories = []; // Custom user-defined categories

  // Public getter to retrieve all categories (default + custom)
  List<String> get allCategories =>
      [..._defaultCategories, ..._customCategories];

  CategoryProvider() {
    loadCategories(); // Load custom categories during initialization
  }

  // Getter for default categories
  List<String> get defaultCategories => List.unmodifiable(_defaultCategories);

  // Getter for custom categories
  List<String> get customCategories => List.unmodifiable(_customCategories);

  /// Add a custom category
  Future<void> addCategory(String category) async {
    try {
      if (category.trim().isEmpty) {
        throw Exception("Category name cannot be empty.");
      }
      if (_defaultCategories.contains(category) ||
          _customCategories.contains(category)) {
        throw Exception("Category already exists.");
      }

      // Add new custom category
      _customCategories.add(category);
      await _saveCategories(); // Save categories to SharedPreferences
      notifyListeners();
      log("Category added successfully: $category");
    } catch (e, stackTrace) {
      log("Error adding category: $e", stackTrace: stackTrace);
      rethrow; // Re-throw the error for the caller to handle if needed
    }
  }

  /// Delete a custom category
  Future<void> deleteCategory(String category) async {
    try {
      if (_defaultCategories.contains(category)) {
        throw Exception("Default categories cannot be deleted.");
      }
      if (!_customCategories.contains(category)) {
        throw Exception("Category not found.");
      }

      // Remove the category
      _customCategories.remove(category);
      await _saveCategories(); // Save updated categories to SharedPreferences
      notifyListeners();
      log("Category deleted successfully: $category");
    } catch (e, stackTrace) {
      log("Error deleting category: $e", stackTrace: stackTrace);
      rethrow; // Re-throw the error for the caller to handle if needed
    }
  }

  /// Load custom categories from SharedPreferences
  Future<void> loadCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? customCategoriesJson = prefs.getString('customCategories');

      if (customCategoriesJson != null) {
        // Decode JSON and populate _customCategories
        List<dynamic> decodedList = jsonDecode(customCategoriesJson);
        _customCategories = List<String>.from(decodedList);
      } else {
        _customCategories = []; // Initialize empty if no data is found
      }
      log("Custom categories loaded successfully: $_customCategories");
      notifyListeners();
    } catch (e, stackTrace) {
      log("Error loading custom categories: $e", stackTrace: stackTrace);
      _customCategories = []; // Reset on error
      notifyListeners();
    }
  }

  /// Save custom categories to SharedPreferences
  Future<void> _saveCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String customCategoriesJson = jsonEncode(_customCategories);
      await prefs.setString('customCategories', customCategoriesJson);
      log("Custom categories saved successfully: $_customCategories");
    } catch (e, stackTrace) {
      log("Error saving custom categories: $e", stackTrace: stackTrace);
    }
  }

  /// Clear all custom categories (Optional utility)
  Future<void> clearCustomCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('customCategories');
      _customCategories.clear();
      notifyListeners();
      log("All custom categories cleared successfully.");
    } catch (e, stackTrace) {
      log("Error clearing custom categories: $e", stackTrace: stackTrace);
    }
  }
}
