import UIKit

open class StyledButton: UIButton {
    
    public enum Defaults {
        public static var color: UIColor = #colorLiteral(red: 0.2274509804, green: 0.5254901961, blue: 1, alpha: 1) // #3A86FF
        public static var highlightedColor: UIColor = #colorLiteral(red: 0.3803921569, green: 0.6196078431, blue: 1, alpha: 1) // #619EFF
        public static var selectedColor: UIColor = #colorLiteral(red: 0.3803921569, green: 0.6196078431, blue: 1, alpha: 1) // #619EFF
        public static var disabledColor: UIColor = #colorLiteral(red: 0.2941176471, green: 0.3529411765, blue: 0.4509803922, alpha: 1) // #4B5A73
        public static var cornerRadius: CGFloat = 24
    }
    
    @IBInspectable
    public var color: UIColor = Defaults.color {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var highlightedColor: UIColor = Defaults.highlightedColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var selectedColor: UIColor = Defaults.selectedColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var disabledColor: UIColor = Defaults.disabledColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = Defaults.cornerRadius {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - UIButton
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setNeedsDisplay()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        setNeedsDisplay()
    }
    
    override open func draw(_ rect: CGRect) {
        updateBackgroundImages()
        super.draw(rect)
    }
    
    // MARK: - Internal methods
    
    fileprivate func configure() {
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }
    
    fileprivate func updateBackgroundImages() {
        
        let normalImage = Utils.buttonImage(color: color, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        let highlightedImage = Utils.highlightedButtonImage(color: highlightedColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius, buttonPressDepth: 0)
        let selectedImage = Utils.buttonImage(color: selectedColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        let disabledImage = Utils.buttonImage(color: disabledColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        
        setBackgroundImage(normalImage, for: .normal)
        setBackgroundImage(highlightedImage, for: .highlighted)
        setBackgroundImage(selectedImage, for: .selected)
        setBackgroundImage(disabledImage, for: .disabled)
    }
}

enum Utils {
    
    static func buttonImage(
        color: UIColor,
        shadowHeight: CGFloat,
        shadowColor: UIColor,
        cornerRadius: CGFloat) -> UIImage {
        
        return buttonImage(color: color, shadowHeight: shadowHeight, shadowColor: shadowColor, cornerRadius: cornerRadius, frontImageOffset: 0)
    }
    
    static func highlightedButtonImage(
        color: UIColor,
        shadowHeight: CGFloat,
        shadowColor: UIColor,
        cornerRadius: CGFloat,
        buttonPressDepth: Double) -> UIImage {
        
        return buttonImage(color: color, shadowHeight: shadowHeight, shadowColor: shadowColor, cornerRadius: cornerRadius, frontImageOffset: shadowHeight * CGFloat(buttonPressDepth))
    }
    
    static func buttonImage(
        color: UIColor,
        shadowHeight: CGFloat,
        shadowColor: UIColor,
        cornerRadius: CGFloat,
        frontImageOffset: CGFloat) -> UIImage {
        
        let width = max(1, cornerRadius * 2 + shadowHeight)
        let height = max(1, cornerRadius * 2 + shadowHeight)
        let size = CGSize(width: width, height: height)
            
        let frontImage = image(color: color, size: size, cornerRadius: cornerRadius)
        var backImage: UIImage? = nil
        if shadowHeight != 0 {
            backImage = image(color: shadowColor, size: size, cornerRadius: cornerRadius)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height + shadowHeight)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        backImage?.draw(at: CGPoint(x: 0, y: shadowHeight))
        frontImage.draw(at: CGPoint(x: 0, y: frontImageOffset))
        let nonResizableImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let capInsets = UIEdgeInsets(top: cornerRadius + frontImageOffset, left: cornerRadius, bottom: cornerRadius + shadowHeight - frontImageOffset, right: cornerRadius)
        let resizableImage = nonResizableImage?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
            
        return resizableImage ?? UIImage()
    }
    
    static func image(color: UIColor, size: CGSize, cornerRadius: CGFloat) -> UIImage {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let nonRoundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: cornerRadius
        ).addClip()
        nonRoundedImage?.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
