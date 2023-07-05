import Foundation
import UIKit

public class DrawingTextView: UIView {
    
    /// Stack View holding the labels used for each line of text
    @IBOutlet var stackView: UIStackView!
    
    /// IBOutlet of all the labels sorted by their tag
    @IBOutlet var labels: [UILabel]!{
        didSet {
            labels.sort { $0.tag < $1.tag }
        }
    }
    
    /// Label used to calculate the max possible length of the longest line
    @IBOutlet var label:UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        label.numberOfLines = labels.count
        label.font = UIFont.systemFont(ofSize: label.font.pointSize)
    }
}
