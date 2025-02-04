import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gender_option.dart';

class GenderSelectionScreen extends StatelessWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/cloud1.png',
                          width: 197,
                          height: 100,
                          semanticLabel: 'Decorative child image',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 145, top: 5),
                          child: Text(
                            'Child',
                            style: GoogleFonts.irishGrover(
                              fontSize: 48,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GenderOption(
                              label: 'Girl',
                              imagePath: 'assets/girl.png',
                              onTap: () {
                                Navigator.pushNamed(context, '/birthday');
                              },
                            ),
                            const SizedBox(width: 38),
                            GenderOption(
                              label: 'Boy',
                              imagePath: 'assets/boy.png',
                              onTap: () {
                                Navigator.pushNamed(context, '/birthday');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Positioned elements
              Positioned(
                bottom: 10, // Adjusted bottom position for cloud2
                left: 200,
                child: Image.asset(
                  'assets/cloud2.png',
                  width: 270,
                  alignment: Alignment.centerLeft,
                  semanticLabel: 'Decorative bottom cloud image',
                ),
              ),
              Positioned(
                bottom: 125, // Adjusted bottom position for the cat image
                left: 320,
                child: Image.asset(
                  'assets/catblue.png',
                  width: 60,
                  height: 90,
                  semanticLabel: 'Cute cat icon',
                ),
              ),
              Positioned(
                bottom: 150, // Adjusted position of "Choose one!"
                left: 180,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0x21333333),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Choose one !',
                    style: GoogleFonts.caveatBrush(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
