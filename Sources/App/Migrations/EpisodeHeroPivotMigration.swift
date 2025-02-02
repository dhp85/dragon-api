
import Vapor
import Fluent

struct EpisodeHeroPivotMigration: AsyncMigration {

    
    func prepare(on database: Database) async throws {
        try await database
            .schema(EpisodeHeroPivot.schema)
            .id()
            .field("episode_id", .uuid, .references(Episodes.schema, "id"))
            .field("hero_id", .uuid, .references(Hero.schema, "id"))
            .unique(on: "episode_id", "hero_id")
            .create()
        
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(EpisodeHeroPivot.schema).delete()
    }
}
