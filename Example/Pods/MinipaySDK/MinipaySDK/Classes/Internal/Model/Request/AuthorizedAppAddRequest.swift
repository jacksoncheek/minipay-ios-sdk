struct AuthorizedAppAddRequest: Codable {
    let customUserId: String
    let planId: String
    let minipayToken: String
}

extension AuthorizedAppAddRequest: Request {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
