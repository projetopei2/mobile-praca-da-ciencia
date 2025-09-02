import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    // ignore: deprecated_member_use
    background: Styles.backgroundColor, // Background
    primary: Styles.fontColor, // Fonte
    secondary: Styles.backgroundContentColor, // Background Content
    tertiary: Styles.textFieldColor, // Input 
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    // ignore: deprecated_member_use
    background: Styles.darkBackgroundColor,
    primary: Styles.darkFontColor,
    secondary: Styles.darkBackgroundContentColor,
    tertiary: Styles.darkTextFieldColor,
  )
);