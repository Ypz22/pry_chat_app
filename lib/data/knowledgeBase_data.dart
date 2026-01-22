class KnowledgeBase {
  static const Map<String, String> responses = {
    "hola": "¡Hola, Jefferson! ¿Cómo va el desarrollo hoy?",
    "buenos dias": "¡Buen día! Espero que tengas una excelente jornada de programación.",
    "buenas tardes": "¡Buenas tardes! ¿En qué puedo apoyarte con el chat?",

    "flutter": "Flutter es el framework de Google para crear apps nativas preciosas desde un solo código base.",
    "dart": "Dart es el lenguaje detrás de Flutter, optimizado para interfaces de usuario rápidas.",
    "firebase": "Firebase Realtime Database es genial porque sincroniza datos entre dispositivos en milisegundos.",
    "riverpod": "Riverpod es un motor de reactividad que estamos usando para manejar el estado de este chat.",

    "quien eres": "Soy tu asistente virtual de pruebas, diseñado para interactuar en este chat.",
    "que haces": "Analizo tus mensajes y busco coincidencias en mi base de datos para responderte.",
    "ayuda": "Puedes preguntarme sobre Flutter, Firebase, o simplemente decir 'hola'.",

    "quito": "Quito es una ciudad hermosa, aunque el clima siempre es una sorpresa.",
    "ecuador": "¡La mitad del mundo! Un gran lugar para desarrollar software.",

    "adios": "¡Hasta luego! Estaré aquí si necesitas probar más mensajes.",
    "chao": "¡Nos vemos! No olvides hacer commit de tus cambios.",
    "gracias": "¡De nada! Es un placer ayudarte con las pruebas.",
  };

  static String getResponse(String message) {
    String lowerMessage = message.toLowerCase();

    for (var entry in responses.entries) {
      if (lowerMessage.contains(entry.key)) {
        return entry.value;
      }
    }
    return "Interesante... cuéntame más sobre eso.";
  }
}