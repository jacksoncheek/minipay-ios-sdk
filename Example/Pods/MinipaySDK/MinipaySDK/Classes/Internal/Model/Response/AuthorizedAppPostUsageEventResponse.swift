struct AuthorizedAppPostUsageEventResponse: Codable {
    let userId: String
    let authorized: Bool
}

struct AuthorizedAppPostUsageEventResponseWrapper: Codable {
    let response: AuthorizedAppPostUsageEventResponse
}
