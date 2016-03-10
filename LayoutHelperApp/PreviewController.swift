
/**
 * Use this controller to try your layouts.
 * Override `setupViews` and add your views to `mainView` (not to `view`).
 */

import UIKit

class PreviewController: PreviewBaseController {
    
    override func setupViews() {
        
        // Use mainView instead of view
        mainView.backgroundColor = .whiteColor()
        
        // Example of LinearLayout and some ViewUtil functions
        let linear = LinearLayout(orientation: .Vertical)
        linear.marginBetween = 20
        for i in 1...10 {
            let label = ViewUtil.labelWithSize(50)
            label.text = "View \(i)"
            label.textAlignment = .Center
            label.backgroundColor = ViewUtil.color(argb: 0x50905070)
            linear.appendSubview(label)
        }
        
        // Example of scroll view
        // Note: In your real controller, use LayoutHelper(controller:) normally
        __LayoutHelper(controller: self).fillWithScrollView(.Vertical, contentView:linear)
    }
}
