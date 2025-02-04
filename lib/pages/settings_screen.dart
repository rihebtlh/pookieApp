import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/profile_card.dart';
import 'widgets/notification_settings.dart';
import 'widgets/help_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            constraints: BoxConstraints(
              maxWidth: 480,
              minHeight: MediaQuery.of(context).size.height, // Ensures full screen height
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 10,
                    child: Image.asset(
                      'assets/cloud3.png',
                      width: 270,
                      height: 150,
                    ),
                  ),
                   // Back button (top-left corner)
                  Positioned(
                    top: 50, // Adjust top position
                    left: 30, // Adjust left position
                    child: GestureDetector(
                      onTap: () {
                        Navigator.popUntil(context, ModalRoute.withName('/home'));
                      },
                      child: Image.asset(
                        'assets/back.png', // Path to your back button image
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    right: 80,
                    child: Image.asset(
                      'assets/catgreen.png',
                      width: 50,
                      height: 60,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 50), // Space for title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Settings',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100), // Space after title
                      // Centering ProfileCard
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 320),
                          child: const ProfileCard(),
                        ),
                      ),
                      const SizedBox(height: 10), // Space after ProfileCard
                      // Centering NotificationSettings
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 320),
                          child: const NotificationSettings(),
                        ),
                      ),
                      const SizedBox(height: 10), // Space after NotificationSettings
                      // Centering HelpSection
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 320),
                          child: const HelpSection(),
                        ),
                      ),
                      const SizedBox(height: 10), // Space before logout button
                      // Centering LogOut button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement logout logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7AEF8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            minimumSize: const Size(143, 50),
                          ),
                          child: const Text(
                            'LogOut',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40), // Space before the cloud image
                    ],
                  ),
                  Positioned(
                    bottom: 0, // Adding some space above Cloud 6 to create distance from LogOut button
                    right: 100, // Aligning Cloud 6 to the left side
                    child: Image.asset(
                      'assets/cloud6.png',
                      width: 385, // Slightly larger Cloud 6
                      height: 115, // Slightly larger Cloud 6
                    ),
                  ),
                  Positioned(
                    bottom: 20, 
                    left: 146,
                    child: Image.asset(
                      'assets/cloud4.png',
                      width: 305,
                      height: 150,
                    ),
                  ),
                  Positioned(
                    bottom: 0, // Adjust this to control overlap
                    left: 210,
                    child: Image.asset(
                      'assets/cloud5.png',
                      width: 225, // Cloud 5 is smaller than Cloud 4
                      height: 105,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}