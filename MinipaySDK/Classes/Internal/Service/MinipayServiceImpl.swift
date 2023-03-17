struct MinipayServiceImpl: MinipayService {
    let networkService: NetworkService
    
    func addApp(request: AuthorizedAppAddRequest, callback: @escaping (MinipaySDKResult<Bool>) -> Void) {
        let onSuccess: ((AuthorizedAppAddResponseWrapper) -> ()) = { response in
            let _ = callback(.success(result: response.response.successful))
        }
        
        let onFailure: ((Error) -> ()) = { error in
            let _ = callback(.failure(error: error.localizedDescription))
        }

        let dataTask = networkService.request(
            path: "apps/add",
            body: request,
            headers: [:],
            onSuccess: onSuccess,
            onFailure: onFailure
        )
        dataTask?.resume()
    }
    
    func login(request: LoginRequest, callback: @escaping (MinipaySDKResult<String>) -> Void) {
        let onSuccess: ((LoginResponse) -> ()) = { response in
            let _ = callback(.success(result: response.token))
        }
        
        let onFailure: ((Error) -> ()) = { error in
            let _ = callback(.failure(error: error.localizedDescription))
        }

        let dataTask = networkService.request(
            path: "security/login",
            body: request,
            headers: [:],
            onSuccess: onSuccess,
            onFailure: onFailure
        )
        dataTask?.resume()
    }
    
    func postUsageEvent(request: AuthorizedAppPostUsageEventRequest, apiKey: String, callback: @escaping (MinipaySDKResult<Bool>) -> Void) {
        let onSuccess: ((AuthorizedAppPostUsageEventResponseWrapper) -> ()) = { response in
            let _ = callback(.success(result: response.response.authorized))
        }
        
        let onFailure: ((Error) -> ()) = { error in
            let _ = callback(.failure(error: error.localizedDescription))
        }

        let dataTask = networkService.request(
            path: "apps/usage",
            body: request,
            headers: ["X-API-Key": apiKey],
            onSuccess: onSuccess,
            onFailure: onFailure
        )
        dataTask?.resume()
    }
}
