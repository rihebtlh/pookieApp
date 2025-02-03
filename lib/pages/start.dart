import 'package:flutter/material.dart';
import 'package:pookieapp/pages/auth_page.dart'; // Ensure the path is correct

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Hey.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 150, // Adjust top positioning
            left: 30, // Adjust left positioning
            right: 30, // Adjust right positioning
            child: Image.asset(
              'assets/pookie.png',
              width: 350,
              height: 200,
            ),
          ),
          Positioned(
            bottom: 245, // Adjust spacing between image and button icon
            left: 200,
            child: Image.asset(
              'assets/catr.png', // Image above the button
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 200, // Adjust button positioning from bottom
            left: 80,
            right: 80,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 147, 109, 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Border radius
                ),
              ),
              child: const Text(
                'Start',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
