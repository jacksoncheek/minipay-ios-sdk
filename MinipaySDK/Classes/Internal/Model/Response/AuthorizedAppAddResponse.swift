struct AuthorizedAppAddResponse: Codable {
    let successful: Bool
}

struct AuthorizedAppAddResponseWrapper: Codable {
    let response: AuthorizedAppAddResponse
}
