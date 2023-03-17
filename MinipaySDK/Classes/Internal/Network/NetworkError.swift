enum NetworkError: LocalizedError {
    case invalidURL
    case invalidData
    case decodingFailed
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL"
        case .invalidData: return "Invalid response data"
        case .decodingFailed: return "Failed to decode response data"
        case .encodingFailed: return "Failed to encode request body"
        }
    }
}
