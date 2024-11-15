import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  final tasksSummary = ['Ongoing', 'Inprocess', 'Complete', 'Cancel'];

  final List<Color> colors = [
    Color(0xF872E1A6),
    Color(0xE1E47979),
    Color(0xFFC495F6),
    Color(0xFFFAC25D),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;

    double horizontalPadding = screenWidth * 0.05;
    double verticalPadding = screenHeight * 0.02;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: horizontalPadding,
                    mainAxisSpacing: verticalPadding,
      ),
      itemBuilder: (context, index) {
        final Color containerColor = colors[index % colors.length];
                    final Color borderColor = Color.fromARGB(
                      containerColor.alpha,
                      (containerColor.red * 0.8).toInt(),
                      (containerColor.green * 0.8).toInt(),
                      (containerColor.blue * 0.8).toInt(),
                    );
        return GestureDetector(
          onTap: () {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //       content: Text('Tapped on ${taskStateNames[index]}')),
            // );
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Center(
                child: Text(tasksSummary[index],
                    style: TextStyle(color: Colors.white))),
          ),
        );
      },
    );
  }
}
