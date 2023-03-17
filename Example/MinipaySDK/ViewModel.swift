import MinipaySDK

class ViewModel {
    
    let minipaySDK: MinipaySDK
    
    var minipayToken: String = ""

    var authorizeAppResult: String = ""

    var postUsageEventResult: String = ""

    var error: String = ""
    
    var isAuthorizeAppFlowEnabled: Bool {
        return minipayToken.isEmpty == false
    }

    var isPostUsageEventFlowEnabled: Bool {
        return minipayToken.isEmpty == false
    }
    
    init(minipaySDK: MinipaySDK) {
        self.minipaySDK = minipaySDK
    }

    func startLoginFlow(completion: @escaping () -> Void) -> UIViewController {
        return minipaySDK.login(
            callback: { [weak self] result in
                switch result {
                case .success(let result):
                    self?.minipayToken = result
                case .failure(let error):
                    self?.error = error
                }
                
                completion()
            }
        )
    }

    func startAuthorizeAppFlow(customUserId: String, planId: String, completion: @escaping () -> Void) {
        error = ""
        authorizeAppResult = ""

        minipaySDK.authorizeApp(
            customUserId: customUserId,
            planId: planId,
            minipayToken: self.minipayToken,
            callback: { [weak self] result in
                switch result {
                case .success(let result):
                    self?.authorizeAppResult = result ? "App Authorized" : "App Auth Failed"
                case .failure(let error):
                    self?.error = error
                }
                
                completion()
            }
        )
    }

    func startPostUsageEventFlow(customUserId: String, planId: String, completion: @escaping () -> Void) {
        error = ""
        postUsageEventResult = ""

        minipaySDK.postUsageEvent(
            customUserId: customUserId,
            planId: planId,
            callback: { [weak self] result in
                switch result {
                case .success(let result):
                    self?.postUsageEventResult = result ? "Access Authorized" : "Access Denied"
                case .failure(let error):
                    self?.error = error
                }
                
                completion()
            }
        )
    }
}
