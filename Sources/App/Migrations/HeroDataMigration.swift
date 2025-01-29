
import Vapor
import Fluent


// siempre crear la migracion AsincMigration para utilizar async/await.
struct HeroDataMigration: AsyncMigration {
    
    // este metodo es obligatorio, es el que va crear las tablas en la base de datos.
    func prepare(on database: Database) async throws {
        // esto se crea para cuando estas desarrollando meter datos en la base de dato, una vez acabado el desarrollo, borrar.
        let goku = Hero(name: "Goku")
        let krilin = Hero(name: "Krilin")
        let Vegeta = Hero(name: "Vegeta")
        let gohan = Hero(name: "Gohan")
        
        await withThrowingTaskGroup(of: Void.self) { tasksGroup in
            [goku, krilin, Vegeta, gohan].forEach { hero in
                tasksGroup.addTask {
                    try await hero.create(on: database)
                }
            }
        }
    }
    
    func revert(on database: Database) async throws {
        try await Hero.query(on: database).delete()
    }
}
