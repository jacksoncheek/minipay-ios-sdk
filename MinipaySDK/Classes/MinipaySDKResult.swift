import Foundation

/**
 * Monad for an expected/unexpected result from the Minipay SDK.
 */
public enum MinipaySDKResult<T> {
    
    case success(result: T)
    
    case failure(error: String)
}
