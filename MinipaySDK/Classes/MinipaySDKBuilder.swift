import Foundation

public class MinipaySDKBuilder {

    enum BuilderError: Error {
        case missingApiKey
        case missingEnvironment
    }

    private var apiKey: String?

    private var environment: MinipaySDKEnvironment?

    public init() {}

    public func apiKey(apiKey: String) -> Self {
        self.apiKey = apiKey
        return self
    }

    public func environment(mode: MinipaySDKEnvironment) -> Self {
        self.environment = mode
        return self
    }

    /** Builds the MinipaySdkImpl. */
    public func build() throws -> MinipaySDK {
        
        guard let apiKey = apiKey else {
            throw BuilderError.missingApiKey
        }

        guard let environment = environment else {
            throw BuilderError.missingEnvironment
        }

        let params = MinipaySDKImpl.Params(
            apiKey: apiKey,
            environment: environment
        )

        return MinipaySDKImpl(
            params: params
        )
    }
}
