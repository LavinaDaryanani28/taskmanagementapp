import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import '../screens/CategoryTaskListScreen.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Color(0xF872E1A6),
      Color(0xE1E47979),
      Color(0xFFC495F6),
      Color(0xFFFAC25D),
    ];

    return Consumer2<CategoryProvider, TaskProvider>(
      builder: (context, categoryProvider, taskProvider, child) {
        final categories = categoryProvider.allCategories;

        if (categories.isEmpty) {
          return Center(child: Text('No categories available.'));
        }

        log('Rebuilding CategoryContainer');

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final containerColor = colors[categories.indexOf(category) % colors.length];
              final Color borderColor = Color.fromARGB(
                containerColor.alpha,
                (containerColor.red * 0.9).toInt(),
                (containerColor.green * 0.9).toInt(),
                (containerColor.blue * 0.9).toInt(),
              );

              // Access task count directly from TaskProvider
              final taskCount = taskProvider.taskCounts[category] ?? 0;
              log("task count category container : "+taskCount.toString());
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskListScreen(category: category),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Icon(Icons.keyboard_arrow_right, color: Colors.white),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$taskCount Tasks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
