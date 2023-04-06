struct NetworkServiceImpl: NetworkService {
    private let session: URLSession

    private let environment: MinipaySDKEnvironment

    var baseURL: String {
        switch environment {
        case .production:
            return "https://api.minipayhq.com/api/v1/"
        case .test:
            return "https://staging.minipayhq.com/api/v1/"
        }
    }
    
    init(
        session: URLSession,
        environment: MinipaySDKEnvironment
    ) {
        self.session = session
        self.environment = environment
    }
    
    func request<T: Decodable>(
        path: String,
        body: Request,
        headers: [String: String],
        onSuccess: ((T) -> Void)?,
        onFailure: ((Error) -> Void)?
    ) -> URLSessionDataTask? {
        
        guard let url = URL(string: "\(baseURL)\(path)") else {
            onFailure?(NetworkError.invalidURL)
            return nil
        }

        guard let data = body.encode() else {
            onFailure?(NetworkError.encodingFailed)
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    onFailure?(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    onFailure?(NetworkError.invalidData)
                }
                return
            }
            
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: data) {
                DispatchQueue.main.async {
                    onSuccess?(decoded)
                }
            } else {
                DispatchQueue.main.async {
                    onFailure?(NetworkError.decodingFailed)
                }
            }
        })
        
        dataTask.resume()
        
        return dataTask
    }
}
