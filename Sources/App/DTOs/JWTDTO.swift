
import Vapor

extension JWTToken {
    
    struct Public: Content {
        
        let acessToken: String
        let refreshToken: String
    }
}


