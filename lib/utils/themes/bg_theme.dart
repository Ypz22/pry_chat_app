import 'package:flutter/material.dart';
import 'package:insurance_police/utils/themes/schema_color.dart';

class BgThemeApp {
  static const BoxDecoration bgDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [SchemaColor.secondaryColor, SchemaColor.accentColor],
    ),
  );

  static const BoxDecoration whiteBgDecoration = BoxDecoration(
    color: SchemaColor.backgroundColor,
  );

  static const BoxDecoration grayBgDecoration = BoxDecoration(
    color: SchemaColor.darkTextColor,
  );
}
