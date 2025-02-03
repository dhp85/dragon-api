//
//  Untitled.swift
//  dragon-api
//
//  Created by Diego Herreros Parron on 3/2/25.
//

import Foundation

// Definición de constantes utilizadas en la aplicación
struct Constants {
    
    // Tiempo de vida del token de acceso (en segundos): 24 horas
    static let accessTokenLifetime: Double = 60 * 60 * 24
    
    // Tiempo de vida del token de refresco (en segundos): 1 mes (4 semanas)
    static let refreshTokenLifetime: Double = 60 * 60 * 24 * 7 * 4
}
