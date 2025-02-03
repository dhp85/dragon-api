//
//  AdminMiddleware.swift
//  dragon-api
//
//  Created by Diego Herreros Parron on 3/2/25.
//

import Vapor

// Middleware para restringir el acceso solo a administradores
struct AdminMiddleware: AsyncMiddleware {
    
    // Maneja la solicitud y decide si continúa o se rechaza
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        
        // Obtiene el token JWT del usuario autenticado
        let token = try request.auth.require(JWTToken.self)
        
        // Verifica si el usuario existe en la base de datos y si es administrador
        guard let userId = UUID(token.userID.value),
              let user = try await User.find(userId, on: request.db),
              user.isAdmin else {
            throw Abort(.unauthorized) // Retorna un error 401 si no es administrador
        }
        
        // Si el usuario es administrador, permite que la solicitud continúe
        return try await next.respond(to: request)
    }
}
