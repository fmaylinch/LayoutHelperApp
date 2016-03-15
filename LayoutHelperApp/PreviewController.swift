
/**
 * Use this controller to try your layouts.
 * Override `setupViews` and add your views to `mainView` (not to `view`).
 */

import UIKit

class PreviewController: PreviewBaseController {
    
    override func setupViews() {
        
        // Use mainView instead of view
        mainView.backgroundColor = .whiteColor()

        let rewardsView = RewardsView()

        // Example of LinearLayout and some ViewUtil functions
        let linear = LinearLayout(orientation: .Vertical)
        linear.appendSubview( MyClubHeaderView() )
        linear.appendSubview( rewardsView )

        setupHelpButton(rewardsView.helpBtn)

        // Example of scroll view
        // Note: In your real controller, use LayoutHelper(controller:) normally
        __LayoutHelper(controller: self).fillWithScrollView(.Vertical, contentView:linear)
    }

    func setupHelpButton(helpBtn: UIView)
    {
        // TODO: load config and then display button
        helpBtn.hidden = false
        // TODO: rewardsView.helpBtn.onTap RewardsUtil.presentInfo(config, fromController:self)
    }
}
