import Vapor
import Fluent


final class Episodes: Model, @unchecked Sendable {
    static let schema = "episodes"
    
    @ID(key: .id) // @ID define la clave primaria.
    var id: UUID?
    
    @Field(key: "title") // Mapea la columna "title" en la BD.
    var title: String
    
    @Field(key: "summary")
    var summary: String
    
    @Field(key: "episode_number")// en la base de datos nunca se ponen mayusculas se utiliza la convencion snake_case.
    var episodeNumber: Int
    
    @Parent(key: "protagonist_id") // Relacion con la clase Hero.
    var protagonist: Hero
    
    @Timestamp(key: "aired_at", on: .none)
    var airedAt: Date?
    
    @Timestamp(key: "create_at", on: .create) // marca la fecha de creacion.
    var createAt: Date?
/*Explicación:
    •    @Siblings: Define una relación de muchos a muchos entre dos modelos en Fluent.
    •    through: EpisodeHeroPivot.self: Especifica que la relación se gestiona a través de la tabla intermedia EpisodeHeroPivot.
    •    from: \.$episode: Indica que este modelo (probablemente Episodes) se relaciona con EpisodeHeroPivot a través de la propiedad episode.
    •    to: \.$hero: Indica que el otro modelo en la relación es Hero, enlazado mediante la propiedad hero en EpisodeHeroPivot.
    •    var characters: [Hero]: Define una colección de objetos Hero asociados con la entidad actual (presumiblemente un Episode).

¿Qué hace esta línea?

Esta propiedad establece que un Episode puede tener múltiples Hero, y esa relación se maneja a través de la tabla pivote EpisodeHeroPivot. Así, cuando se acceda a characters, Fluent cargará todos los Hero asociados a ese episodio.*/
    @Siblings(through: EpisodeHeroPivot.self, from: \.$episode, to: \.$hero)
    var characters: [Hero]
    
    @OptionalField(key: "image_url") // campo opcional, en la migracion asegurarse de que no sea .required al ser opcional.
    var imageUrl: String?
    
    init() {}
    
    init(episodeNumber: Int, title: String, airedAt: Date? = nil, summary: String, imageUrl: String? = nil, protagonistID: Hero.IDValue) {
        self.episodeNumber = episodeNumber
        self.title = title
        self.airedAt = airedAt
        self.summary = summary
        self.imageUrl = imageUrl
        self.$protagonist.id = protagonistID
    }
}
