
import Vapor
import Fluent


struct EpisodeMigration: AsyncMigration {
   func prepare(on database: Database) async throws {
        try await database
            .schema(Episodes.schema)
            .id()
            .field("title", .string, .required)
            .field("summary", .string, .required)
            .field("episode_number", .int, .required)
            .field("aired_at", .date, .required)
            .field("create_at", .date)
            .field("image_url", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Episodes.schema).delete()
    }
}
