import 'package:flutter/material.dart';
import 'schema_color.dart';

class AppBarThemeApp {
  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: SchemaColor.primaryColor,
    foregroundColor: SchemaColor.lightTextColor,
    centerTitle: true,
    elevation: 4,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: SchemaColor.lightTextColor,
    ),
  );
}
