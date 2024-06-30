import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define a constant for the secondary color used in the app
const secondaryColor = Color(0xFF5593f8);

// Define a constant for the primary color used in the app
const primaryColor = Color(0xFF48c9e2);

// Create a NumberFormat instance for formatting currency in the US locale with the dollar symbol
// Uncomment the below line and comment the above line to format currency in the Indonesian locale with the rupiah symbol
// final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

// Create a DateFormat instance for formatting dates in the 'yyyy-MM-dd H:mm' pattern
final DateFormat formatDate = DateFormat('yyyy-MM-dd H:mm');

// Define a constant for the name of the token storage key
const tokenStoreName = "access_token";
