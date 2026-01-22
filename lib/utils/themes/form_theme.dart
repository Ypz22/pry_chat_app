import 'package:flutter/material.dart';
import 'package:pry_chat_app/utils/themes/schema_color.dart';

class FormThemeApp {
  static final textFieldTheme = InputDecorationTheme(
    filled: true,
    fillColor: SchemaColor.backgroundColor,
    labelStyle: TextStyle(
      fontWeight: FontWeight.w500,
      color: SchemaColor.darkTextColor.withOpacity(0.6),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: SchemaColor.darkTextColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: SchemaColor.primaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
