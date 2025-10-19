import 'package:flutter/material.dart';

// light mode theme
ThemeData lightMode = ThemeData(
    // app bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.grey.shade400),
      backgroundColor: Colors.grey.shade700,
      titleTextStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    ),
    //   main color scheme
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade300,
      primary: Colors.grey.shade600,
      secondary: Colors.grey,
      tertiary: Colors.white,
      inversePrimary: Colors.grey.shade900,
    ));
