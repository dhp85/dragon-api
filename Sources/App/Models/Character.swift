import Fluent
import Vapor

/*¿Qué es Sendable?

Sendable es un protocolo en Swift que asegura que una instancia de una clase, estructura o tipo de datos pueda ser enviada de forma segura entre diferentes hilos o tareas asincrónicas (por ejemplo, cuando usas async/await). Esto ayuda a prevenir condiciones de carrera y errores en la concurrencia, porque Swift verifica si el tipo que estás utilizando es seguro de enviar entre hilos.

Cuando una clase o estructura es marcada como Sendable, significa que sus datos pueden ser copiados o referenciados en un hilo distinto de forma segura.

¿Por qué Hero se conforma al protocolo Sendable?

En el caso de tu modelo Hero, marcarlo como Sendable podría ser necesario si quieres garantizar que puedas usar objetos de Hero en un contexto concurrente sin problemas, por ejemplo, si estás trabajando con tareas asíncronas (async/await) o ejecutando código en diferentes hilos de ejecución.*/

/*¿Qué significa @unchecked Sendable?

Cuando marcas un tipo con @unchecked Sendable, estás eludiendo la comprobación de seguridad que el compilador realiza de forma predeterminada para asegurar que el tipo sea seguro en un contexto concurrente.*/


final class Hero: Model, @unchecked Sendable {
    
    static let schema = "heroes" // es como se va ha llamar la tabla de la base de datos.
    
    // siempre te pide el modelo un id.
    @ID(key: .id)
    var id: UUID?
    
    // creamos un campo llamado name
    @Field(key: "name")
    var name: String
    
    @Siblings(through: EpisodeHeroPivot.self, from: \.$hero, to: \.$episode)
    var episodes: [Episodes]
    // se crea un inicializador vacio por si el usuario utiliza un post y crea un modelo nuevo.
    init() {}
    
    init(name: String) {
        self.name = name
    }
}

