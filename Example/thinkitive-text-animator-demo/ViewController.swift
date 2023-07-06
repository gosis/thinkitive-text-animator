//
//  ViewController.swift
//  thinkitive-text-animator
//
//  Created by Gints Osis on 03/07/2023.
//

import UIKit
import thinkitive_text_animator

class ViewController: UIViewController {
    
    private var updateTimer: Timer?
    private var timerScheduledTime = 0.0
    
    // Duration of the animation
    let animationDuration = 20.0

    // Weak reference to our text animator view
    weak var drawingTextView: TextAnimatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exampleLines = ["The quick",
                           "brown fox",
                           "jumps over",
                           "the lazy dog"]
        
        guard let drawingTextView = TextAnimatorFactory.drawingLines() else { return }
        
        view.addSubview(drawingTextView)
        
        drawingTextView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size)
        
        // Set font, its size doesn't matter much because .updateLayout() will be used
        // to set the final font size to fill the entire frame
        drawingTextView.setFont(font: UIFont(name: "Noteworthy", size: 30)!)
                        
        // Set an array of text lines
        drawingTextView.setText(lines: exampleLines)
        
        // Set alignment to the left
        drawingTextView.setTextAlignment(textAlignment: .center)
        
        // Set animated outline color
        drawingTextView.setOutlineColor(color: UIColor.black)
        
        // Set width of drawing outline
        drawingTextView.setLineWidth(width: 1.2)
        
        // Set the max possible font size for the new frame and update the inner layout
        drawingTextView.updateLayout()
                
        self.drawingTextView = drawingTextView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTimer = Timer.scheduledTimer(timeInterval: 1/60,
                                                target: self,
                                                selector: #selector(updateOverlays),
                                                userInfo: nil,
                                                repeats: true)
        timerScheduledTime = Date.timeIntervalSinceReferenceDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    @objc func updateOverlays() {
        
        guard let drawingTextView = self.drawingTextView else { return }
        
        let passedTime = CGFloat(Date.timeIntervalSinceReferenceDate - timerScheduledTime)
        let percentage = CGFloat(passedTime / animationDuration)
        
        // If animation has finished we restart it by resetting the animation start timestamp
        if percentage >= 1.0 {
            timerScheduledTime = Date.timeIntervalSinceReferenceDate
        }
        drawingTextView.updateCurrentTime(percentage: percentage)
    }
}

