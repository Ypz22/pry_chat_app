import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/message.dart';

class ChatView extends ConsumerWidget {
  ChatView({super.key});

  final TextEditingController controller = TextEditingController();
  final String usuario = "Usuario Jefferson";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajesAsync = ref.watch(messageProvider);
    final service = ref.read(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat en Tiempo Real'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Área de visualización de mensajes
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) => ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: mensajes.length,
                itemBuilder: (_, i) {
                  final m = mensajes[i];
                  // Determinamos si el mensaje es del usuario actual para el diseño
                  final esMio = m.author == usuario;

                  return Align(
                    alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: esMio ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: esMio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.author,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                          Text(m.text),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),

          // Barra de entrada de texto
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => _enviar(service),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () => _enviar(service),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _enviar(dynamic service) {
    if (controller.text.trim().isEmpty) return;

    service.sendMessage(
      Message(
        text: controller.text.trim(),
        author: usuario,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    controller.clear();
  }
}