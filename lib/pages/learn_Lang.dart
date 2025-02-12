import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Buttons Centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.centerLeft, // Position Icon on the left
                  children: [
                    IgnorePointer(
                      child: buildSmallButton(
                        'Learn Languages',
                        Theme.of(context).colorScheme.secondary,
                        () {},
                      ),
                    ),
                    Positioned(
                      left: 10, // Adjust distance from the left edge
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        iconSize: 28,
                        onPressed: () {
                          Navigator.pop(context); // Go back action
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 200),
                buildButton(
                  'Talk with Pookie',
                  Theme.of(context).colorScheme.secondary,
                  () {},
                ),
                const SizedBox(height: 115),
                buildButton(
                  'Questions',
                  Theme.of(context).colorScheme.secondary,
                  () {},
                ),
              ],
            ),
          ),

          // Cat Image
          Positioned(
            bottom: 188,
            right: 50,
            child: Image.asset(
              'assets/cat1.png',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSmallButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 350,
      height: 90,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 300,
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}