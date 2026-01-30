const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendChatNotification = functions.database
  .ref("/chat/general/{messageId}")
  .onCreate(async (snapshot, context) => {
    // Obtener los datos del mensaje recién creado
    const messageData = snapshot.val();

    if (!messageData) return null;

    const author = messageData.author || "Alguien";
    const text = messageData.texto || "Nuevo mensaje recibido";


    const payload = {
      notification: {
        title: `Mensaje de ${author}`,
        body: text,
      },
      // Opcional: datos adicionales para manejar en la app
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        author: author,
        text: text,
      },
      topic: "chat_general",
    };

    try {
      const response = await admin.messaging().send(payload);
      console.log("Notificación enviada con éxito:", response);
      return response;
    } catch (error) {
      console.error("Error enviando notificación:", error);
      return null;
    }
  });