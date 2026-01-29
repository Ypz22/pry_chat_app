const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Escucha nuevos mensajes en la Realtime Database y envía una notificación push.
 */
exports.sendChatNotification = functions.database
    .ref("/chat/general/{messageId}")
    .onCreate(async (snapshot, context) => {
      // Obtener los datos del mensaje recién creado
      const messageData = snapshot.val();
      
      if (!messageData) return null;

      const author = messageData.author || "Alguien";
      const text = messageData.texto || "Nuevo mensaje recibido";

      // Definir la carga útil de la notificación
      const payload = {
        notification: {
          title: `Mensaje de ${author}`,
          body: text,
          clickAction: "FLUTTER_NOTIFICATION_CLICK", // Necesario para abrir la app al tocar
        },
        topic: "chat_general", // El tema al que se suscriben en Flutter
      };

      try {
        // Enviar la notificación vía FCM
        const response = await admin.messaging().send(payload);
        console.log("Notificación enviada con éxito:", response);
        return response;
      } catch (error) {
        console.error("Error enviando notificación:", error);
        return null;
      }
    });