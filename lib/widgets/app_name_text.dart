import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:e_com_app/widgets/title_text.dart';

// AppNameTextWidget: A widget for displaying a shimmering app name text
class AppNameTextWidget extends StatelessWidget {
  // Constructor to initialize the widget with an optional font size
  const AppNameTextWidget({super.key, this.fontSize = 30});

  // The font size of the app name text
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // Create a shimmer effect with changing colors
    return Shimmer.fromColors(
      period: const Duration(seconds: 16),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      // Display the shimmering app name text using TitlesTextWidget
      child: TitlesTextWidget(
        label: "Shop Smart",
        fontSize: fontSize,
      ),
    );
  }
}
