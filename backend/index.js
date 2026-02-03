const admin = require("firebase-admin");

// Configuración del Proyecto -> Cuentas de Servicio -> Generar nueva clave privada
let serviceAccount;
try {
    serviceAccount = require("./serviceaccountkey.json");
} catch (e) {
    console.error("ERROR CRÍTICO: No se encontró el archivo 'serviceaccountkey.json'");
    process.exit(1);
}

// Inicializar la app con permisos de administrador
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://pry-chat-app-default-rtdb.firebaseio.com"
});

const db = admin.database();
const messaging = admin.messaging();

console.log("✅ Backend Iniciado: Escuchando nuevos mensajes en /chat/general...");

// Referencia a los mensajes
const ref = db.ref("chat/general");

// limitToLast(1) evita que al iniciar el script se lean todo el histórico y se reenvíen notificaciones viejas
ref.limitToLast(1).on("child_added", (snapshot) => {
    const message = snapshot.val();

    const now = Date.now();
    const msgTime = message.timestamp || 0;

    // Si el mensaje es de hace más de 30 segundos, lo ignoramos (es viejo)
    if (now - msgTime > 30000) {
        return;
    }

    const author = message.author || "Alguien";
    const text = message.texto || message.text || "Nuevo mensaje";

    console.log(`--> Nuevo mensaje detectado de ${author}: ${text}`);

    // Sanitizar el nombre del autor para que coincida con el tópico del cliente
    // (Reemplaza todo lo que no sea alfanumérico por _)
    const safeAuthor = author.replace(/[^a-zA-Z0-9-_.~%]/g, '_');

    const payload = {
        notification: {
            title: `Mensaje de ${author}`,
            body: text,
        },
        condition: `'chat_general' in topics && !('ignore_${safeAuthor}' in topics)`
    };

    messaging.send(payload)
        .then((response) => {
            console.log("<-- Notificación enviada con éxito:", response);
        })
        .catch((error) => {
            console.error("Error enviando notificación:", error);
        });
});
