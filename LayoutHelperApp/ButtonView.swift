
/** View that can be pressed like a button */

import UIKit

class ButtonView : UIView, UIGestureRecognizerDelegate {

    private static let NoOp = { (btn:ButtonView) in }
    
    /* Called when the view goes to normal state (set desired appearance) */
    var onNormal = NoOp
    /* Called when the view goes to pressed state (set desired appearance) */
    var onPressed = NoOp
    /* Called when the view is released (perform desired action) */
    var action = {}

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: Selector("touched:"))
        recognizer.delegate = self
        recognizer.minimumPressDuration = 0.0
        addGestureRecognizer(recognizer)
        userInteractionEnabled = true
        
        onNormal(self)
    }
    
    func touched(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .Began {
            onPressed(self)
        } else if sender.state == .Ended {
            onNormal(self)
            action()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
