// lib/data/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/models/message.dart';
import 'dart:developer';

class FirebaseService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('chat/general');
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Configuración inicial de Notificaciones
  Future<void> setupNotifications() async {
    // 1. Solicitar permisos (especialmente para iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('Usuario otorgó permiso para notificaciones');

      // 2. IMPORTANTE: Configurar opciones de presentación en primer plano
      // Esto hace que las notificaciones se muestren incluso si la app está abierta
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 3. Obtener el Token del dispositivo (útil para enviar notificaciones a usuarios específicos)
      String? token = await _fcm.getToken();
      log("FCM Token: $token");

      // 4. Suscribirse a un tema "general" para recibir notificaciones de grupo
      await _fcm.subscribeToTopic('chat_general');
    }
  }

  // Escuchar mensajes cuando la app está en primer plano
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Mensaje recibido en primer plano: ${message.notification?.title}');
    });
  }

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
