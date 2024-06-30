import 'package:berry_happy/components/assets_image_widget.dart';
import 'package:berry_happy/cubit/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Constructor of LoginScreen class

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState(); // Creating state for LoginScreen
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authCubit = BlocProvider.of<AuthCubit>(
        context); // Accessing AuthCubit using BlocProvider

    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 255, 204, 229), // Setting background color of Scaffold

      body: SafeArea(
        // Ensures content is within safe area of the screen
        child: Center(
          // Center aligns its child widget vertically and horizontally
          child: Column(
            // Column widget to arrange widgets vertically
            children: [
              const SizedBox(height: 40), // SizedBox for vertical spacing
              const AssetImageWidget(
                // Custom widget to display an AssetImage with specified properties
                imagePath: 'assets/images/logo.png', // Image path
                height: 250, // Height of the image widget
                width: 250, // Width of the image widget
                fit: BoxFit
                    .fill, // How the image should be inscribed into the box
              ),
              const SizedBox(height: 40), // SizedBox for vertical spacing
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30), // Padding around the text
                child: Text(
                  // Text widget with a message for the user
                  "Let's Make Your Day Berry Special!", // Text content
                  style: GoogleFonts.poppins(
                    // Styling the text with GoogleFonts
                    fontSize: 24, // Font size
                    fontWeight: FontWeight.bold, // Font weight
                  ),
                  textAlign: TextAlign.center, // Text alignment
                ),
              ),
              const SizedBox(height: 40), // SizedBox for vertical spacing
              SizedBox(
                // Container for the Login button
                height: 50, // Height of the button
                width: 250, // Width of the button
                child: ElevatedButton(
                  // ElevatedButton for the Login action
                  onPressed: () => Navigator.pushNamed(context,
                      '/main-login'), // Navigate to '/main-login' route on button press
                  style: ElevatedButton.styleFrom(
                    // Styling the ElevatedButton
                    backgroundColor: const Color.fromARGB(
                        255, 255, 255, 255), // Button background color
                  ),
                  child: const Text(
                    // Text within the ElevatedButton
                    'Login', // Button text
                    style: TextStyle(
                      // Styling the button text
                      color: Color.fromARGB(255, 255, 65, 158), // Text color
                      fontSize: 24, // Font size
                      fontWeight: FontWeight.bold, // Font weight
                      fontFamily: AutofillHints
                          .addressCity, // Font family (Note: Incorrect parameter, should be 'AutofillHints')
                    ),
                  ),
                ),
              ),
              Row(
                // Row widget to arrange widgets horizontally
                mainAxisAlignment: MainAxisAlignment
                    .center, // Center aligns the children horizontally
                children: [
                  const Text(
                      "Don't have account?"), // Text widget with a message
                  const SizedBox(height: 15), // SizedBox for vertical spacing
                  InkWell(
                    // InkWell for clickable 'Sign Up' text
                    onTap: () {
                      Navigator.pushNamed(context,
                          '/signup-screen'); // Navigate to '/signup-screen' on tap
                    },
                    child: const Text(
                      // Text within InkWell
                      "Sign Up", // Text content
                      style: TextStyle(
                        // Styling the text
                        color: Colors
                            .blue, // Text color (making it look like a link)
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
