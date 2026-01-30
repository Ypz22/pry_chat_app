import 'package:flutter/material.dart';
import 'schema_color.dart';
import 'typographic.dart';
import 'app_bar_theme.dart';
import 'button_theme.dart';
import 'form_theme.dart';

class GeneralTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark, // Indica que es un tema oscuro
    colorScheme: ColorScheme.dark(
      primary: SchemaColor.primaryColor,
      secondary: SchemaColor.secondaryColor,
      background: SchemaColor.backgroundColor,
      surface: SchemaColor.secondaryColor, // Superficies de tarjetas, etc.
      error: SchemaColor.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),

    textTheme: Typographic.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    appBarTheme: AppBarThemeApp.appBarTheme,
    elevatedButtonTheme: ButtonThemeApp.primaryButtonStyle,
    outlinedButtonTheme: ButtonThemeApp.secondaryButtonStyle,
    inputDecorationTheme: FormThemeApp.textFieldTheme,
    scaffoldBackgroundColor: SchemaColor.backgroundColor,
  );
}
