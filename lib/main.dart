import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'utils/themes/general_theme.dart';
import 'presentation/views/chat_view.dart';
import 'data/services/firebase_service.dart';

// Función obligatoria para manejar notificaciones cuando la app está cerrada o en segundo plano
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Notificación en segundo plano recibida: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initializationError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configurar el manejador de segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Inicializar servicios de FCM
    final firebaseService = FirebaseService();
    await firebaseService.setupNotifications();
    firebaseService.listenForegroundMessages();
  } catch (e, s) {
    print("Error initializing Firebase: $e");
    initializationError = "Error: $e\nStack: $s";
  }

  runApp(ProviderScope(child: MyApp(initializationError: initializationError)));
}

class MyApp extends StatelessWidget {
  final String? initializationError;
  const MyApp({super.key, this.initializationError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GeneralTheme.lightTheme,
      home: ChatView(),
    );
  }
}
