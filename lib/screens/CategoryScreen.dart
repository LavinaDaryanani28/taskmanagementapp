import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class CategoryScreen extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();

  // Function to open dialog for adding category
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
              onPressed: () {
                // Add category functionality here
                Provider.of<CategoryProvider>(context, listen: false)
                    .addCategory(_categoryController.text.trim());
                _categoryController.clear();
                Navigator.of(context).pop(); // Close dialog after adding
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
            ...categoryProvider.defaultCategories.map((category) => ListTile(
              title: Text(category),
              leading: const Icon(Icons.category, color: Colors.grey),
            )),
            const SizedBox(height: 20),
            const Text(
              "Custom Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categoryProvider.customCategories.length,
                itemBuilder: (context, index) {
                  final category = categoryProvider.customCategories[index];
                  return ListTile(
                    title: Text(category),
                    leading: const Icon(Icons.category, color: Colors.blue),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => categoryProvider.deleteCategory(category),
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
