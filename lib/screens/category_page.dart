import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('Details for $category category.'),
      ),
    );
  }
}
