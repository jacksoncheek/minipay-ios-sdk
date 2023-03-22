import UIKit

class StyledTextField: UITextField {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: 20, dy: 10)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.insetBy(dx: 20, dy: 10)
    }

    private func setup() {
        autocapitalizationType = .none
        textColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) // #ECECEC
        tintColor = #colorLiteral(red: 1, green: 0.0862745098, blue: 0.3294117647, alpha: 1) // #FF1654
        layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) // #ECECEC
        layer.borderWidth = 2.0
        layer.cornerRadius = 24
    }
}
