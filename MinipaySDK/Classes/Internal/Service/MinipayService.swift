protocol MinipayService {
    func addApp(request: AuthorizedAppAddRequest, callback: @escaping MinipaySDKAddAppResultCallback)
    func login(request: LoginRequest, callback: @escaping MinipaySDKLoginResultCallback)
    func postUsageEvent(request: AuthorizedAppPostUsageEventRequest, apiKey: String, callback: @escaping MinipaySDKPostUsageEventResultCallback)
}
