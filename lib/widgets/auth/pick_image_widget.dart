import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// PickImageWidget: A widget for displaying and picking images
class PickImageWidget extends StatelessWidget {
  // Constructor to initialize the widget with optional pickedImage and required function
  const PickImageWidget({super.key, this.pickedImage, required this.function});

  // The picked image file
  final XFile? pickedImage;

  // The function to be executed when the user interacts with the widget
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Display the picked image or a placeholder container
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: pickedImage == null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                  )
                : Image.file(
                    File(
                      pickedImage!.path,
                    ),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        // Positioned button at the top right for user interaction
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.lightBlue,
            child: InkWell(
              splashColor: Colors.red,
              borderRadius: BorderRadius.circular(16.0),
              // Trigger the specified function when the button is tapped
              onTap: () {
                function();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_shopping_cart_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
