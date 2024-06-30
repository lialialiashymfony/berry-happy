import 'package:berry_happy/login/login_screen.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key}); // Constructor of LaunchScreen class

  @override
  State<LaunchScreen> createState() =>
      _LaunchScreenState(); // Creating state for LaunchScreen
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi otomatis setelah 5 detik
    // Automatically navigate after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginScreen(), // Navigate to LoginScreen
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin =
                    Offset(1.0, 0.0); // Starting position of the transition
                const end = Offset.zero; // Ending position of the transition
                const curve = Curves.ease; // Animation curve

                var tween = Tween(begin: begin, end: end).chain(CurveTween(
                    curve:
                        curve)); // Tween animation from begin to end with given curve
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation, // Apply slide transition
                  child: child, // Display the child widget with the transition
                );
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 255, 204, 229), // Set background color of Scaffold
      body: Stack(
        // Stack widget to overlay widgets
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'), // Display logo image
              ],
            ),
          )
        ],
      ),
    );
  }
}
