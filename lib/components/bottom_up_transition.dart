import 'package:flutter/material.dart';

// Define a custom PageRouteBuilder named BottomUpRoute
class BottomUpRoute extends PageRouteBuilder {
  // Declare a final field to hold the target page widget
  final Widget page;

  // Constructor to initialize the page field
  BottomUpRoute({required this.page})
      : super(
          // Define the pageBuilder to specify the target page
          pageBuilder: (context, animation, secondaryAnimation) => page,
          // Define the transitionsBuilder to specify the transition animation
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            // Use Tween to define the start and end positions of the animation
            position: Tween<Offset>(
              begin:
                  const Offset(0, 1), // Start position (bottom of the screen)
              end: const Offset(0, 0), // End position (original position)
            ).animate(CurvedAnimation(
              parent: animation, // Use the provided animation
              curve: Curves
                  .easeInOut, // Use an ease-in-out curve for the transition
            )),
            child: child, // The widget to be animated
          ),
        );
}
