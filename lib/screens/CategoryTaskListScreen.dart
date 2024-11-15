import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  final String category;

  TaskListScreen({required this.category});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, String>> tasks = [];

  @override
  void initState() {
    super.initState();
    // _loadTasks();
  }

  // Load tasks for the category
  // Future<void> _loadTasks() async {
  //   final taskProvider = Provider.of<TaskProvider>(context, listen: false);
  //   List<Map<String, String>> taskList = await taskProvider.getTasksForCategory(widget.category);
  //   setState(() {
  //     tasks = taskList;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Tasks"),
      ),
      body: tasks.isEmpty
          ? Center(child: Text("No tasks available"))
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task['taskName'] ?? ''),
            subtitle: Text(task['description'] ?? ''),
          );
        },
      ),
    );
  }
}

