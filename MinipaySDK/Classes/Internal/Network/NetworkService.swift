protocol NetworkService {
    var baseURL: String { get }
    
    @discardableResult func request<T: Decodable>(
        path: String,
        body: Request,
        headers: [String: String],
        onSuccess: ((T) -> Void)?,
        onFailure: ((Error) -> Void)?
    ) -> URLSessionDataTask?
}
