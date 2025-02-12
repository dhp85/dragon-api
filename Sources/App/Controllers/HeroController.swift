import Vapor
import Fluent


// para definir las rutas en el controlador hay que poner el protocolo RouteCollection.
//es lo mas importante de la aplicacion.
struct HeroController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("heroes") { builder in
            
            builder.get(use: getHeroes)
            builder.post(use: createHero)
            
            builder.get(":heroId", use: getHero)
            builder.delete(":heroId", use: deleteHero)
        }
    }
}

extension HeroController {
    
    @Sendable
    func getHeroes(_ req: Request) async throws -> Page<Hero.Public> {
        var heroesPage: Page<Hero>
        if let search = try? req.query.get(String.self, at: "search") {
            heroesPage = try await Hero
                .query(on: req.db)
                .filter(\.$name =~ search)
                .sort(\.$name)
                .paginate(for: req)
        } else {
            heroesPage = try await Hero
                .query(on: req.db)
                .sort(\.$name)
                .paginate(for: req)
        }
        let mappedHeroes = heroesPage.items.map { $0.toPublic() }
        return Page(items: mappedHeroes, metadata: heroesPage.metadata)
    }
    
    @Sendable
    func getHero(req: Request) async throws -> Hero.Public {
        guard let hero = try await Hero.find(req.parameters.get("heroId"), on: req.db) else {
            throw Abort(.notFound)
        }
        return hero.toPublic()
    }
    
    @Sendable
    func createHero(_ req: Request) async throws -> HTTPStatus {
        //se usa validate(content:req) para asegurarse de que los datos enviados en la peticion cumplen con las reglas
        // definidas en Hero.Create
        try Hero.Create.validate(content: req)
        // create es el objeto que me contruye de la request al DTO. es una decodificacion 
        let create = try req.content.decode(Hero.Create.self)
        //se convierte el DTO Hero.Create en un modelo de base de datos.
        let hero = create.toModel()
        // guarda  el heroe en la base de datos
        try await hero.create(on: req.db)
        
        req.logger.info("Hero \(create.name) created.")
        
        return HTTPResponseStatus.ok
    }
    
    @Sendable
    func deleteHero(_ req: Request) async throws -> HTTPStatus {
        guard let hero = try await Hero.find(req.parameters.get("heroId"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await hero.delete(on: req.db)
        
        return .ok
    }
    
}
