
import UIKit

/**
 * Information about a reward
 */

class RewardView : UIView {

    let stat: RewardStats

    init(stat: RewardStats)
    {
        self.stat = stat

        super.init(frame: CGRectZero)

        setupViews()
    }

    func setupViews()
    {
        let icon = ViewUtil.imageScaledFromUrl(stat.icon) // TODO: use sd_setImageWithURL
        let iconSize : Float = 50

        // TODO: color of title and points is grey when the reward is not completed

        let title = ViewUtil.labelWithSize(16)
        title.numberOfLines = 0
        title.text = stat.title

        let desc = ViewUtil.labelWithSize(14)
        desc.numberOfLines = 0
        desc.text = stat.desc

        let points = ViewUtil.labelWithSize(16)
        points.text = "\(stat.points)PTS" // TODO: rewards_pts
        points.textColor = ViewUtil.MainColor

        // TODO: angle changes when desc is toggled

        let angle = ViewUtil.labelAwesome("\u{f107}", size:20, color:ViewUtil.DefaultTextColor) // TODO: fa_angle_down

        // TODO: smaller icon (25 or so), centered inside progress circle (of size 50)
        // Except for CONTINUE_WITH_US

        LayoutHelper(view: self)
            .addViews(["icon":icon, "title":title, "desc":desc, "points":points, "angle":angle])
            .withMetrics(["is":iconSize])
            .addConstraints([
                "H:|[icon(is)]-[title]-[points]-[angle]|",
                "H:[icon]-[desc]|",
                "V:|[icon(is)]-(>=0)-|",
                "V:|[title(>=is)][desc]|",
                "X:points.centerY == title.centerY",
                "X:angle.centerY == title.centerY"
            ])
            .setWrapContent("points", axis: .Horizontal)
            .setWrapContent("angle", axis: .Horizontal)
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
