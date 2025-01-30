import Vapor

/// Middleware para validar una clave API en las solicitudes entrantes.
/// Este middleware verifica que la solicitud incluya un encabezado "API-Key"
/// y que coincida con la clave API almacenada en las variables de entorno.
struct ApiKeyMiddleware: AsyncMiddleware {
    
    /// Intercepta las solicitudes y verifica la validez de la clave API.
    ///
    /// - Parameters:
    ///   - request: La solicitud HTTP entrante.
    ///   - next: El siguiente `AsyncResponder` en la cadena de procesamiento.
    /// - Returns: Una respuesta HTTP si la clave API es válida, o un error si no lo es.
    /// - Throws: `Abort` con un código de estado `400 Bad Request` si la clave API es incorrecta o falta.
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        // Obtiene la clave API esperada desde las variables de entorno.
        guard let environmentApiKey = Environment.process.API_KEY else {
            throw Abort(.badRequest, reason: "API_KEY no configurada en el entorno")
        }
        
        // Extrae la clave API del encabezado de la solicitud.
        guard let apiKey = request.headers.first(name: "API-Key") else {
            throw Abort(.badRequest, reason: "API-Key header is required")
        }
        
        // Verifica si la clave API proporcionada coincide con la esperada.
        guard apiKey == environmentApiKey else {
            throw Abort(.badRequest, reason: "Invalid API-Key")
        }
        
        // Si la clave API es válida, continúa con la cadena de middleware.
        return try await next.respond(to: request)
    }
}
