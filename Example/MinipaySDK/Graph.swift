import Foundation
import MinipaySDK

class Graph {
    
    struct Params {
        let minipaySDK: MinipaySDK
    }

    class Builder {
        
        enum BuilderError: Error {
            case missingMinipaySDK
        }
        
        var minipaySDK: MinipaySDK?

        func minipaySDK(minipaySDK: MinipaySDK) -> Self {
            self.minipaySDK = minipaySDK
            return self
        }

        func build() throws -> Graph {
            guard let minipaySDK = minipaySDK else {
                throw BuilderError.missingMinipaySDK
            }

            let graph = Graph(
                params: Params(
                    minipaySDK: minipaySDK
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

    lazy var minipaySDK: MinipaySDK = {
        params.minipaySDK
    }()

    private(set) static var instance: Graph?
}
