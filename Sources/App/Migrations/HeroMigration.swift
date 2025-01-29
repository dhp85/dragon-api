import Vapor
import Fluent


// siempre crear la migracion AsincMigration para utilizar async/await.
struct HeroMigration: AsyncMigration {
    
    // este metodo es obligatorio, es el que va crear las tablas en la base de datos.
    func prepare(on database: Database) async throws {
        try await database
            .schema(Hero.schema)
            .id()
        // al poner en .required te obliga a crear el campo en este caso "name" si no pones .required no te obliga a ponerlo.
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Hero.schema).delete()
    }
}

