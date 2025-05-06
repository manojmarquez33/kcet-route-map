import 'package:flutter/material.dart';

class AppConstants {
  // Gradients
  static final LinearGradient BlueWhite = LinearGradient(
    colors: [Color(0xFFe3fdfe), Color(0xFFf8fcff)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static final LinearGradient OrangeWhite = LinearGradient(
    colors: [Color(0xFFfe6a00), Color(0xFFf6f6f6)],
    begin: Alignment.center,
    end: Alignment.centerLeft,
  );

  // Colors
  static final Color lightwhite = Color(0xFFf6f6f6);
  static final Color SpecialDark = Color(0xFF0d0d0d);
  static final Color Orange = Color(0xFFfe6a00);
  static final Color white = Color(0xFFFFFFFF);

  // API URLs
  static final String BASH_URL = 'https://routemap.codemub.com';
  static final String Class_API = 'ClassAPI.php';
  static final String ChatBot_API = 'ChatBotAPI.php';
}
