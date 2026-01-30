const admin = require("firebase-admin");

// IMPORTANTE: Debes descargar el archivo de credenciales desde Firebase Console
// y guardarlo en esta carpeta 'backend' con el nombre 'serviceAreaKey.json'
// Guía: Configuración del Proyecto -> Cuentas de Servicio -> Generar nueva clave privada
// Si no existe, mostrará error.
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
    // La URL de tu base de datos (copiada de tu firebase_options.dart o consola)
    databaseURL: "https://pry-chat-app-default-rtdb.firebaseio.com"
});

const db = admin.database();
const messaging = admin.messaging();

console.log("✅ Backend Iniciado: Escuchando nuevos mensajes en /chat/general...");

// Referencia a los mensajes
const ref = db.ref("chat/general");

// Escuchar cuando se AGREGA un nuevo hijo
// limitToLast(1) evita que al iniciar el script se lean todo el histórico y se reenvíen notificaciones viejas
// Sin embargo, tiene un defecto: si reinicias el script, el último mensaje viejo podría volver a dispararse.
// Solución robusta: usar timestamp, pero para el deber esto suele bastar si inicias el script antes de chatear.
ref.limitToLast(1).on("child_added", (snapshot) => {
    const message = snapshot.val();

    // Evitar procesar mensajes muy antiguos si el script se reinicia
    // (Asumiendo que los mensajes tienen timestamp en milisegundos)
    const now = Date.now();
    const msgTime = message.timestamp || 0;

    // Si el mensaje es de hace más de 30 segundos, lo ignoramos (es viejo)
    if (now - msgTime > 30000) {
        return;
    }

    const author = message.author || "Alguien";
    const text = message.text || "Nuevo mensaje"; // Nota: en Flutter usas 'text', en DB verifica si es 'text' o 'texto'

    console.log(`📩 Nuevo mensaje detectado de ${author}: ${text}`);

    const payload = {
        notification: {
            title: `Mensaje de ${author}`,
            body: text,
        },
        topic: "chat_general"
    };

    messaging.send(payload)
        .then((response) => {
            console.log("🚀 Notificación enviada con éxito:", response);
        })
        .catch((error) => {
            console.error("❌ Error enviando notificación:", error);
        });
});
