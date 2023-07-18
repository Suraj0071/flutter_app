import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';

MaterialColor colorCustom = const MaterialColor(0xFFFFFFFF, THEME_COLOR_SHADES);
final ThemeData appThemeData = ThemeData(
  fontFamily: 'MatteoRegular',
  primarySwatch: colorCustom,
  backgroundColor: BG_COLOR,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: FONT_APPBAR_TITLE,
      fontFamily: "MatteoMedium",
      color: APPBAR_TXT_CLR,
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: FONT_MD, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(
        fontSize: FONT_SM, fontStyle: FontStyle.normal, color: APPBAR_TXT_CLR),
    // headlineSmall: TextStyle(fontSize: FONT_XSS, fontStyle: FontStyle.normal),
    bodyMedium: TextStyle(fontSize: FONT_XSS),
  ),
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: NORMAL_TEXT_CLR),
  // Add more customizations to your theme if needed
);
