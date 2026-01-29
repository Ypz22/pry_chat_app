import 'package:flutter/material.dart';
import 'schema_color.dart';

class ButtonThemeApp {
  static final primaryButtonStyle = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: SchemaColor.secondaryColor,
      foregroundColor: SchemaColor.lightTextColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  static final secondaryButtonStyle = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: SchemaColor.darkTextColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: SchemaColor.secondaryColor, width: 2),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
