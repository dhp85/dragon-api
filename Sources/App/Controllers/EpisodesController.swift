import Vapor
import Fluent

struct EpisodesController: RouteCollection {
    
    func boot(routes router: RoutesBuilder) throws {
        router.group("episodes") { Builder in
            
            Builder.get(use:getEpisodes)
        }
    }
}

extension EpisodesController {
    @Sendable
    func getEpisodes(_ req: Request) async throws -> [Episodes.Public] {
        
        try await req.db.query(Episodes.self).all().map {$0.toPublic()}
        
    }
}
