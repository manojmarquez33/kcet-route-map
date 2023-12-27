import 'package:flutter/material.dart';

class AppConstants {
  //-------------------colors---------------------------------------------------------

  static final LinearGradient BlueWhite = LinearGradient(
    colors: [Color(0xFFe3fdfe), Color(0xFFf8fcff)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static final LinearGradient OrangeWhite = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFfe6a00)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  static final Color lightwhite = Color(0xFFf6f6f6);
  static final Color SpecialDark = Color(0xFF0d0d0d);
  static final Color MainColor = Color(0xFF070A52); //dark blue
  static final Color Orange = Color(0xFFfe6a00); //orange
  static final Color white = Color(0xFFFFFFFF);
  //-------------------Links start---------------------------------------------------------

  // static final String BASH_URL = 'http://10.0.2.2:8082/route_map/';
  static final String BASH_URL = 'https://kcetmap.000webhostapp.com/';

  static final String Class_API = 'ClassAPI.php';
}

//-------------------Links end ---------------------------------------------------------
