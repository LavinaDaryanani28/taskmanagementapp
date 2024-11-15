// import 'package:flutter/material.dart';
// import 'addtasks/task_model.dart';
// import 'addtasks/add_task_dialog.dart';
// import 'category_tasks_screen.dart';  // Import the new screen
// import 'custom_search_delegate.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   int _selectedIndex = 0;
//   List<String> categories = ['Personal', 'Work', 'Birthday', 'Wishlist'];
//   List<Task> tasks = [];
//
//   void addCategory(String categoryName) {
//     if (categories.contains(categoryName)) {
//       _showDuplicateCategoryDialog(categoryName);
//     } else {
//       setState(() {
//         categories.add(categoryName);
//       });
//     }
//   }
//
//   // Adds a new task under the specified category
//   void addTask(String title, String description, String category) {
//     setState(() {
//       tasks.add(Task(title: title, description: description, category: category));
//     });
//   }
//
//   void _showDuplicateCategoryDialog(String categoryName) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Category Exists'),
//           content: Text('The category "$categoryName" already exists!'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Show dialog to add a new task
//   void _showAddTaskDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AddTaskDialog(
//         categories: categories,
//         onAddTask: (title, description, category) {
//           addTask(title, description, category);
//         },
//         onCreateCategory: addCategory,
//       ),
//     );
//   }
//
//   // Get task count for a specific category
//   int getTaskCount(String category) {
//     return tasks.where((task) => task.category == category).length;
//   }
//
//   // Navigate to the CategoryTasksScreen for the selected category
//   void _navigateToCategoryTasks(String category) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CategoryTasksScreen(
//           category: category,
//           tasks: tasks,
//         ),
//       ),
//     );
//   }
//
//   final List<Widget> _pages = [
//     Center(child: Text('Home Screen', style: TextStyle(color: Colors.white))),
//     Center(
//         child: Text('Add Task Screen', style: TextStyle(color: Colors.white))),
//     Center(
//         child: Text('Calendar Screen', style: TextStyle(color: Colors.white))),
//   ];
//
//   void _onItemTapped(int index) {
//     if (index == 1) {
//       _showAddTaskDialog();
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double topPadding = MediaQuery.of(context).padding.top;
//
//     double horizontalPadding = screenWidth * 0.05;
//     double verticalPadding = screenHeight * 0.02;
//
//     final List<Color> colors = [
//       Color(0xF872E1A6),
//       Color(0xE1E47979),
//       Color(0xFFC495F6),
//       Color(0xFFFAC25D),
//     ];
//     List<Color> reversedColors = List.from(colors.reversed);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(120),
//         child: AppBar(
//           backgroundColor: Colors.white,
//           flexibleSpace: Padding(
//             padding: EdgeInsets.only(
//               top: topPadding + 20,
//               left: horizontalPadding,
//               right: horizontalPadding,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Hello, Lavina!",
//                   style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "You have ${tasks.length} tasks today.",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           elevation: 0,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(
//             horizontal: horizontalPadding, vertical: verticalPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 showSearch(context: context, delegate: CustomSearchDelegate());
//               },
//               child: Container(
//                 padding: EdgeInsets.all(12.0),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search, color: Colors.grey[800]),
//                     SizedBox(width: 10),
//                     Text('Search Tasks',
//                         style:
//                         TextStyle(color: Colors.grey[500], fontSize: 16)),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text("Summary",
//                 style: TextStyle(color: Colors.black, fontSize: 18)),
//             SizedBox(height: 10),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: 4,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: horizontalPadding,
//                 mainAxisSpacing: verticalPadding,
//                 childAspectRatio: 1.0,
//               ),
//               itemBuilder: (context, index) {
//                 final Color containerColor = colors[index % colors.length];
//                 final Color borderColor = Color.fromARGB(
//                   containerColor.alpha,
//                   (containerColor.red * 0.8).toInt(),
//                   (containerColor.green * 0.8).toInt(),
//                   (containerColor.blue * 0.8).toInt(),
//                 );
//
//                 return GestureDetector(
//                   onTap: () {
//                     // ScaffoldMessenger.of(context).showSnackBar(
//                     //   SnackBar(
//                     //       content: Text('Tapped on ${taskStateNames[index]}'))),
//                     // );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: containerColor,
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(color: borderColor, width: 2),
//                     ),
//                     child: Center(
//                         child: Text('Task State',
//                             style: TextStyle(color: Colors.white))),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             Text("Task Categories",
//                 style: TextStyle(color: Colors.black, fontSize: 18)),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: categories.map((category) {
//                   final containerColor = reversedColors[
//                   categories.indexOf(category) % reversedColors.length];
//                   final Color borderColor = Color.fromARGB(
//                     containerColor.alpha,
//                     (containerColor.red * 0.9).toInt(),
//                     (containerColor.green * 0.9).toInt(),
//                     (containerColor.blue * 0.9).toInt(),
//                   );
//
//                   return GestureDetector(
//                     onTap: () {
//                       _navigateToCategoryTasks(category);  // Navigate to the tasks screen
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(right: 20),
//                       width: 150,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         color: containerColor,
//                         borderRadius: BorderRadius.circular(25.0),
//                         border: Border.all(color: borderColor, width: 2),
//                       ),
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 category,
//                                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                                 textAlign: TextAlign.center,
//                               ),
//                               Icon(Icons.keyboard_arrow_right, color: Colors.white),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white54,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.add_task), label: 'Add Task'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_today), label: 'Calendar'),
//         ],
//       ),
//     );
//   }
// }
