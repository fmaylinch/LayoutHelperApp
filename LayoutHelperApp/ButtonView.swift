
/** View that can be pressed like a button */

import UIKit

class ButtonView : UIView {

    private static let NoOp = { (btn:ButtonView) in }
    
    /* Called when the view goes to normal state (set desired appearance) */
    var onNormal = NoOp
    /* Called when the view goes to pressed state (set desired appearance) */
    var onPressed = NoOp
    /* Called when the view is released (perform desired action) */
    var onReleased = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onNormal(self)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onPressed(self)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onNormal(self)
        onReleased()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
