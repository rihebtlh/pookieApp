import 'package:flutter/material.dart';

class QuizOption extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isCorrect;
  final bool answerLocked;
  final bool isBoyTheme;

  const QuizOption({
    super.key, 
    required this.text,
    required this.onPressed,
    this.isSelected = false,
    this.isCorrect = false,
    this.answerLocked = false,
    required this.isBoyTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the button color based on selection and correctness
    Color backgroundColor;
    Color textColor;

    if (answerLocked) {
      if (isCorrect) {
        // Correct answer
        backgroundColor = Colors.white;
        textColor = Colors.green;
      } else if (isSelected) {
        // Selected wrong answer
        backgroundColor = Colors.white;
        textColor = Colors.red;
      } else {
        // Other non-selected options when answer is locked
        backgroundColor = Colors.white;
        textColor = Colors.black;
      }
    } else if (isSelected) {
      // Selected but not locked - use theme colors
      if (isBoyTheme) {
        backgroundColor = const Color(0xFF72DDF7); // Light blue for boys
        textColor = Colors.black;
      } else {
        backgroundColor = const Color(0xFFFFAFCC); // Light pink for girls
        textColor = Colors.black;
      }
    } else {
      // Default state - not selected
      backgroundColor = Colors.white;
      textColor = isBoyTheme ? const Color(0xFF0039A6) : Colors.purple;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextButton(
          onPressed: answerLocked ? null : onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}