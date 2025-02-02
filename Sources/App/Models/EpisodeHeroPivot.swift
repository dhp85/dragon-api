

import Vapor
import Fluent

// Definición de una clase final llamada EpisodeHeroPivot que hereda de Model y es marcada como @unchecked Sendable.
// Esto indica que la clase no puede ser heredada y que su seguridad en concurrencia no es verificada por el compilador.
final class EpisodeHeroPivot: Model, @unchecked Sendable {
    
    // Definición del nombre de la tabla en la base de datos.
    static let schema = "episode_hero_pivot"
    
    // Identificador único para cada registro de la tabla, definido como una clave primaria.
    @ID(key: .id)
    var id: UUID?
    
    // Relación con la entidad Hero mediante una clave foránea "hero_id".
    @Parent(key: "hero_id")
    var hero: Hero
    
    // Relación con la entidad Episodes mediante una clave foránea "episode_id".
    @Parent(key: "episode_id")
    var episode: Episodes
    
    // Constructor vacío requerido por Fluent para la inicialización automática.
    init() {}
    
    // Constructor que permite inicializar una instancia con valores específicos.
    init(id: UUID? = nil, heroID: Hero.IDValue, episodeID: Episodes.IDValue) {
        // Asigna los valores de los identificadores de hero y episode.
        $hero.id = heroID
        $episode.id = episodeID
    }
}
