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
    
   /* @Field(key: "characters")
    var characters: [Hero]*/
    
    @Parent(key: "protagonist_id") // Relacion con la clase Hero.
    var protagonist: Hero
    
    @Timestamp(key: "aired_at", on: .none)
    var airedAt: Date?
    
    @Timestamp(key: "create_at", on: .create) // marca la fecha de creacion.
    var createAt: Date?
    
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
