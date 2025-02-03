//
//  JWTToken.swift
//  dragon-api
//
//  Created by Diego Herreros Parron on 3/2/25.
//

import Vapor
import JWT


struct JWTToken: JWTPayload, Authenticatable {
    
    var userID: SubjectClaim
    var username: SubjectClaim
    var expiration: ExpirationClaim
    var isRefresh: BoolClaim
    
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try expiration.verifyNotExpired()
    }
    
}

extension JWTToken {
    
    static func generateToken(for username: String, andId userId: UUID) -> (accessToken: JWTToken, refreshToken: JWTToken) {
        
        let now = Date.now
        let tokenExpDate = now.addingTimeInterval(Constants.accessTokenLifetime)
        let refreshExpDate = now.addingTimeInterval(Constants.refreshTokenLifetime)
        
        
        let accessToken = JWTToken(
            userID: .init(value: userId.uuidString),
            username: .init(value: username),
            expiration: .init(value: tokenExpDate),
            isRefresh: false
        )
        
        let refreshToken = JWTToken(
            userID: .init(value: userId.uuidString),
            username: .init(value: username),
            expiration: .init(value: refreshExpDate),
            isRefresh: false
        )
        
        return (accessToken, refreshToken)
    }
}
