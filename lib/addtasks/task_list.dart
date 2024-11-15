// // addtasks/task_list.dart
// import 'package:flutter/material.dart';
// import '../models/task_model.dart';
//
// class TaskList extends StatelessWidget {
//   final List<Task> tasks;
//   final String category;
//
//   const TaskList({Key? key, required this.tasks, required this.category})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final categoryTasks = tasks.where((task) => task.category == category).toList();
//
//     return ListView.builder(
//       itemCount: categoryTasks.length,
//       itemBuilder: (context, index) {
//         final task = categoryTasks[index];
//         return ListTile(
//           title: Text(task.title),
//           subtitle: Text(task.description),
//         );
//       },
//     );
//   }
// }
