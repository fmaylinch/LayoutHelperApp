
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
        linear.appendSubview( MyClubHeaderView() )
        linear.appendSubview( RewardsView() )

        
        // Example of scroll view
        // Note: In your real controller, use LayoutHelper(controller:) normally
        __LayoutHelper(controller: self).fillWithScrollView(.Vertical, contentView:linear)
    }
}
