import UIKit

extension Array {
    
    /// Return array elements if exists without crashing
    /// - Parameter index: index at which to try and return an element
    /// - Returns: element of array type or nil
    func at(index: Int) -> Element? {
        if index < 0 || index > self.count - 1 {
            return nil
        }
        return self[index]
    }
}

public extension String {
    
    /// Returns CGPath for given string
    /// - Parameter font: font to be used for the string
    /// - Returns: CGPath of the String
    func path(withFont font: UIFont) -> CGPath {
        let attributedString = NSAttributedString(string: self, attributes: [.font: font])
        let path = attributedString.path()
        return path
    }
    
    /// Returns width of string for provided font
    /// - Parameter font: font to be used
    /// - Returns: width of the string
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

private extension NSAttributedString {
    func path() -> CGPath {
        let path = CGMutablePath()

        // Use CoreText to lay the string out as a line
        let line = CTLineCreateWithAttributedString(self as CFAttributedString)

        // Iterate the runs on the line
        let runArray = CTLineGetGlyphRuns(line)
        let numRuns = CFArrayGetCount(runArray)
        for runIndex in 0..<numRuns {

            // Get the font for this run
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let runAttributes = CTRunGetAttributes(run) as Dictionary
            let runFont = runAttributes[kCTFontAttributeName] as! CTFont
            let font = runAttributes[kCTFontAttributeName] as! UIFont

            // Iterate the glyphs in this run
            let numGlyphs = CTRunGetGlyphCount(run)
            for glyphIndex in 0..<numGlyphs {
                let glyphRange = CFRangeMake(glyphIndex, 1)

                // Get the glyph
                var glyph : CGGlyph = 0
                withUnsafeMutablePointer(to: &glyph) { glyphPtr in
                    CTRunGetGlyphs(run, glyphRange, glyphPtr)
                }

                // Get the position
                var position : CGPoint = .zero
                withUnsafeMutablePointer(to: &position) {positionPtr in
                    CTRunGetPositions(run, glyphRange, positionPtr)
                }

                // Get a path for the glyph
                var transform = CGAffineTransform.identity
                transform = transform.scaledBy(x: 1, y: -1)
                transform = transform.translatedBy(x: 0, y: -font.pointSize)
                guard let glyphPath = CTFontCreatePathForGlyph(runFont, glyph, &transform) else {
                    continue
                }

                // Transform the glyph as it is added to the final path
                let t = CGAffineTransform(translationX: position.x, y: position.y)
                path.addPath(glyphPath, transform: t)
            }
        }

        return path
    }
}

extension UILabel {
    
    /// Sets max possible font to a UILabel to fit in the existing frame
    ///
    /// NOTE: Quite a costly function as it keeps calling itself updating font on UILabel until a closest font size to fill the frame is found
    /// used when resizing Text animators
    /// - Parameter numberOfLines: number of lines of text in UILabel
    public func setMaxPossibleFont(numberOfLines: Int) {
        setMaxPossibleFont(size: font.pointSize + 0.4,
                                numberOfLines: numberOfLines)
    }
    
    enum FontSizeResult {
        case tooBig
        case tooSmall
        case equilibrium
    }
    
    
    private func fontChangeResult(numberOfLines:Int) -> FontSizeResult {
        
        guard let labelText = text as NSString? else {
            return .equilibrium
        }
        
        if labelText == "" {
            return .equilibrium
        }
        
        let size = labelText.size(withAttributes: [NSAttributedString.Key.font: font as Any])
        
        if size.width == 0 ||
            size.height == 0 {
            return .equilibrium
        }
        
        
        if bounds.width - size.width > 0 &&
            abs(bounds.width - size.width) < 5 {
            return shrinkToFitHeight(fontSize: font.pointSize,
                                          numberOfLines: numberOfLines)
        }
        
        if size.width > bounds.width {
            return .tooBig
        } else {
            return .tooSmall
        }
    }
    
    private func shrinkToFitHeight(fontSize:CGFloat,
                                   numberOfLines:Int) -> FontSizeResult {
        
        guard let superView = self.superview else {
            return .equilibrium
        }
        
        if fontSize <= 0 {
            return .equilibrium
        }
        
        font = font.withSize(fontSize)
        
        let maxHeight = font.lineHeight * CGFloat(numberOfLines)
        
        if superView.frame.size.height - maxHeight > 1 {
            return .equilibrium
        }
        
        return shrinkToFitHeight(fontSize: fontSize - 0.4,
                                      numberOfLines: numberOfLines)
    }
    
    private func setMaxPossibleFont(size:CGFloat, numberOfLines:Int) {
        
        self.font = font.withSize(size)
        
        let fontChangeResult = fontChangeResult(numberOfLines: numberOfLines)
        
        switch fontChangeResult {
        case .tooBig:
            setMaxPossibleFont(size: size - 0.4, numberOfLines: numberOfLines)
            break
        case .tooSmall:
            setMaxPossibleFont(size: size + 0.4, numberOfLines: numberOfLines)
            break
        case .equilibrium:
            break
        }
    }
}

extension UIStackView {
    
    var textAlignment:NSTextAlignment {
        
        get {
            if self.alignment == .leading {
                return NSTextAlignment.left
            }
            
            if self.alignment == .center {
                return NSTextAlignment.center
            }
            
            if self.alignment == .trailing {
                return NSTextAlignment.right
            }
            
            return NSTextAlignment.justified
        }
        
        set {
            if newValue == .left {
                alignment = .leading
            }
            
            if newValue == .center {
                alignment = .center
            }
            
            if newValue == .right {
                alignment = .trailing
            }
        }
    }
}
