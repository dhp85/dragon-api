import Vapor


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
