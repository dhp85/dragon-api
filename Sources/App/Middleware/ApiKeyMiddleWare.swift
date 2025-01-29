import Vapor

struct ApiKeyMiddleWare: AsyncMiddleware {
    
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        guard let apiKey = request.headers.first(name: "API-Key"),
              apiKey == "my api key" else {
            throw Abort(.badRequest, reason: "API-Key header is required")
        }
        return try await next.respond(to: request)
    }
    
    
}
