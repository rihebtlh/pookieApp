import 'package:flutter/material.dart';

class AskPookieButton extends StatelessWidget {
  const AskPookieButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7AEF8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 30),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ask Pookie',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontFamily: 'Caveat Brush',
                  fontSize: 28,
                ),
          ),
          Image.asset(
          'assets/cat.png',
          width: 50,
            semanticLabel: 'Pookie assistant icon',
          ),
        ],
      ),
    );
  }
}