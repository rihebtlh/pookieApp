import 'package:flutter/material.dart';
import 'profile_form.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen height and width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // The Scrollable Profile Form wrapped inside a Center widget to align vertically and horizontally
          Center(
            child: Container(
              height: screenHeight, // Make the container take the full height of the screen
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileForm(),
            ),
          ),
          // Clouds positioned at the extreme bottom independently, centered horizontally
          Positioned(
            bottom: 0, // Place the first cloud at the very bottom
            left: (screenWidth -500) / 2, // Center the cloud horizontally
            child: Image.asset(
              'assets/cloud7.png',
              width: 400, // Adjust size as needed
              height: 150, // Adjust size as needed
              semanticLabel: 'Cloud 7',
            ),
          ),
          Positioned(
            bottom: 0, // Position it at the same bottom as cloud7
            left: (screenWidth - 200) / 2, // Center the second cloud horizontally
            child: Image.asset(
              'assets/cloud8.png',
              width: 350, // Adjust size as needed
              height: 100, // Adjust size as needed
              semanticLabel: 'Cloud 8',
            ),
          ),
        ],
      ),
    );
  }
}

