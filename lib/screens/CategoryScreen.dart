import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class CategoryScreen extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();

  // Function to open dialog for adding a category
  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Category"),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              hintText: "Enter category name",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without action
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);
                String newCategory = _categoryController.text.trim();

                if (newCategory.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Category name cannot be empty."),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  try {
                    await categoryProvider.addCategory(newCategory);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Category '$newCategory' added."),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop(); // Close dialog after adding
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }

                _categoryController.clear();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Categories"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Default Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...categoryProvider.defaultCategories.map(
                  (category) => ListTile(
                title: Text(category),
                leading: const Icon(Icons.category, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Custom Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: categoryProvider.customCategories.isEmpty
                  ? const Center(
                child: Text(
                  "No custom categories available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: categoryProvider.customCategories.length,
                itemBuilder: (context, index) {
                  final category =
                  categoryProvider.customCategories[index];
                  return ListTile(
                    title: Text(category),
                    leading:
                    const Icon(Icons.category, color: Colors.blue),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          await categoryProvider.deleteCategory(category);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                              Text("Category '$category' deleted."),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
