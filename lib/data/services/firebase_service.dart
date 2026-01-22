// lib/data/services/firebase_service.dart

import 'package:firebase_database/firebase_database.dart';
import '../../domain/models/message.dart';

class FirebaseService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('chat/general');

  void sendMessage(Message message) async {
    // 1. Envía tu mensaje original a Firebase
    await _ref.push().set(message.toJson());

    // 2. Lógica de interacción inteligente
    String respuestaBot = "";
    String textoUsuario = message.text.toLowerCase();

    // Definimos las respuestas según palabras clave
    if (textoUsuario.contains("hola")) {
      respuestaBot = "¡Hola! ¿En qué puedo ayudarte hoy?";
    } else if (textoUsuario.contains("clima")) {
      respuestaBot = "No tengo sensor de clima, pero en Quito suele estar nublado.";
    } else if (textoUsuario.contains("quien eres") || textoUsuario.contains("quién eres")) {
      respuestaBot = "Soy el chatbot de tu aplicación de Flutter.";
    } else if (textoUsuario.contains("hora")) {
      final hora = DateTime.now().toString().substring(11, 16);
      respuestaBot = "La hora actual es: $hora";
    } else {
      respuestaBot = "Leí tu mensaje: '${message.text}', pero aún estoy aprendiendo a responder a eso.";
    }

    // 3. Simular un pequeño retraso para que la respuesta no sea instantánea
    await Future.delayed(const Duration(seconds: 1));

    // 4. Crear el objeto de mensaje del Bot
    final botMessage = Message(
      text: respuestaBot,
      author: "Asistente Virtual",
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    // 5. Guardar la respuesta del bot en Firebase
    await _ref.push().set(botMessage.toJson());
  }

  // Tu método getMessage se mantiene igual para recibir los cambios en tiempo real
  Stream<List<Message>> getMessage() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      final messages = data.values.map((e) => Message.fromJson(e)).toList();
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }
}