import Foundation

/// Public typealias to be used by consumers. Includes all protocols that a UIView conforms to be used as a Text Animator
public typealias TextAnimatorView = TextAnimatorDesignable & Animateable

public class TextAnimatorFactory {
    
    /// Create a TextAnimatorView instance which will draw each line one after the other with max 5 lines of text
    /// - Returns: TextAnimatorView instance
    public class func drawingLines() -> TextAnimatorView? {
        let podBundle = Bundle(for: DrawingTextView.self)
        guard let url = podBundle.url(forResource: "thinkitive-text-animator", withExtension: "bundle"),
              let bundle = Bundle(url: url),
              let drawingTextView = bundle.loadNibNamed("DrawingTextView", owner: nil, options: nil)?.first as? DrawingTextView else {
            return nil
        }

        return drawingTextView
    }
}
