struct LoginRequest: Codable {
    let credentials: Credentials
}

extension LoginRequest: Request {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
