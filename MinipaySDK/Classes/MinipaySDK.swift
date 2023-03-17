import Foundation

public typealias MinipaySDKAddAppResultCallback = (MinipaySDKResult<Bool>) -> Void

public typealias MinipaySDKLoginResultCallback = (MinipaySDKResult<String>) -> Void

public typealias MinipaySDKPostUsageEventResultCallback = (MinipaySDKResult<Bool>) -> Void

public protocol MinipaySDK {

    /** Begins the Minipay authorize app flow. No UI.
     *
     * @param customUserId the custom user identifier that you associate with your customer.
     * @param planId the plan identifier that this user is authorizing.
     * @param minipayToken the user's Minipay authentication token returned from the `login` flow.
     * @param callback invoked asynchronously after completion.
     */
    func authorizeApp(
        customUserId: String,
        planId: String,
        minipayToken: String,
        callback: @escaping MinipaySDKAddAppResultCallback
    )

    /** Begins the Minipay login flow.
     *
     * @param callback invoked asynchronously after completion.
     * @return UIVIewController to present the login flow.
     */
    func login(
        callback: @escaping MinipaySDKLoginResultCallback
    ) -> UIViewController

    /** Begins the Minipay post usage event flow. No UI.
     *
     * @param customUserId the custom user identifier that you associate with your customer.
     * @param planId the plan identifier that this user is authorizing.
     * @param callback invoked asynchronously after completion.
     */
    func postUsageEvent(
        customUserId: String,
        planId: String,
        callback: @escaping MinipaySDKPostUsageEventResultCallback
    )
}
