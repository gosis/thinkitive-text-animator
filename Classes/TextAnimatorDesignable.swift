import UIKit

/// Protocol for a designable UIView
public protocol TextAnimatorDesignable: UIView {
    
    func getFont() -> UIFont
    func getTextColor() -> UIColor
    func getOutlineColor() -> UIColor
    func getTextAlignment() -> NSTextAlignment
    
    func setFont(font: UIFont)
    func setText(lines: [String])
    func setOutlineColor(color: UIColor)
    func setTextAlignment(textAlignment: NSTextAlignment)
    func setLineWidth(width: CGFloat)
    
    func updateLayout()
}

/// Protocol for animateable UIView
public protocol Animateable {
    func updateCurrentTime(percentage:CGFloat)
}
