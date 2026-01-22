import 'package:firebase_database/firebase_database.dart';
import '../../domain/models/message.dart';
import '../knowledgeBase_data.dart';

class FirebaseService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('chat/general');

  void sendMessage(Message message) async {
    await _ref.push().set(message.toJson());

    String respuestaTexto = KnowledgeBase.getResponse(message.text);

    await Future.delayed(const Duration(milliseconds: 800));

    final botMessage = Message(
      text: respuestaTexto,
      author: "Bot Asistente",
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await _ref.push().set(botMessage.toJson());
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