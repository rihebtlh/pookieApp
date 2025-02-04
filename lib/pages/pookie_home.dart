import 'package:flutter/material.dart';
import 'package:pookie/pages/home_pookie/ask_pookie_button.dart';
import 'package:pookie/pages/home_pookie/feature_card.dart';

class PookieHome extends StatelessWidget {
  const PookieHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(  // Center the entire content
        child: SingleChildScrollView(
          child: Transform.translate(  // Apply a small offset to the left
            offset: const Offset(-85, 0),  // Move it 85 pixels to the left (approximately 2 cm)
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              constraints: BoxConstraints(
                maxWidth: 480,
                minHeight: MediaQuery.of(context).size.height,  // Adjust minHeight to screen height
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                'assets/cloud9.png',
                                width: 195,
                                semanticLabel: 'Pookie Logo',
                              ),
                            ),
                            const SizedBox(height: 100),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: AskPookieButton(),
                            ),
                            const SizedBox(height: 10),
                            _buildFeatureCards(),
                          ],
                        ),
                      ),
                      _buildBottomCloud(),
                    ],
                  ),
                  Positioned(
                    left: 130,
                    bottom: 480,
                    child: Image.asset(
                      'assets/catpink.png',
                      width: 60,
                      semanticLabel: 'Decorative element',
                    ),
                  ),
                  // Profile Icon with GestureDetector
                  Positioned(
                    bottom: 55,
                    right: 30, // This ensures the profile icon is on the bottom-right
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Image.asset(
                        'assets/profile1.png',
                        width: 40,
                        semanticLabel: 'Profile Icon',
                      ),
                    ),
                  ),
                  // Settings Icon with GestureDetector
                  Positioned(
                    bottom: 55,
                    right: 312, // Keep this unchanged as it is the valid position
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Image.asset(
                        'assets/settings.png',
                        width: 40,
                        semanticLabel: 'Settings Icon',
                      ),
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

  Widget _buildFeatureCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        FeatureCard(
          icon: 'assets/pen.png',
          title: 'Storytelling',
          color: Color(0xFFB388EB),
        ),
        SizedBox(width: 20),
        FeatureCard(
          icon: 'assets/ball.png',
          title: 'Learn\nLanguages',
          color: Color(0xFFFFAFCC),
        ),
      ],
    );
  }

  Widget _buildBottomCloud() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 90),
      child: Image.asset(
        'assets/cloud10.png',
        width: 345,
        semanticLabel: 'Footer illustration',
      ),
    );
  }
}