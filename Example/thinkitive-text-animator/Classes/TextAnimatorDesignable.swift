import UIKit

/// Protocol for a designable UIView
public protocol TextAnimatorDesignable: UIView {
    
    func getFont() -> UIFont
    func getTextColor() -> UIColor
    func getBorderColor() -> UIColor
    func getTextAlignment() -> NSTextAlignment
    
    func setFont(font: UIFont)
    func setText(lines: [String])
    func setColor(color: UIColor)
    func setBorderColor(color: UIColor)
    func setTextAlignment(textAlignment: NSTextAlignment)
    
    func updateLayout()
}

/// Protocol for animateable UIView
public protocol Animateable {
    func updateCurrentTime(percentage:CGFloat)
}
