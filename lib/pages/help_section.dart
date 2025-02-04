import 'package:flutter/material.dart';

class HelpSection extends StatelessWidget {
  const HelpSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),  // Reduced padding for compact size
      decoration: BoxDecoration(
        color: const Color(0xFFF7AEF8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHelpItem('FAQ / Contact Us'),
          const SizedBox(height: 12),  // Reduced spacing
          _buildHelpItem('Terms of Service'),
          const SizedBox(height: 12),  // Reduced spacing
          _buildHelpItem('Privacy Policy'),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF1E1E1E),
            fontFamily: 'Rubik',
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 18),
      ],
    );
  }
}