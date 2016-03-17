
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
        let rewardsView = RewardsView()
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

        let stat1 = RewardStats()
        stat1.title = "DALE HARDER"
        stat1.desc = "OYE BRODEL YA TU SABE TE LO TIENES QUE CURRAR MOGOLLON PARA CONSEGUIR ESTA REWARD"
        stat1.type = "DIFFERENT_GYM"
        stat1.currentRepetitions = 1
        stat1.totalRepetitions = 3
        stat1.points = 15
        stat1.icon = "https://s3-eu-west-1.amazonaws.com/assets.gymforless.com/rewards/icon_3gyms.png"

        rewards.rewardStats = [stat1, stat1, stat1]

        rewardsView.updateRewards(rewards)
    }
}
