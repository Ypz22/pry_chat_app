import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_chat_app/utils/themes/general_theme.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/message.dart';

class ChatView extends ConsumerWidget {
  ChatView({super.key});

  final TextEditingController controller = TextEditingController();

  // IMPORTANTE: Para probar con un amigo, uno debe tener "Jefferson"
  // y el otro debe cambiar esta variable a su propio nombre.
  final String usuario = "Usuario Luis";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajesAsync = ref.watch(messageProvider);
    final service = ref.read(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Grupal'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) => ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: mensajes.length,
                itemBuilder: (_, i) {
                  final m = mensajes[i];
                  // Verificamos si el autor del mensaje soy yo
                  final esMio = m.author == usuario;

                  return Align(
                    alignment: esMio
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        // Color verde para mis mensajes, gris para los de mi amigo
                        color: esMio ? Colors.lightGreenAccent : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(esMio ? 12 : 0),
                          bottomRight: Radius.circular(esMio ? 0 : 12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: esMio
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            m.text,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error de conexión: $e')),
            ),
          ),

          // Barra inferior para escribir
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (controller.text.trim().isEmpty) return;

                      // Enviamos el mensaje real a Firebase
                      service.sendMessage(
                        Message(
                          text: controller.text.trim(),
                          author: usuario,
                          timestamp: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                      controller.clear();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(
        0xFFE5DDD5,
      ), // Color de fondo clásico de chat
    );
  }
}
