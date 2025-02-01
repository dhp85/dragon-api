
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
       // en la base de datos con .reference garantiza integridad en la base de datos porque protagonist_id es una clave foranea que apunta a heroes.id, mas resumido, apunta a la tabla "heroes" a la linea de "id" en la base de datos. En el modelo protagonist_id tendria que estar marcado como @Parent.
            .field("protagonist_id", .uuid, .required, .references("heroes", "id"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Episodes.schema).delete()
    }
}
