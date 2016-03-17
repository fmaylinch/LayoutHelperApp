
import UIKit

/**
 * Information about a reward.
 * Description label can be toggled (show/hide).
 */

class RewardView : UIView {

    // TODO: move to FontAwesomeIcons.h
    static let FA_Angle_Up = "\u{f106}"
    static let FA_Angle_Down = "\u{f107}"

    let angle = ViewUtil.labelAwesome("", size:20)
    var expanded = true
    var descHeightZero: NSLayoutConstraint!

    var layout: LayoutHelper!

    let stat: RewardStats


    init(stat: RewardStats)
    {
        self.stat = stat

        super.init(frame: CGRectZero)

        setupViews()
    }

    private func setupViews()
    {
        let icon = ViewUtil.imageScaledFromUrl(stat.icon) // TODO: use sd_setImageWithURL
        let iconSize : Float = 50

        // TODO: color of title, points and angle is grey when the reward is not completed

        let title = ViewUtil.labelWithSize(16)
        title.numberOfLines = 0
        title.text = stat.title

        let desc = ViewUtil.labelWithSize(14)
        desc.text = stat.desc
        desc.numberOfLines = 0

        let points = ViewUtil.labelWithSize(16)
        points.text = "\(stat.points)PTS" // TODO: rewards_pts
        points.textColor = ViewUtil.MainColor

        // TODO: smaller icon (25 or so), centered inside progress circle (of size 50)
        // Except for CONTINUE_WITH_US (though we could have made a standard icon)

        layout = LayoutHelper(view: self)
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

        collapse()
    }

    func collapse()
    {
        guard expanded else { return }

        self.angle.text = RewardView.FA_Angle_Down

        // Add just one constraint to make label have height 0
        let cs = self.layout.addAndGetConstraint("V:[desc(0)]")
        self.descHeightZero = cs[0]

        expanded = false
    }

    func expand()
    {
        guard !expanded else { return }

        self.angle.text = RewardView.FA_Angle_Up

        // Let the label grow to fit text
        self.removeConstraint(self.descHeightZero)

        expanded = true
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
