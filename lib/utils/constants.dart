// Import necessary packages
import 'package:flutter/material.dart'; // Flutter's material design library
import 'package:intl/intl.dart'; // Internationalization library for date and number formatting

// Define a class Constants to hold static color constants
class Constants {
  // Define static constant colors using Color.fromARGB
  static const Color primaryColor =
      Color.fromARGB(255, 255, 65, 158); // Pink primary color
  static const Color scaffoldBackgroundColor =
      Color.fromRGBO(255, 255, 255, 1); // White scaffold background color
  static const Color activeMenu =
      Color.fromARGB(255, 167, 167, 167); // Gray color for active menu items
}

// Define a global constant secondaryColor using hexadecimal value
const secondaryColor =
    Color(0xFF5593f8); // Secondary color in hexadecimal format

// Define a global constant primaryColor using hexadecimal value
const primaryColor = Color(0xFF48c9e2); // Primary color in hexadecimal format

// Initialize NumberFormat instance for currency formatting with Indonesian locale and 'Rp ' symbol
final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

// Initialize DateFormat instance for formatting dates and times in 'yyyy-MM-dd H:mm' format
final DateFormat formatDate = DateFormat('yyyy-MM-dd H:mm');

// Define a global constant tokenStoreName with the value "access_token"
const tokenStoreName = "access_token";
