import 'package:flutter/material.dart';
import 'package:e_com_app/screens/search_screen.dart';
import 'package:e_com_app/widgets/subtitle_text.dart';

// CategoryRoundedWidget: A widget for displaying rounded category items
class CategoryRoundedWidget extends StatelessWidget {
  // Constructor to initialize the widget with required image and name
  const CategoryRoundedWidget({
    super.key,
    required this.image,
    required this.name,
  });

  // The path to the category image
  final String image;

  // The name of the category
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigate to the SearchScreen when the widget is tapped
      onTap: () {
        Navigator.pushNamed(
          context,
          SearchScreen.routeName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          // Display the category image
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          const SizedBox(
            height: 15,
          ),
          // Display the category name with specified font size and weight
          SubtitleTextWidget(
            label: name,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
