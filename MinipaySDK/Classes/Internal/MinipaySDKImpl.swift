import Foundation

class MinipaySDKImpl: MinipaySDK {

    struct Params {
        let apiKey: String
        let environment: MinipaySDKEnvironment
    }

    private let params: Params
    
    init(params: Params) {
        self.params = params
        
        do {
            let networkService = NetworkServiceImpl(
                session: URLSession.shared,
                environment: params.environment
            )
            
            let minipayService = MinipayServiceImpl(networkService: networkService)
            
            let stateRepo = MinipaySDKStateRepo()
            
            try _ = Graph.Builder()
                .apiKey(apiKey: params.apiKey)
                .minipayService(minipayService: minipayService)
                .stateRepo(stateRepo: stateRepo)
                .build()
        } catch {
            fatalError("\(error)")
        }
    }

    func authorizeApp(
        customUserId: String,
        planId: String,
        minipayToken: String,
        callback: @escaping (MinipaySDKResult<Bool>) -> Void
    ) {
        Graph.instance!.stateRepo.addAppResultCallback = callback

        let request = AuthorizedAppAddRequest(
            customUserId: customUserId,
            planId: planId,
            minipayToken: minipayToken
        )

        Graph.instance!.minipayService.addApp(request: request, callback: { result in
            switch result {
            case .success(let successful):
                callback(.success(result: successful))
            case .failure(_):
                callback(.failure(error: "App authorization failed"))
            }
        })
    }
    
    func login(
        callback: @escaping (MinipaySDKResult<String>) -> Void
    ) -> UIViewController {
        Graph.instance!.stateRepo.loginResultCallback = callback

        return LoginViewController()
    }
    
    func postUsageEvent(
        customUserId: String,
        planId: String,
        callback: @escaping  (MinipaySDKResult<Bool>) -> Void
    ) {
        Graph.instance!.stateRepo.postUsageEventResultCallback = callback
        
        let request = AuthorizedAppPostUsageEventRequest(
            customUserId: customUserId,
            planId: planId
        )

        Graph.instance!.minipayService.postUsageEvent(request: request, apiKey: params.apiKey, callback: { result in
            switch result {
            case .success(let authorized):
                callback(.success(result: authorized))
            case .failure(_):
                callback(.failure(error: "Post usage event failed"))
            }
        })
    }
}
