import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'date_input_field.dart';
import 'continue_button.dart';

class BirthdayFormScreen extends StatelessWidget {
  const BirthdayFormScreen({Key? key}) : super(key: key);

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
                    padding: const EdgeInsets.only(top: 30, left: 100), // Reduced top padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center( 
                          child: Text(
                            'When is your Birthday?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFAFCC),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35), // Reduced spacing
                        const DateInputField(),
                        const SizedBox(height: 45), // Moved the button slightly higher
                        ContinueButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Positioned elements
              Positioned(
                bottom: 10, 
                left: 210,
                child: Image.asset(
                  'assets/cloud2.png',
                  width: 270,
                  alignment: Alignment.centerLeft,
                  semanticLabel: 'Decorative bottom cloud image',
                ),
              ),
              Positioned(
                bottom: 125, 
                left: 350,
                child: Image.asset(
                  'assets/catblue.png',
                  width: 60,
                  height: 90,
                  semanticLabel: 'Cute cat icon',
                ),
              ),
              Positioned(
                bottom: 150, 
                left: 120,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0x21333333),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'When is your birthday?',
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