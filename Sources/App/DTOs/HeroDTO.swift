import Vapor

// el DTO (DATA TRANSFER OBJECT) define lo que la API va a devolver en la respuesta http cuando un usuario hace una solicitud a tu servidor en Vapor.
// En este caso convierte datos del modelo "Hero" a un formato de salida JSON en una API.
// Vapor convierte la struct List en un JSON por detras automaticamente, porque "List" conforma Content

extension Hero {
    // es lo que da el frontEnd al backend.
    struct Create: Content {
        
        let name: String
        
        func toModel()->Hero {
            Hero(name: name)
        }
    }
    
    // esto es lo que devuelve el backend al frontend
    struct Public: Content {
        let id: UUID
        let name: String
    }
    func toPublic() -> Public {
        Public(id: self.id!, name: self.name)
    }
}

extension Hero.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(2...50), required: true)
    }
}
