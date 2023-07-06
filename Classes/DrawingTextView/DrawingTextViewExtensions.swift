import Foundation
import UIKit

extension DrawingTextView: TextAnimatorDesignable {
    
    public func getFont() -> UIFont {
        let label = labels.at(index: 0)!
        return label.font
    }
    
    public func getTextColor() -> UIColor {
        let label = labels.at(index: 0)!
        if let drawingLabel = label as? DrawingLabel {
            return drawingLabel.textColor
        }
        return UIColor.clear
    }
    
    public func setText(lines: [String]) {
        for i in 0..<5 {
               if let existingLabel = labels.at(index: i) {
                if let line = lines.at(index: i) {
                    existingLabel.isHidden = false
                    existingLabel.text = line
                } else {
                    existingLabel.isHidden = true
                }
            }
        }
        
        var longestLabelIndex = 0
        var longestLabelSize = CGFloat(0)
        
        for i in 0..<labels.count {
            if let label = labels.at(index: i), let text = label.text, !label.isHidden {
                let size = text.widthOfString(usingFont: label.font)
                if size > longestLabelSize {
                    longestLabelSize = size
                    longestLabelIndex = i
                }
            }
        }
        label.text = labels.at(index: longestLabelIndex)!.text
    }
    
    public func getText() -> String {
        var text = ""
        for label1 in labels {
            if let labelText = label1.text,
               !label1.isHidden {
                if text.count > 0 {
                    text = text + "\n" + labelText
                } else {
                    text = labelText
                }
            }
        }
        
        return text
    }
    
    public func getOutlineColor() -> UIColor {
        
        let label = self.labels.at(index: 0)!
        if let drawingLabel = label as? DrawingLabel {
            return drawingLabel.drawingColor
        }
        return UIColor.clear
    }
    
    public func getTextAlignment() -> NSTextAlignment {
        return self.stackView.textAlignment
    }
    
    
    public func setFont(font: UIFont) {
        label.font = font
        for label1 in labels {
            if let drawingLabel = label1 as? DrawingLabel {
                drawingLabel.font = font
            }
        }
    }
    
    public func setOutlineColor(color: UIColor) {
        for label1 in labels {
            if let drawingLabel = label1 as? DrawingLabel {
                drawingLabel.drawingColor = color
            }
        }
    }
    
    public func setTextAlignment(textAlignment: NSTextAlignment) {
        stackView.textAlignment = textAlignment
    }
    
    public func setLineWidth(width: CGFloat) {
        for label1 in labels {
            if let drawingLabel = label1 as? DrawingLabel {
                drawingLabel.lineWidth = width
            }
        }
    }
    
    public func updateLayout() {
        layoutIfNeeded()
        label.setMaxPossibleFont(numberOfLines: numberOfLines())
        
        for label1 in labels {
            label1.font = label.font
        }
    }
    
    private func numberOfLines() -> Int {
        var lineCount = 0
        for label in labels {
            if !label.isHidden {
                lineCount += 1
            }
        }
        return lineCount
    }
}

extension DrawingTextView: Animateable {
    public func updateCurrentTime(percentage: CGFloat) {
        let lines = numberOfLines()
        var fullLinePercentage = CGFloat(0.0)
        if lines > 0 {
            fullLinePercentage = CGFloat(100 / lines)
        }
        
        var remainingPercentage = CGFloat(percentage * 100)
        
        for i in 0..<labels.count {
            
            if let label = labels.at(index: i),
               let animateable = label as? Animateable {
                
                var linePercentage = CGFloat(0.0)
                if fullLinePercentage != 0 {
                    linePercentage = remainingPercentage / CGFloat(fullLinePercentage)
                }
                
                if linePercentage > 1 {
                    linePercentage = 1.0
                }
                
                if linePercentage < 0 {
                    linePercentage = 0.0
                }
                
                animateable.updateCurrentTime(percentage: linePercentage)
                remainingPercentage -= fullLinePercentage
            }
        }
    }
}
