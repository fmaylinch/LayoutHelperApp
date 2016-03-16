
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

        loadRewards(rewardsView)

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

    func loadRewards(rewardsView: RewardsView) {

        // TODO: load real Rewards
        let rewards = Rewards()
        rewards.daysPassed = 18
        rewards.daysLeft = 12
        rewards.totalPoints = 45
        rewards.currentPoints = 20
        rewards.discount = 4
        rewards.level = 1

        rewardsView.updateRewards(rewards)
    }
}
