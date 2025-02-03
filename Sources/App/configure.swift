import NIOSSL
import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor
import JWT

// Configura la aplicación
public func configure(_ app: Application) async throws {
    // Descomentar la siguiente línea para servir archivos desde la carpeta /Public
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Verifica que la variable de entorno API_KEY esté configurada
    guard let jwtKey = Environment.process.JWT_KEY else {
        fatalError("JWT_KEY not found")
    }
    guard let _ = Environment.process.API_KEY else {
        fatalError("API_KEY environment variable not set")
    }

    // Configuración de la base de datos según el entorno
    switch app.environment {
    case .production:
        // Base de datos en producción (PostgreSQL)
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: "localhost", // Servidor de la base de datos
                    username: "vapor", // Usuario de la base de datos
                    password: "vapor", // Contraseña de la base de datos
                    database: "vapor", // Nombre de la base de datos
                    tls: .disable // Desactiva la conexión segura (TLS)
                )
            ),
            as: .psql
        )
        
    default:
        // Base de datos en desarrollo (SQLite)
        app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    }
    
    // Configura el sistema de hashing de contraseñas con bcrypt por defecto ya viene en .bcrypt.
    //app.password.use(.bcrypt)
    
    // Configure JWT
    let hmacKey = HMACKey(stringLiteral: jwtKey)
    await app.jwt.keys.add(hmac: hmacKey, digestAlgorithm: .sha512)

    // Se añaden las migraciones de la carpeta Migrations
    app.migrations.add(UserMigration())
    app.migrations.add(HeroMigration())
    app.migrations.add(EpisodeMigration())
    app.migrations.add(EpisodeHeroPivotMigration())
    app.migrations.add(PopulateInitialData())
    
    // Ejecuta automáticamente las migraciones al iniciar la aplicación
    try await app.autoMigrate()
    
    // Registra las rutas de la aplicación
    try routes(app)
}
