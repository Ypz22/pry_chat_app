import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pry_chat_app/utils/themes/schema_color.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/message.dart';

class ChatView extends ConsumerWidget {
  ChatView({super.key});

  final TextEditingController controller = TextEditingController();

  // IMPORTANTE: Cambiar el nombre según el usuario
  final String usuario = "Luis Sagnay";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajesAsync = ref.watch(messageProvider);
    final service = ref.read(firebaseServiceProvider);

    service.registerMyUserTopic(usuario);

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
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) {
                final reversedMessages = mensajes.reversed.toList();

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: reversedMessages.length,
                  itemBuilder: (_, i) {
                    final m = reversedMessages[i];
                    final esMio = m.author == usuario;

                    return Align(
                      alignment: esMio
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
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
                                    color: obtenerColorUsuario(m.author),
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                m.text,
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
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

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: SchemaColor.backgroundColor,
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
                        fillColor: const Color(0xFF2C2C2C),
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
                      backgroundColor: SchemaColor.accentColor,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: SchemaColor.backgroundColor,
    );
  }
}
