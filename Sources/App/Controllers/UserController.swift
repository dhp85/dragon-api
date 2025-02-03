import Vapor

// Controlador para gestionar las rutas relacionadas con los usuarios
struct UserController: RouteCollection {
    
    // Método obligatorio para registrar las rutas
    func boot(routes: any RoutesBuilder) throws {
        
        // Grupo de rutas bajo el prefijo "users"
        routes.group("users") { users in
            
            // Ruta para obtener la información del usuario autenticado
            users.get("me", use: getMe)
            
            // Ruta protegida con middleware para administradores
            users.grouped(AdminMiddleware()).get(use: index)
        }
    }
}

extension UserController {
    
    @Sendable
    // Obtiene la información del usuario autenticado
    func getMe(req: Request) async throws -> User.Public {
        // Obtiene el token JWT del usuario autenticado
        let token = try req.auth.require(JWTToken.self)
        
        // Registra el ID del usuario en los logs
        req.logger.info("User ID: \(token.userID.value)")
        
        // Intenta convertir el userID del token en UUID y buscar el usuario en la base de datos
        guard let userId = UUID(token.userID.value),
              let myUser = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound) // Retorna un error 404 si el usuario no existe
        }
        
        // Retorna la versión pública del usuario
        return myUser.toPublic()
    }
    
    @Sendable
    // Obtiene la lista de todos los usuarios en formato público
    func index(req: Request) async throws -> [User.Public] {
        try await User.query(on: req.db).all().map { $0.toPublic() }
    }
}
