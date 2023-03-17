struct AuthorizedAppPostUsageEventRequest: Codable {
    let customUserId: String
    let planId: String
}

extension AuthorizedAppPostUsageEventRequest: Request {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
