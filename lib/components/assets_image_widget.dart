import 'package:flutter/material.dart';

// Define a StatelessWidget named AssetImageWidget
class AssetImageWidget extends StatelessWidget {
  // Declare final fields to hold the image path, width, height, and fit options
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;

  // Constructor to initialize the fields, with imagePath being required and others optional
  // ignore: use_super_parameters
  const AssetImageWidget({
    Key? key,
    required this.imagePath, // The path to the image asset is required
    this.width, // Optional width for the image
    this.height, // Optional height for the image
    this.fit, // Optional fit option for the image
  }) : super(key: key); // Call the superclass constructor with the key

  // Override the build method to describe how to display the widget
  @override
  Widget build(BuildContext context) {
    // Return an Image widget that displays an image from the asset bundle
    return Image.asset(
      imagePath, // Use the provided image path
      width: width, // Set the width if provided
      height: height, // Set the height if provided
      fit: fit ??
          BoxFit
              .contain, // Set the fit option, default to BoxFit.contain if not provided
    );
  }
}
