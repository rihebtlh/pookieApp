import 'package:flutter/material.dart';
import 'package:pookieapp/theme/girl.dart';
import 'package:pookieapp/theme/boy.dart';


class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = boyTheme;
  String _backgroundImage = "assets/boy_bg.png"; // Default background

  ThemeData get currentTheme => _currentTheme;
  String get backgroundImage => _backgroundImage;

  void toggleTheme(bool isBoyTheme) {
    _currentTheme = isBoyTheme ? boyTheme : girlTheme;
    _backgroundImage = isBoyTheme ? "assets/boy_bg.png" : "assets/girl_bg.png"; 
    notifyListeners();
  }
}
