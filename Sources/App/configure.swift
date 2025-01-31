import NIOSSL
import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    guard let _ = Environment.process.API_KEY else {
        fatalError("API_KEY environment variable not set")
    }

    switch app.environment {
    case.production:
        // producction DB
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: "localhost",
                    username: "vapor",
                    password: "vapor",
                    database: "vapor",
                    tls: .disable
                )
            ),
            as: .psql
        )
        break
    default:
        app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    }
    
    

    // se añaden las migraciones de la carpeta Migrations.
    app.migrations.add(HeroMigration())
    app.migrations.add(EpisodeMigration())
    app.migrations.add(PopulateInitialData())
    
    try await app.autoMigrate()
    // register routes
    try routes(app)
}
