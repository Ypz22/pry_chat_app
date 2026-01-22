import 'package:flutter/material.dart';
import 'package:pry_chat_app/utils/themes/schema_color.dart';

class Typographic {
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      color: SchemaColor.primaryColor,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: SchemaColor.darkTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: SchemaColor.darkTextColor,
      letterSpacing: 0.1,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: SchemaColor.darkTextColor,
    ),
  );
}
