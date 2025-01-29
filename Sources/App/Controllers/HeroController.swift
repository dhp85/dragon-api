import Vapor


// para definir las rutas en el controlador hay que poner el protocolo RouteCollection.
//es lo mas importante de la aplicacion.
struct HeroController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("heroes") { builder in
            
            builder.get(use: getHeroes)
            builder.post(use: createHero)
        }
    }
}

extension HeroController {
    
    @Sendable
    func getHeroes(_ req: Request) async throws -> [Hero.Public] {
        // es una request a la base de datos coger todos los registros y mapearlos al modelo publico para devolverselo al usuario.
        try await Hero.query(on: req.db)
            .all()
            .map { $0.toPublic() }
    }
    
    @Sendable
    func createHero(_ req: Request) async throws -> HTTPStatus {
        // create es el objeto que me contruyo de la request al DTO
        let create = try req.content.decode(Hero.Create.self)
        //se convierte el DTO Hero.Create en un modelo de base de datos.
        let hero = create.toModel()
        // guarda  el heroe en la base de datos
        try await hero.create(on: req.db)
        
        return HTTPResponseStatus.ok
    }
}
