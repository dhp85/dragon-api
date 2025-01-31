import Vapor


extension Episodes {
    struct Public: Content {
        let id: UUID
        let title: String
        let episodeNumber: Int
        let airedAt: Date
        let summary: String
        let imageUrl: String?
    }
    
    func toPublic() -> Public {
        return Public(
            id: self.id!,
            title: self.title,
            episodeNumber: self.episodeNumber,
            airedAt: self.airedAt ?? Date(),
            summary: self.summary,
            imageUrl: self.imageUrl
        )
    }
}
