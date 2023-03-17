import UIKit
import MinipaySDK
import SnapKit

class ViewController: UIViewController {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        
        return stackView
    }()
    
    lazy var minipayDemoTitle: UILabel = {
        let label = UILabel()
        label.text = "Minipay Demo"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return label
    }()
    
    lazy var loginButton: StyledButton = {
        let button = StyledButton()
        button.setTitle("START LOGIN FLOW", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return button
    }()
    
    lazy var loginState: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()

    lazy var authAppButton: StyledButton = {
        let button = StyledButton()
        button.setTitle("START AUTHORIZE APP FLOW", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.isEnabled = false
        
        return button
    }()

    lazy var authAppState: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()

    lazy var postUsageEventButton: StyledButton = {
        let button = StyledButton()
        button.setTitle("POST USAGE EVENT", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.isEnabled = false

        return button
    }()

    lazy var postUsageEventState: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()

    lazy var error: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .red
        
        return label
    }()
    
    lazy var progress: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView()
        progress.startAnimating()
        progress.isHidden = true
        
        return progress
    }()

    private var viewModel: ViewModel = ViewModel(minipaySDK: Graph.instance!.minipaySDK)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(progress)
        progress.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
        }
        
        loginButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
        }
        
        stackView.addArrangedSubview(minipayDemoTitle)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(loginState)
        stackView.addArrangedSubview(authAppButton)
        stackView.addArrangedSubview(authAppState)
        stackView.addArrangedSubview(postUsageEventButton)
        stackView.addArrangedSubview(postUsageEventState)
        stackView.addArrangedSubview(error)
        
        update()
        setBindings()
    }
    
    private func setBindings() {
        loginButton.addTarget(self, action: #selector(startLoginFlow), for: .touchUpInside)

        authAppButton.addTarget(self, action: #selector(startAuthorizeAppFlow), for: .touchUpInside)

        postUsageEventButton.addTarget(self, action: #selector(startPostUsageEventFlow), for: .touchUpInside)
    }

    @objc private func startLoginFlow() {
        animateLoading(isLoading: true)
        setError(error: "")

        let loginViewController = viewModel.startLoginFlow(
            completion: { [weak self] in
                self?.update()
                self?.animateLoading(isLoading: false)
            }
        )
        
        self.present(loginViewController, animated: true)
    }

    @objc private func startAuthorizeAppFlow() {
        animateLoading(isLoading: true)
        setError(error: "")

        viewModel.startAuthorizeAppFlow(
            customUserId: "<your-custom-user-id>",
            planId: "<your-plan-id>",
            completion: { [weak self] in
                self?.update()
                self?.animateLoading(isLoading: false)
            }
        )
    }

    @objc private func startPostUsageEventFlow() {
        animateLoading(isLoading: true)
        setError(error: "")

        viewModel.startPostUsageEventFlow(
            customUserId: "<your-custom-user-id>",
            planId: "<your-plan-id>",
            completion: { [weak self] in
                self?.update()
                self?.animateLoading(isLoading: false)
            }
        )
    }

    private func animateLoading(isLoading: Bool) {
        progress.isHidden = !isLoading
        minipayDemoTitle.isHidden = isLoading
        loginButton.isHidden = isLoading
        loginState.isHidden = isLoading
        authAppButton.isHidden = isLoading
        authAppState.isHidden = isLoading
        postUsageEventButton.isHidden = isLoading
        postUsageEventState.isHidden = isLoading
        error.isHidden = isLoading
    }

    private func update() {
        loginState.text = viewModel.minipayToken

        authAppState.text = viewModel.authorizeAppResult

        postUsageEventState.text = viewModel.postUsageEventResult

        authAppButton.isEnabled = viewModel.isAuthorizeAppFlowEnabled

        postUsageEventButton.isEnabled = viewModel.isPostUsageEventFlowEnabled

        if viewModel.error.isEmpty == false {
            setError(error: viewModel.error)
        }
    }

    private func setError(error: String) {
        self.error.text = error
    }
}
