import Foundation

public class MinipaySDKBuilder {

    enum BuilderError: Error {
        case missingApiKey
    }

    private var apiKey: String?
    
    public init() {}

    public func apiKey(apiKey: String) -> Self {
        self.apiKey = apiKey
        return self
    }

    /** Builds the MinipaySdkImpl. */
    public func build() throws -> MinipaySDK {
        
        guard let apiKey = apiKey else {
            throw BuilderError.missingApiKey
        }
        
        let params = MinipaySDKImpl.Params(
            apiKey: apiKey
        )

        return MinipaySDKImpl(
            params: params
        )
    }
}
