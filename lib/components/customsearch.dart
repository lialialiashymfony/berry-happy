import 'package:flutter/material.dart';

// Define a StatelessWidget named CustomSearchBox
class CustomSearchBox extends StatelessWidget {
  // Declare final fields for the text controller, onChanged function, onClear function, and hint text
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function onClear;
  final String hintText;

  // Constructor to initialize the fields
  // ignore: use_key_in_widget_constructors
  const CustomSearchBox({
    required this.controller, // The controller for the TextField
    required this.onChanged, // The function to call when the text changes
    required this.onClear, // The function to call when the clear button is pressed
    required this.hintText, // The hint text to display in the TextField
  });

  // Override the build method to describe how to display the widget
  @override
  Widget build(BuildContext context) {
    // Return a Container widget to provide padding and decoration
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10.0), // Add horizontal padding
      decoration: BoxDecoration(
        boxShadow: const [
          // Add a shadow to the container
          BoxShadow(
            color: Colors.black26, // Shadow color
            blurRadius: 10.0, // Blur radius of the shadow
            offset: Offset(0, 4), // Offset of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(24.0), // Slightly rounded corners
        color: Colors.white, // Background color of the container
      ),
      // Add a TextField widget inside the container
      child: TextField(
        controller: controller, // Set the controller for the TextField
        onChanged: onChanged, // Set the function to call when the text changes
        decoration: InputDecoration(
          hintText: hintText, // Set the hint text
          border: InputBorder.none, // Remove the default border
          hintStyle:
              TextStyle(color: Colors.grey.shade500), // Style for the hint text
          prefixIcon: Icon(Icons.search,
              color: Colors.grey.shade500), // Add a search icon
          suffixIcon: controller
                  .text.isNotEmpty // Add a clear icon if the text is not empty
              ? IconButton(
                  icon: Icon(Icons.clear,
                      color: Colors.grey.shade500), // Clear icon
                  onPressed: () {
                    controller.clear(); // Clear the text field
                    onClear(); // Call the onClear function
                  },
                )
              : null, // No icon if the text is empty
        ),
        style: const TextStyle(color: Colors.black87), // Style for the text
      ),
    );
  }
}
