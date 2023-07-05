import UIKit

class DrawingLabel: UILabel {
    
    var glyphLayer: CAShapeLayer?
    var drawingColor: UIColor = UIColor.white
    var fillColor: UIColor = UIColor.black

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = UIColor.clear
    }
}

extension DrawingLabel: Animateable {
    func updateCurrentTime(percentage: CGFloat) {
        if let glyphLayer = self.glyphLayer {
            glyphLayer.removeFromSuperlayer()
        }
        
        guard let text = self.text else { return }
        
        let path =  text.path(withFont: font)
        let glyphLayer : CAShapeLayer = CAShapeLayer()
        glyphLayer.strokeColor = drawingColor.cgColor
        glyphLayer.lineWidth = font.pointSize / 40
        glyphLayer.fillColor = UIColor.clear.cgColor
        glyphLayer.path = path
        glyphLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.glyphLayer = glyphLayer
        layer.addSublayer(glyphLayer)
        glyphLayer.shouldRasterize = true
        glyphLayer.rasterizationScale = UIScreen.main.scale
        glyphLayer.contentsScale = UIScreen.main.scale
                
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = percentage
        animation.speed = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0
            
        if percentage == 1 {
            glyphLayer.fillColor = fillColor.cgColor
        } else {
            glyphLayer.fillColor = UIColor.clear.cgColor
        }
        
        glyphLayer.removeAllAnimations()
        glyphLayer.add(animation, forKey: "myStroke")
        CATransaction.commit()
    }
}
