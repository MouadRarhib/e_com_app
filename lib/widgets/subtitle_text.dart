import 'package:flutter/material.dart';

// SubtitleTextWidget: A widget for displaying subtitle text with customizable styles
class SubtitleTextWidget extends StatelessWidget {
  // Constructor to initialize the widget with optional parameters
  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textDecoration = TextDecoration.none,
  });

  // The text to be displayed
  final String label;

  // The font size of the text
  final double fontSize;

  // The font style of the text (e.g., normal, italic)
  final FontStyle fontStyle;

  // The font weight of the text (e.g., normal, bold)
  final FontWeight? fontWeight;

  // The color of the text
  final Color? color;

  // The decoration of the text (e.g., underline, line-through)
  final TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    // Return a Text widget with specified style properties
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        decoration: textDecoration,
      ),
    );
  }
}
