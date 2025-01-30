
import Vapor
import Fluent

// Esta struct es solo para meter datos en la base datos directamente para produccion y probar.
struct PopulateInitialData: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        
        // MARK: - Heroes
        let goku = Hero(name: "Goku")
        let chiChi = Hero(name: "Chi-Chi")
        let vegeta = Hero(name: "Vegeta")
        let bulma = Hero(name: "Bulma")
        let gohan = Hero(name: "Gohan")
        let piccolo = Hero(name: "Piccolo")
        let freezer = Hero(name: "Freezer")
        let krilin = Hero(name: "Krilin")
        let celula = Hero(name: "Celula")
        let yamcha = Hero(name: "Yamcha")
        let trunks = Hero(name: "Trunks")
        let raditz = Hero(name: "Raditz")
        let android16 = Hero(name: "Androide 16")
        let android17 = Hero(name: "Androide 17")
        let android18 = Hero(name: "Androide 18")
        let android19 = Hero(name: "Androide 19")
        let android20 = Hero(name: "Androide 20")
        
        await withThrowingTaskGroup(of: Void.self) { taskGroup in
            [goku, chiChi, vegeta, bulma, gohan, piccolo, freezer, krilin, celula, yamcha, trunks, raditz, android16, android17, android18, android19, android20].forEach { hero in
                taskGroup.addTask {
                    try await hero.create(on: database)
                }
            }
        }
    }
    
    func revert(on database: Database) async throws {
        try await Hero.query(on: database).delete()
    }
}
