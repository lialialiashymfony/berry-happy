import 'package:flutter/material.dart';

class CafeBackgroundScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const CafeBackgroundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 204, 229),
            ),
          ),
          // Logo
          Positioned(
            top: 40,
            left: 20,
            child: Image.asset(
              'assets/images/logo.png', // Path to your logo asset
              width: 100, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),
          ),
          // Content on top of the background
          Center(
            child: Container(
              color:
                  Colors.white.withOpacity(0.5), // Semi-transparent background
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Berry Happy Cafe',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Berry Happy not only offers delicious delights that pamper the taste buds, but also prioritizes the quality and freshness of local ingredients. Each dessert is made with selected strawberries from Bedugul, which are harvested and processed with love to maintain the best taste and nutritional value. Now, Berry Happy is taking a step forward by adopting digitalization to make interactions with customers easier. Ordering Berry Happy desserts can be done easily via the online platform, opening wider access for culinary lovers wherever they are. Digitalization also allows Berry Happy to provide more personalized service and connect with customers more closely.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous screen
              },
            ),
          ),
        ],
      ),
    );
  }
}
