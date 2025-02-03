import 'package:flutter/material.dart';

final ThemeData girlTheme = ThemeData(
  primarySwatch: Colors.pink,
  primaryColor: const Color(0xFFF7AEF8),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFFAFCC),//soft Pink
    secondary:  Color(0xFFB388EB),//Light Purple
  ),
  appBarTheme: const AppBarTheme(color: Colors.pink),
  textTheme: const TextTheme(
    //bodyLarge: TextStyle(color: Colors.pink, fontSize: 16),
  ),
);