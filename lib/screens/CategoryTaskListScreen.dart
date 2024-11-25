import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_task_page.dart';

class TaskListScreen extends StatefulWidget {
  final String category;

  const TaskListScreen({required this.category, Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Get tasks for the selected category
    final tasks = taskProvider.filterTasksByCategory(widget.category!);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Tasks"),
        backgroundColor: Colors.blue,
      ),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          "No tasks available",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTaskPage(task: task), // Pass the selected task
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  task.taskName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.description != null)
                      Text(
                        task.description!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    if (task.dueDate != null)
                      Text(
                        "Due: ${task.dueDate.toString().substring(0, 10)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      taskProvider.toggleTaskCompletion(task);
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
