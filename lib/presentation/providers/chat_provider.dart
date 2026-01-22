import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/firebase_service.dart';
import '../../domain/models/message.dart';

//llamamos al servicio de firebase
//INstancia de firebase service
final firebaseServiceProvider = Provider<FirebaseService>((ref)=> FirebaseService()); //permite acceder 
//a firebase desde cualquier parte de la app

// final messageProvider = StreamProvider<List<Message>>((ref){
//   //Accedemos al servicio de firebase
//   final service = ref.read(firebaseServiceProvider);
//
//   return service.messageRef.onValue.map((event){
//     final data = event.snapshot.value as Map<dynamic, dynamic>?; //El signo de interrogacion
//     //es para evitar errores si no hay datos
//
//     //Si no hay datos, devolvemos una lista vacia
//     if(data == null) return [];
//
//     //Si hay datos, los convertimos a una lista de mensajes
//     return data.values
//        .map((e)=> Message.fromJson(e))
//        .toList()
//        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
//        //..sort ordena los mensajes por timestamp
//   });
//
// });

final messageProvider = StreamProvider<List<Message>>((ref){
  final service = ref.read(firebaseServiceProvider);
  return service.getMessage();
});