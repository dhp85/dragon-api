import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    // es un grupo, donde lo mete dentro de la ruta api.
    //Resumiendo esto es la ruta donde formalizar una request. Por ejemplo: "https: // https://gateway.marvel.com/api
    // la web o url es https://gateway.marvel.com/ y el grupo es api.
    try app.group("api") { builder in
        
        try builder.register(collection: AuthController())
        
        try builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
            try builder.register(collection: UserController())
            try builder.register(collection: HeroController())
            try builder.register(collection: EpisodesController())
            try builder.register(collection: WebSocketController())
            
            
        }
    }
}
