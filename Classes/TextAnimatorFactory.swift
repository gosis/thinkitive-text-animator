import Foundation

/// Public typealias to be used by consumers. Includes all protocols that a UIView conforms to be used as a Text Animator
public typealias TextAnimatorView = TextAnimatorDesignable & Animateable

public class TextAnimatorFactory {
    
    /// Create a TextAnimatorView instance which will draw each line one after the other with max 5 lines of text
    /// - Returns: TextAnimatorView instance
    public class func drawingLines() -> TextAnimatorView? {
        guard let drawingTextview = Bundle.main.loadNibNamed("DrawingTextView", owner: nil, options: nil)?.first as? TextAnimatorView else {
            return nil
        }
        
        return drawingTextview
    }
}
