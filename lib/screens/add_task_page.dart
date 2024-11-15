import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Name Field
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Task Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: Text("Select Category"),
              onChanged: (String? newCategory) {
                setState(() {
                  _selectedCategory = newCategory;
                });
              },
              items: categoryProvider.allCategories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Add Task Button
            ElevatedButton(
              onPressed: () async {
                if ((_taskNameController.text.isNotEmpty &&
                        _selectedCategory != null) ||
                    _descriptionController.text.isNotEmpty) {
                  // Add the task to the selected category
                  await taskProvider.addTask(
                    _selectedCategory!,
                    _taskNameController.text,
                    _descriptionController.text,
                  );
                  // Clear the text fields
                  _taskNameController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedCategory = null; // Reset selected category
                  });
                  Navigator.pop(
                      context); // Close the screen after adding the task
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
