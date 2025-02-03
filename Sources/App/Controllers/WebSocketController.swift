//
//  WebSocketController.swift
//  dragon-api
//
//  Created by Diego Herreros Parron on 3/2/25.
//

import Vapor


struct WebSocketController: RouteCollection { // Define un controlador para manejar rutas.
    
    // La función 'boot' configura las rutas del servidor, específicamente las relacionadas con WebSockets.
    func boot(routes: any RoutesBuilder) throws {
        
        // Agrupa las rutas bajo la ruta base "chat"
        routes.group("chat") { routes in
            // Define una ruta WebSocket bajo "chat/bot". Este es el punto donde el cliente se conectará.
            routes.webSocket("bot") { req, ws in
                // Log para saber que un cliente se ha conectado al WebSocket.
                req.logger.info("WebSocket connected")
                // Cuando se reciba un mensaje de texto, ejecuta la función 'onText'.
                ws.onText(onText)
            }
        }
    }
}

// Aquí se extiende la funcionalidad de WebSocketController para definir qué hacer cuando se recibe un mensaje.
extension WebSocketController {
    
    // La función 'onText' maneja los mensajes de texto que recibe el WebSocket.
    // 'Sendable' asegura que la función sea segura para su uso en operaciones asincrónicas.
    @Sendable
    func onText(ws: WebSocket, text: String) async {
        // Envía una respuesta después de un retraso de 1 segundo, 10 veces.
        for i in 1...10 {
            try? await Task.sleep(for: .seconds(1)) // Pausa de 1 segundo entre cada mensaje.
            // Envía un mensaje de vuelta al cliente con un texto dinámico que incluye el mensaje recibido y el número de iteración.
            try? await ws.send("Gracias por tu mensaje -\(text)-. Esta es la respuesta \(i)")
        }
    }
}
