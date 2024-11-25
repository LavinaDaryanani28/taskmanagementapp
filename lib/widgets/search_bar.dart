import 'package:flutter/material.dart';

import '../search/custom_search_delegate.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const CustomSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(onSearch: onSearch),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[800]),
            const SizedBox(width: 10),
            Text(
              'Search Tasks',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

