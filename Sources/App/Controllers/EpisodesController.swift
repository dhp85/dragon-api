import Vapor
import Fluent

struct EpisodesController: RouteCollection {
    
    func boot(routes router: RoutesBuilder) throws {
        router.group("episodes") { Builder in
            
            Builder.get(use:getEpisodes)
            Builder.get(":id", use: getEpisode)
        }
    }
}

extension EpisodesController {
    @Sendable
    func getEpisodes(_ req: Request) async throws -> [Episodes.List] {
        
        try await req.db.query(Episodes.self).all().map {$0.toList()}
        
    }
    
    @Sendable
    func getEpisode(_ req: Request) async throws -> Episodes.Public {
        guard let episode = try await Episodes.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        // cuando es un @Parent, para hacer referencia hay que poner $ y hacer la carga, si no nos dara fallo el servidor si se hace una request con el id del protagonista.
        try await episode.$protagonist.load(on: req.db)
        try await episode.$characters.load(on: req.db)
        
        return episode.toPublic()
    }
}
