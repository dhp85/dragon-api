
import Vapor

struct AuthController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        
        routes.group("auth") { builder in
            
            builder.post("register", use: register)
            
            // Agrupa las rutas protegidas por autenticación
            builder.group(User.authenticator(), User.guardMiddleware()) { loggedInUsers in
                // Define la ruta "login" para usuarios autenticados
                loggedInUsers.post("login", use: login)
            }
            builder.group(User.authenticator(), User.guardMiddleware()) { loggedInUsers in
                // Define la ruta "login" para usuarios autenticados
                loggedInUsers.post("refresh", use: refresh)
            }
            
        }
    }

}

extension AuthController {
    
    @Sendable
    func register(req: Request) async throws -> JWTToken.Public {
        
        // Validamos que el contenido de la solicitud cumple con los requisitos de User.Create.
        try User.Create.validate(content: req)
        
        // Decodificamos el contenido de la solicitud a la estructura User.Create.
        let create = try req.content.decode(User.Create.self)
        
        // Hasheamos la contraseña de manera asíncrona usando el servicio de hashing del request.
        let hashedPassword = try await req.password.async.hash(create.password)
        
        // Convertimos los datos recibidos en un modelo User, reemplazando la contraseña con su versión hasheada.
        let user = create.toModel(withHashedPassword: hashedPassword)
        
        // Guardamos el nuevo usuario en la base de datos de forma asíncrona.
        try await user.create(on: req.db)
        
        // Genera y retorna los tokens JWT para el usuario autenticado
        return try await generateTokens(for: user.email, andId: user.requireID(), witchRequest: req)
    }
    
    @Sendable
    // Función para manejar el inicio de sesión
    func login(req: Request) async throws -> JWTToken.Public {
        
        // Obtiene el usuario autenticado de la solicitud
        let user = try req.auth.require(User.self)
        
        // Genera y retorna los tokens JWT para el usuario autenticado
        return try await generateTokens(for: user.email, andId: user.requireID(), witchRequest: req)
    }
    
    @Sendable
    func refresh(req: Request) async throws -> JWTToken.Public {
        
        let token = try req.auth.require(JWTToken.self)
        
        guard token.isRefresh.value else {
            throw Abort(.methodNotAllowed, reason: "Token must be refresh type")
        }
        
        return try await generateTokens(for: token.username.value, andId: UUID(token.userID.value)!, witchRequest: req)
    }

    @Sendable
    // Función para generar tokens JWT para un usuario autenticado
    private func generateTokens(for username: String, andId userId: UUID, witchRequest req: Request) async throws -> JWTToken.Public {
        
        // Genera los tokens de acceso y de refresco para el usuario
        let tokens = JWTToken.generateToken(for: username, andId: userId)
        
        // Firma los tokens de manera asíncrona
        async let accessTokenSigned = req.jwt.sign(tokens.accessToken)
        async let refreshTokenSigned = req.jwt.sign(tokens.refreshToken)
        
        // Retorna los tokens firmados como respuesta
        return try await JWTToken.Public(acessToken: accessTokenSigned, refreshToken: refreshTokenSigned)
    }
}
