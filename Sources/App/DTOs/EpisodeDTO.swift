import Vapor

// el DTO (DATA TRANSFER OBJECT) define lo que la API va a devolver en la respuesta http cuando un usuario hace una solicitud a tu servidor en Vapor.
// En este caso convierte datos del modelo "Episodes" a un formato de salida JSON en una API.
// Vapor convierte la struct List en un JSON por detras automaticamente, porque "List" conforma Content

extension Episodes {
    
    struct List: Content {
        
        let id: UUID
        let title: String
        let episodeNumber: Int
    }
    
    func toList() -> List {
        List(
            id: id!,
            title: title,
            episodeNumber: episodeNumber
        )
    }
    
    
    struct Public: Content {
        let id: UUID
        let title: String
        let episodeNumber: Int
        let airedAt: Date
        let summary: String
        let imageUrl: String?
        let protagonist: Hero.Public
    }
    
    func toPublic() -> Public {
        return Public(
            id: self.id!,
            title: self.title,
            episodeNumber: self.episodeNumber,
            airedAt: self.airedAt ?? Date(),
            summary: self.summary,
            imageUrl: self.imageUrl,
            protagonist: protagonist.toPublic()
        )
    }
}
