import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider with ChangeNotifier {
  Map<String, List<Map<String, String>>> _tasksByCategory = {};
  Map<String, int> _taskCounts = {}; // Track task count by category

  TaskProvider() {
    loadTasks();  // Automatically load tasks on initialization
  }

  // Getters
  Map<String, List<Map<String, String>>> get tasksByCategory => _tasksByCategory;
  Map<String, int> get taskCounts => _taskCounts;

  // Getter to check if tasks are loaded
  bool get areTasksLoaded {
    return _tasksByCategory.isNotEmpty;
  }

  // Getter to fetch tasks of a specific category
  List<Map<String, String>> getTasksByCategory(String category) {
    return _tasksByCategory[category] ?? [];
  }

  // Add task
  Future<void> addTask(String category, String taskName, String description) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_tasksByCategory[category] == null) {
        _tasksByCategory[category] = [];
      }

      Map<String, String> task = {
        'taskName': taskName,
        'description': description,
      };

      _tasksByCategory[category]!.add(task);

      _updateTaskCount(category); // Update counts for all categories
      _syncTaskCounts();  // Sync task counts for all categories
      await _saveTasks(); // Save the updated task list
      notifyListeners();  // Notify the UI
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  void _syncTaskCounts() {
    for (String category in _tasksByCategory.keys) {
      _taskCounts[category] = _tasksByCategory[category]?.length ?? 0;
    }

    // notifyListeners(); // Ensure all categories reflect the updated counts
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksByCategoryJson = prefs.getString('tasksByCategory');

    if (tasksByCategoryJson != null) {
      try {
        Map<String, dynamic> decodedMap = jsonDecode(tasksByCategoryJson);
        _tasksByCategory = decodedMap.map((key, value) {
          List<Map<String, String>> taskList = List<Map<String, String>>.from(
            (value as List<dynamic>)
                .map((task) => Map<String, String>.from(task as Map)),
          );
          return MapEntry(key, taskList);
        });

        _tasksByCategory.forEach((category, tasks) {
          _taskCounts[category] = tasks.length;
        });
        _syncTaskCounts();  // Sync task counts after loading tasks
      } catch (e) {
        log('Error loading tasks: $e');
        _tasksByCategory = {};
        _taskCounts = {};
      }
    } else {
      _tasksByCategory = {};
      _taskCounts = {};
    }
    notifyListeners();
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String tasksJson = jsonEncode(_tasksByCategory);
      await prefs.setString('tasksByCategory', tasksJson);
      log("task is saved in savetask");
    } catch (e) {
      log('Error saving tasks: $e');
    }
  }
  Future<void> deleteTask(String category, int taskIndex) async {
    try {
      if (_tasksByCategory[category] != null && _tasksByCategory[category]!.isNotEmpty) {
        _tasksByCategory[category]!.removeAt(taskIndex);
        _syncTaskCounts();  // Sync task counts for all categories
        await _saveTasks();  // Save the updated task list
        notifyListeners();  // Notify the UI about the change
      }
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  // Update task count after adding or removing a task
  void _updateTaskCount(String category) {
    _taskCounts[category] = _tasksByCategory[category]?.length ?? 0;

    // Ensure other categories are also checked
    for (String cat in _tasksByCategory.keys) {
      if (cat != category) {
        _taskCounts[cat] = _tasksByCategory[cat]?.length ?? 0;
      }
    }

    // notifyListeners(); // Notify after all updates
  }

  // Getter to fetch task count for a specific category
  // int getTaskCount(String category) {
  //   return _taskCounts[category] ?? 0;
  // }
}

