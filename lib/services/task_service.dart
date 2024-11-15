// // lib/services/task_service.dart
//
// import 'package:flutter/material.dart';
// import '../models/task_model.dart';
//
// class TaskService with ChangeNotifier {
//   List<Task> _tasks = [];
//   List<String> _categories = ['Personal', 'Work', 'Birthday', 'Wishlist'];
//
//   List<Task> get tasks => _tasks;
//   List<String> get categories => _categories;
//
//   void addTask(String title, String description, String category) {
//     final newTask = Task(
//       title: title,
//       description: description,
//       category: category,
//     );
//     _tasks.add(newTask);
//     notifyListeners();
//   }
//
//   void addCategory(String category) {
//     if (!_categories.contains(category)) {
//       _categories.add(category);
//       notifyListeners();
//     }
//   }
//
//   void deleteCategory(String category) {
//     _categories.remove(category);
//     notifyListeners();
//   }
//
//   void deleteTask(Task task) {
//     _tasks.remove(task);
//     notifyListeners();
//   }
// }
