import Vapor
import Fluent


final class Episodes: Model, @unchecked Sendable {
    static let schema = "episodes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "summary")
    var summary: String
    
    @Field(key: "episode_number")// en la base de datos nunca se ponen mayusculas se utiliza la convencion snake_case.
    var episodeNumber: Int
    
   /* @Field(key: "characters")
    var characters: [Hero]
    
    @Field(key: "protagonist")
    var protagonist: Hero*/
    
    @Timestamp(key: "aired_at", on: .none)
    var airedAt: Date?
    
    @Timestamp(key: "create_at", on: .create)
    var createAt: Date?
    
    @OptionalField(key: "image_url")
    var imageUrl: String?
    
    init() {}
    
    init(episodeNumber: Int, title: String, airedAt: Date? = nil, summary: String, imageUrl: String? = nil) {
        self.episodeNumber = episodeNumber
        self.title = title
        self.airedAt = airedAt
        self.summary = summary
        self.imageUrl = imageUrl
    }
}
