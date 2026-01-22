// lib/data/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../../domain/models/message.dart';

class FirebaseService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('chat/general');

  // Ahora solo envía el mensaje que tú escribes, no genera respuestas automáticas
  void sendMessage(Message message) {
    _ref.push().set(message.toJson());
  }

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