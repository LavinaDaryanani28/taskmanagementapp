// // lib/screens/home_page.dart
//
// import 'package:flutter/material.dart';
// import '../models/task_model.dart';
// import 'CategoryScreen.dart';
// import 'add_task_page.dart';
// import '../services/shared_preferences_service.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   List<String> categories = [];
//   List<Task> tasks = [];
//   String? userName;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     categories = await SharedPreferencesService.getCategories();
//     tasks = await SharedPreferencesService.getTasks();
//     userName = await SharedPreferencesService.getUserName();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Task Manager')),
//       body: Column(
//         children: [
//           Text('Welcome, ${userName ?? "Guest"}'),
//           Expanded(
//             child: ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(tasks[index].name),
//                   subtitle: Text('${tasks[index].categoryName} - ${tasks[index].taskDescription}'),
//                   trailing: Checkbox(
//                     value: tasks[index].completed,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         tasks[index].completed = value ?? false;
//                       });
//                       SharedPreferencesService.saveTasks(tasks);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.task),
//             label: 'Tasks',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Categories',
//           ),
//         ],
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => AddTaskPage()),
//             );
//           } else if (index == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => CategoryScreen()),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
