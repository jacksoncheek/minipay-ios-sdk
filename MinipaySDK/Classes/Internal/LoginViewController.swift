import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 32
        
        return stackView
    }()
    
    lazy var minipayTitle: UILabel = {
        let label = UILabel()
        label.text = "minipay"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        
        return label
    }()
    
    lazy var email: UITextField = {
        let textField = StyledTextField()
        textField.keyboardType = .emailAddress
        let placeholder = NSAttributedString(
            string: "Email Address",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)] // #ECECEC
        )
        textField.attributedPlaceholder = placeholder

        return textField
    }()
    
    lazy var password: UITextField = {
        let textField = StyledTextField()
        textField.isSecureTextEntry = true
        let placeholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)] // #ECECEC
        )
        textField.attributedPlaceholder = placeholder

        return textField
    }()
    
    lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
        stackView.spacing = 16
        
        return stackView
    }()

    lazy var login: StyledButton = {
        let button = StyledButton()
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.isEnabled = false
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return button
    }()
    
    lazy var spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return view
    }()
    
    lazy var terms: UILabel = {
        let label = UILabel()
        label.text = "By providing your Minipay login information, you allow Minipay to authorize future payments in accordance with this app's terms."
        label.textColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) // #ECECEC
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        
        return label
    }()

    lazy var error: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = #colorLiteral(red: 1, green: 0.0862745098, blue: 0.3294117647, alpha: 1) // #FF1654
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .red
        label.numberOfLines = 0

        return label
    }()
    
    lazy var progress: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView()
        progress.startAnimating()
        progress.isHidden = true
        
        return progress
    }()

    let viewModel: LoginViewModel = LoginViewModel(
        minipayService: Graph.instance!.minipayService,
        callback: Graph.instance!.stateRepo.loginResultCallback
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.137254902, blue: 0.2274509804, alpha: 1) // #17233A
        
        view.addSubview(progress)
        progress.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().inset(32)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
        }
        
        email.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
        }

        password.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
        }

        login.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
            make.width.greaterThanOrEqualTo(100)
        }
        loginStackView.addArrangedSubview(spacer)
        loginStackView.addArrangedSubview(login)

        stackView.addArrangedSubview(minipayTitle)
        stackView.addArrangedSubview(email)
        stackView.addArrangedSubview(password)
        stackView.addArrangedSubview(loginStackView)
        stackView.addArrangedSubview(terms)
        stackView.addArrangedSubview(error)
        
        setBindings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !viewModel.didComplete {
            viewModel.callback(.failure(error: "User canceled"))
        }
        super.viewDidDisappear(animated)
    }
    
    private func setBindings() {
        email.addTarget(self, action: #selector(onEmailAddressChange), for: .editingChanged)

        password.addTarget(self, action: #selector(onPasswordChange), for: .editingChanged)
        
        login.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
    }

    @objc func onEmailAddressChange() {
        viewModel.email = email.text ?? ""
        login.isEnabled = viewModel.isLoginButtonEnabled
    }

    @objc func onPasswordChange() {
        viewModel.password = password.text ?? ""
        login.isEnabled = viewModel.isLoginButtonEnabled
    }

    @objc func onLogin() {
        animateLoading(isLoading: true)
        setError(error: "")

        viewModel.login(completion: { [weak self] result in
            self?.animateLoading(isLoading: false)
            
            switch result {
            case .success(let token):
                self?.viewModel.callback(.success(result: token))
                self?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self?.setError(error: error)
            }
        })
    }

    private func animateLoading(isLoading: Bool) {
        progress.isHidden = !isLoading
        minipayTitle.isHidden = isLoading
        email.isHidden = isLoading
        password.isHidden = isLoading
        login.isHidden = isLoading
        terms.isHidden = isLoading
        error.isHidden = isLoading
    }

    private func setError(error: String) {
        self.error.text = error
    }
}
