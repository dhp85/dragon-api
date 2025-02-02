
import Vapor


// Extensión de la clase `User` para definir estructuras auxiliares y métodos relacionados.
extension User {
    
    // Estructura `Create` utilizada para la creación de un nuevo usuario.
    struct Create: Content {
        let email: String  // Dirección de correo electrónico del usuario
        let name: String   // Nombre del usuario
        let password: String  // Contraseña del usuario
        
        // Método que convierte un `Create` en un objeto `User`
        func toPublic() -> User {
            User(username: name, email: email, password: password)
        }
    }
    
    // Estructura `Public` que define qué datos se pueden exponer públicamente.
    struct Public: Content {
        let id: UUID  // Identificador único del usuario
        let email: String  // Dirección de correo electrónico del usuario
        let name: String   // Nombre del usuario
    }
    
    // Método que convierte un `User` en su versión pública para ocultar datos sensibles.
    func toPublic() -> Public {
        Public(id: id!, email: email, name: username)
    }
}

// Extensión para agregar validaciones a la estructura `User.Create`
extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        // Valida que el nombre tenga entre 2 y 50 caracteres.
        validations.add("name", as: String.self, is: .count(2...50), required: true)
        
        // Valida que el email tenga formato válido.
        validations.add("email", as: String.self, is: .email, required: true)
        
        // Valida que la contraseña tenga entre 6 y 24 caracteres y sea alfanumérica.
        validations.add("password", as: String.self, is: .count(6...24) && .alphanumeric, required: true)
    }
}

/*Explicación:
    •    Se crean dos estructuras auxiliares dentro de User:
    •    Create: Para manejar la creación de usuarios y conversión a un objeto User.
    •    Public: Para representar una versión segura de User, ocultando la contraseña.
    •    Se implementa un método toPublic() que convierte un User en Public.
    •    Se extiende User.Create para aplicar validaciones:
    •    name: Entre 2 y 50 caracteres.
    •    email: Debe ser un correo válido.
    •    password: Entre 6 y 24 caracteres y solo caracteres alfanuméricos.*/
