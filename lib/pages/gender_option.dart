import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenderOption extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const GenderOption({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Select $label',
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              semanticLabel: '$label option background',
            ),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 51,
                  horizontal: 39,
                ),
                child: Text(
                  label,
                  style: GoogleFonts.irishGrover(
                    fontSize: 45,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}