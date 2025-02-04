import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String? icon;
  final String title;
  final Color color;

  const FeatureCard({
    Key? key,
    this.icon,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 140,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: icon != null ? 24 : 0,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: icon != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        crossAxisAlignment: icon != null
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Image.network(
              icon!,
              width: 35,
              height: 25,
              semanticLabel: 'Feature icon',
            ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontFamily: 'Caveat Brush',
                  fontSize: icon != null ? 26 : 24,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}