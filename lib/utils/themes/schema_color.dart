import 'package:flutter/material.dart';

class SchemaColor {
  static const Color primaryColor = Color.fromARGB(255, 118, 64, 184);

  static const Color secondaryColor = Color(0xFF333333);

  static const Color accentColor = Color.fromARGB(255, 153, 69, 255);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFCF6679);

  static const Color backgroundColor = Color(0xFF000000);

  static const Color lightTextColor = Color(0xFFFFFFFF);
  static const Color darkTextColor = Color(
    0xB3FFFFFF,
  ); // Texto blanco con transparencia para contraste
}

Color obtenerColorUsuario(String nombre) {
  final List<Color> coloresDisponibles = [
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
    Colors.amberAccent,
  ];

  // Generamos un código numérico basado en el texto del nombre
  int hash = 0;
  for (var i = 0; i < nombre.length; i++) {
    hash = nombre.codeUnitAt(i) + ((hash << 5) - hash);
  }

  // Usamos el valor absoluto y el operador módulo para elegir un índice
  final index = hash.abs() % coloresDisponibles.length;
  return coloresDisponibles[index];

}
