import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),  // Reduced padding for compact size
      decoration: BoxDecoration(
        color: const Color(0xFFFFAFCC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Andres Fort',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Rubik',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'r.hectorfort@gmail.com',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Rubik',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to profile page when the pen icon is clicked
              Navigator.pushNamed(context, '/profile');
            },
            child: Image.asset(
              'assets/edit.png',  // Path to your pen icon image
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
