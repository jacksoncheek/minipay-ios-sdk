internal class LoginViewModel {

    let minipayService: MinipayService
    
    let callback: MinipaySDKLoginResultCallback
    
    var email: String = ""

    var password: String = ""
    
    var didComplete: Bool = false

    var isLoginButtonEnabled: Bool {
        return !email.isEmpty && !password.isEmpty
    }

    init(
        minipayService: MinipayService,
        callback: @escaping MinipaySDKLoginResultCallback
    ) {
        self.minipayService = minipayService
        self.callback = callback
    }
    
    func login(completion: @escaping (MinipaySDKResult<String>) -> Void) {
        let request = LoginRequest(credentials: Credentials(email: email, password: password))
        
        minipayService.login(request: request, callback: { [weak self] result in
            switch result {
            case .success(let token):
                self?.didComplete = true
                completion(.success(result: token))
            case .failure(_):
                completion(.failure(error: "Login failed"))
            }
        })

    }
}
