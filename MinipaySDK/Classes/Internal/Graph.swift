import Foundation

class Graph {
    
    struct Params {
        let apiKey: String
        let minipayService: MinipayService
        let stateRepo: MinipaySDKStateRepo
    }

    class Builder {
        
        enum BuilderError: Error {
            case missingApiKey
            case missingMinipayService
            case missingStateRepo
        }

        var apiKey: String?
        
        var minipayService: MinipayService?

        var stateRepo: MinipaySDKStateRepo?

        func apiKey(apiKey: String) -> Self {
            self.apiKey = apiKey
            return self
        }

        func minipayService(minipayService: MinipayService) -> Self {
            self.minipayService = minipayService
            return self
        }

        func stateRepo(stateRepo: MinipaySDKStateRepo) -> Self {
            self.stateRepo = stateRepo
            return self
        }

        func build() throws -> Graph {
            guard let apiKey = apiKey else {
                throw BuilderError.missingApiKey
            }

            guard let minipayService = minipayService else {
                throw BuilderError.missingMinipayService
            }

            guard let stateRepo = stateRepo else {
                throw BuilderError.missingStateRepo
            }

            let graph = Graph(
                params: Params(
                    apiKey: apiKey,
                    minipayService: minipayService,
                    stateRepo: stateRepo
                )
            )

            Graph.instance = graph
            
            return graph
        }
    }

    private let params: Params
    
    private init(params: Params) {
        self.params = params
    }

    lazy var apiKey: String = {
        params.apiKey
    }()

    lazy var minipayService: MinipayService = {
        params.minipayService
    }()

    lazy var stateRepo: MinipaySDKStateRepo = {
        params.stateRepo
    }()

    private(set) static var instance: Graph?
}
