import 'package:flutter/material.dart';

final ThemeData boyTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: const Color(0xFFBDE0FE),
  colorScheme: const ColorScheme.dark(
    primary:  Color(0xFF72DDF7),
    secondary:  Color(0xFF0039A6),// Dark Blue
  ),
  appBarTheme: const AppBarTheme(color: Colors.blue),
  textTheme: const TextTheme(
    //bodyLarge: TextStyle(color: Colors.blue, fontSize: 16),
  ),
);