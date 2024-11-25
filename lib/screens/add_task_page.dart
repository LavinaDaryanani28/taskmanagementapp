import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For formatting the date
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import 'index.dart';

class AddTaskPage extends StatefulWidget {
  final TaskModel? task; // Nullable because it may be null for new tasks

  const AddTaskPage({this.task, Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Prefill fields for editing
      _taskNameController.text = widget.task!.taskName;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedCategory = widget.task!.category;
      _selectedDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Name Field
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Task Description Field (Optional)
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text("Select Category"),
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Due Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Due Date Selected'
                        : 'Due Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // Default to today's date
                      firstDate: DateTime.now(),  // Restrict to dates from today onward
                      lastDate: DateTime(2101),   // Allow dates up to the year 2101
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Add Task Button
            ElevatedButton(
              onPressed: () async {
                if (_taskNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task name cannot be empty.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (_selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a category.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (widget.task == null) {
                  // Add new task
                  await taskProvider.addTask(
                    category: _selectedCategory!,
                    taskName: _taskNameController.text.trim(),
                    description: _descriptionController.text.trim().isEmpty
                        ? null
                        : _descriptionController.text.trim(),
                    dueDate: _selectedDate,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task added successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Update existing task
                  await taskProvider.updateTask(
                    widget.task!.id,
                    newCategory: _selectedCategory,
                    oldCategory: widget.task!.category,
                    taskName: _taskNameController.text.trim(),
                    description: _descriptionController.text.trim().isEmpty
                        ? null
                        : _descriptionController.text.trim(),
                    dueDate: _selectedDate,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task edited successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                // // Add the task
                // await taskProvider.addTask(
                //   category:_selectedCategory!,
                //   taskName:_taskNameController.text.trim(),
                //   description:_descriptionController.text.trim().isEmpty
                //       ? null
                //       : _descriptionController.text.trim(),
                //   dueDate: _selectedDate,
                // );

                // Reset fields and show success message
                _taskNameController.clear();
                _descriptionController.clear();
                setState(() {
                  _selectedCategory = null;
                  _selectedDate = null;
                });

                // Navigate to index page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Index()),
                );
              },
              child: (widget.task) ==null ? Text('Add Task'):Text("Edit Task"),
            ),
          ],
        ),
      ),
    );
  }
}
