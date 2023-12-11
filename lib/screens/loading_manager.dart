import 'package:flutter/material.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Display the main child.
        child,

        // Display loading overlay if isLoading is true.
        if (isLoading) ...[
          // Overlay with a semi-transparent black background.
          Container(
            color: Colors.black.withOpacity(0.7),
          ),

          // Loading indicator at the center of the screen.
          const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
