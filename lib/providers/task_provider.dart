import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  Map<String, List<TaskModel>> _tasksByCategory = {}; // Core data storage

  TaskProvider() {
    loadTasks(); // Load tasks on initialization
  }

  // Add a new task to a specific category
  Future<void> addTask({
    required String category,
    required String taskName,
    String? description,
    DateTime? dueDate,
  }) async {
    try {
      // Ensure category exists in the map
      _tasksByCategory.putIfAbsent(category, () => []);

      // Create a new task
      TaskModel newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        taskName: taskName,
        category: category,
        description: description,
        dueDate: dueDate,
        isCompleted: false,
      );

      // Add task to category
      _tasksByCategory[category]!.add(newTask);

      // Save tasks to SharedPreferences
      await _saveTasks();
      notifyListeners();
    } catch (e, stackTrace) {
      log('Error adding task: $e', stackTrace: stackTrace);
      rethrow; // Propagate error if needed
    }
  }

  // Remove a task from a specific category
  Future<void> removeTask(String category, String taskId) async {
    try {
      final taskIndex =
          _tasksByCategory[category]?.indexWhere((task) => task.id == taskId);

      if (taskIndex != null && taskIndex != -1) {
        // Remove task from the list
        _tasksByCategory[category]!.removeAt(taskIndex);

        // Save updated tasks to SharedPreferences
        await _saveTasks();
        notifyListeners();
      } else {
        log('Task with ID $taskId not found in category $category.');
      }
    } catch (e, stackTrace) {
      log('Error removing task: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateTask(
    String taskId, {
    String? newCategory,
    String? oldCategory,
    required String taskName,
    String? description,
    DateTime? dueDate,
  }) async {
    try {
      // Locate the current category and task
      TaskModel? taskToUpdate;

      // Locate the task within the old category
      taskToUpdate = _tasksByCategory[oldCategory]?.firstWhere(
        (task) => task.id == taskId,
        orElse: () => null as TaskModel, // Just return null (no casting needed)
      );

      if (taskToUpdate == null) {
        log('Task with ID $taskId not found.');
        return;
      }
      bool isUpdated = false;
      // If the category is the same, update the task details
      if (oldCategory == newCategory) {
        // Update task properties only if they have changed
        if (taskName != taskToUpdate.taskName) {
          taskToUpdate.taskName = taskName;
          isUpdated = true;
        }

        if (description != taskToUpdate.description) {
          taskToUpdate.description = description;
          isUpdated = true;
        }

        if (dueDate != taskToUpdate.dueDate) {
          taskToUpdate.dueDate = dueDate;
          isUpdated = true;
        }

        // If changes occurred, update the task in _tasksByCategory
        if (isUpdated) {
          _tasksByCategory[oldCategory!] = [
            for (var task in _tasksByCategory[oldCategory]!)
              if (task.id == taskId) taskToUpdate else task
          ];
        }
      } else if (oldCategory != newCategory) {
        log('Category has changed. Please move the task to the new category.');
        // Remove task from the old category
        _tasksByCategory[oldCategory]?.remove(taskToUpdate);

        // Ensure the new category exists
        _tasksByCategory.putIfAbsent(newCategory!, () => []);
        _tasksByCategory[newCategory]!.add(taskToUpdate);

        // Update the task's category
        taskToUpdate.category = newCategory;
        isUpdated = true; // Mark as updated if category changed
        // Optionally handle category change logic
      } else {
        log('No changes made to the task.');
      }
      // Save updated tasks to SharedPreferences
      await _saveTasks();
      notifyListeners();
      log('Task updated successfully.');
    } catch (e, stackTrace) {
      log('Error updating task: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tasksJson = prefs.getString('tasksByCategory');

      if (tasksJson != null) {
        Map<String, dynamic> decodedMap = jsonDecode(tasksJson);
        _tasksByCategory = decodedMap.map((key, value) {
          List<TaskModel> taskList = List<dynamic>.from(value).map((task) {
            return TaskModel.fromJson(task);
          }).toList();
          return MapEntry(key, taskList);
        });
        log('Tasks loaded successfully.');
      } else {
        _tasksByCategory = {};
        log('No tasks found in SharedPreferences.');
      }
      notifyListeners();
    } catch (e, stackTrace) {
      log('Error loading tasks: $e', stackTrace: stackTrace);
      _tasksByCategory = {};
      notifyListeners();
    }
  }

  // Count the number of tasks for a specific category
  int getTaskCount(String category) {
    return _tasksByCategory[category]?.length ?? 0;
  }

  // Get task counts for all categories
  Map<String, int> get taskCounts {
    return _tasksByCategory
        .map((category, tasks) => MapEntry(category, tasks.length));
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String tasksJson = jsonEncode(_tasksByCategory.map((key, value) {
        return MapEntry(key, value.map((task) => task.toJson()).toList());
      }));

      await prefs.setString('tasksByCategory', tasksJson);
      log('Tasks saved successfully.');
    } catch (e, stackTrace) {
      log('Error saving tasks: $e', stackTrace: stackTrace);
    }
  }

  // Clear all tasks (optional utility)
  Future<void> clearAllTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('tasksByCategory');
      _tasksByCategory.clear();
      notifyListeners();
      log('All tasks cleared successfully.');
    } catch (e, stackTrace) {
      log('Error clearing all tasks: $e', stackTrace: stackTrace);
    }
  }

  List<TaskModel> filterTasksByCategory(String category) {
    // Check if the category exists and if it's not null
    if (category.isNotEmpty && _tasksByCategory.containsKey(category)) {
      // Safely access the list of tasks for the category
      return _tasksByCategory[category]!
          .where((task) => task.category == category)
          .toList();
    }
    return []; // Return an empty list if category is not found or invalid
  }

  void toggleTaskCompletion(TaskModel task) {
    // Ensure the task exists and is not null before toggling completion
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      notifyListeners();
      _saveTasks(); // Save updated tasks
    }
  }
}
