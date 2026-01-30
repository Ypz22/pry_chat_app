import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_chat_app/utils/themes/schema_color.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/message.dart';

class ChatView extends ConsumerWidget {
  ChatView({super.key});

  final TextEditingController controller = TextEditingController();

  // IMPORTANTE: Para probar con un amigo, uno debe tener "Jefferson"
  // y el otro debe cambiar esta variable a su propio nombre.
  final String usuario = "Usuario Jefferson";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajesAsync = ref.watch(messageProvider);
    final service = ref.read(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Grupal'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: SchemaColor.accentColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Lista de mensajes, usando Expanded para ocupar el espacio
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) {
                // Invertimos la lista para mostrar primero (abajo) el más reciente
                final reversedMessages = mensajes.reversed.toList();

                return ListView.builder(
                  reverse: true, // Esto hace que la lista inicie desde abajo
                  padding: const EdgeInsets.all(12),
                  itemCount: reversedMessages.length,
                  itemBuilder: (_, i) {
                    final m = reversedMessages[i];
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
                          color: esMio
                              ? SchemaColor.primaryColor
                              : SchemaColor.secondaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(esMio ? 16 : 4),
                            bottomRight: Radius.circular(esMio ? 4 : 16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: esMio
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!esMio) ...[
                              Text(
                                m.author,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                            Text(
                              m.text,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors
                                    .white, // Texto blanco para contraste con fondo oscuro
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // Barra inferior oscura
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Gris muy oscuro
              border: Border(top: BorderSide(color: Colors.grey[800]!)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        fillColor: const Color(
                          0xFF2C2C2C,
                        ), // Input background gris oscuro
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
                      service.sendMessage(
                        Message(
                          text: controller.text.trim(),
                          author: usuario,
                          timestamp: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                      controller.clear();
                    },
                    child: CircleAvatar(
                      backgroundColor: SchemaColor.primaryColor,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black, // Fondo negro global
    );
  }
}
