import 'package:flutter/material.dart';

import 'subtitle_text.dart';
import 'title_text.dart';

// EmptyBagWidget: Widget displayed when the shopping bag is empty
class EmptyBagWidget extends StatelessWidget {
  // Constructor to initialize the widget with required data
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  // The path to the image displayed at the top of the widget
  final String imagePath;

  // The title text displayed below the image
  final String title;

  // The subtitle text displayed below the title
  final String subtitle;

  // The text displayed on the button
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    // Get the device screen size
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Image at the top of the widget
            Image.asset(
              imagePath,
              height: size.height * 0.35,
              width: double.infinity,
            ),
            const TitlesTextWidget(
              label: "Whoops",
              fontSize: 40,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            // Title text below the image
            SubtitleTextWidget(
              label: title,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
            const SizedBox(
              height: 20,
            ),
            // Subtitle text below the title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Button with onPressed callback (currently empty)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20), elevation: 0),
              onPressed: () {},
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
