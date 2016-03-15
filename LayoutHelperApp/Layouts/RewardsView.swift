
/** Stats about the clubber rewards */

import UIKit

class RewardsView : LinearLayout {

    // Help button in header
    let helpBtn = UIView()
    let helpLbl = ViewUtil.labelWithSize(22)
    let helpBtnPadding: Float = 10

    // Reward progress
    let pointsBarView = UIView()
    let daysLeftLbl = ViewUtil.labelWithSize(15)
    let daysBarView = UIView()

    // Rewards list
    let rewardsView = UIView()

    // Total
    let totalPointsLbl = ViewUtil.labelWithSize(32)


    init()
    {
        super.init(orientation: .Vertical)
        setupViews()
        loadRewards()
    }


    // Initial setup of views (performed once)

    func setupViews()
    {
        self.marginSides = 30 // TODO: this margin is also used in MyClubHeaderView
        self.marginEnds = 20

        appendHeader()
        appendProgress()
        appendRewards()
        appendTotals()
    }

    func appendHeader()
    {
        let trophy = ViewUtil.imageScaled("rewards_trophy")

        let title = ViewUtil.labelWithSize(30)
        title.text = "GYMFORLESS\nREWARDS" // We need the line break
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true

        let helpBtnSize: Float = 50
        let helpBtn = buildHelpButton(helpBtnSize)
        helpBtn.hidden = true
        helpBtn.userInteractionEnabled = true

        // Apply negative padding to the right of helpBtn to align padded helpLbl
        let paddingFix = -helpBtnPadding

        let header = LayoutHelper()
            .addViews(["trophy":trophy, "title":title, "helpBtn":helpBtn])
            .withMetrics(["ts":80, "hbs": helpBtnSize, "pf":paddingFix])
            .addConstraints([
                "H:|[trophy(ts)]-(15)-[title]-[helpBtn(hbs)]-(pf)-|",
                "V:|[trophy(ts)]|", "V:|[title]|",
                "V:[helpBtn(hbs)]",
                "X:helpBtn.centerY == parent.centerY"
            ])
            .view

        self.appendSubview(header)
    }

    /** Button with the "?" character */
    func buildHelpButton(size: Float) -> UIView
    {
        helpLbl.text = "?"
        helpLbl.textAlignment = .Center
        helpLbl.textColor = .whiteColor()
        helpLbl.backgroundColor = ViewUtil.MainColor

        // Add padding so clickable area is bigger
        let p = CGFloat(helpBtnPadding)
        return LayoutHelper(view: helpBtn)
            .fillWithView(helpLbl, margins: UIEdgeInsetsMake(p, p, p, p))
            .view
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Make helpLbl background circular
        layoutIfNeeded() // so helpIcon.frame is calculated
        helpLbl.layer.cornerRadius = helpLbl.frame.size.height / 2.0
        helpLbl.layer.masksToBounds = true
    }

    func appendProgress()
    {
        let title = ViewUtil.labelWithSize(28)
        title.text = "CURRENT PROGRESS" // TODO: rewards_progress
        title.textColor = ViewUtil.MainColor

        daysLeftLbl.textAlignment = .Center
        daysLeftLbl.adjustsFontSizeToFitWidth = true

        self.marginBetween = 20
        self.appendSubview(title)
        self.marginBetween = 0
        self.appendSubview(pointsBarView)
        self.appendSubview(daysLeftLbl)
        self.appendSubview(daysBarView)
    }

    func appendRewards()
    {
        let title = ViewUtil.labelWithSize(28)
        title.text = "MY REWARDS" // TODO: rewards_mine
        title.textColor = ViewUtil.MainColor

        self.marginBetween = 20
        self.appendSubview(title)
        self.marginBetween = 0
        self.appendSubview(rewardsView)
    }

    func appendTotals()
    {
        self.marginSides = 0
        self.marginEnds = 0

        let title = ViewUtil.labelWithSize(23)
        title.adjustsFontSizeToFitWidth = true
        title.text = "TOTAL REWARDS EARNED" // TODO: rewards_mine
        title.textColor = .whiteColor()

        totalPointsLbl.textColor = .whiteColor()
        totalPointsLbl.textAlignment = .Right

        let linear = LinearLayout(orientation: .Vertical)
        linear.backgroundColor = ViewUtil.MainColor
        linear.marginSides = 30
        linear.marginEnds = 20
        linear.marginBetween = 20

        linear.appendSubview(title)
        linear.appendSubview(totalPointsLbl)

        self.marginBetween = 20
        self.appendSubview(linear)
    }


    // Setup of rewards (done at start and each time we refresh)

    func loadRewards()
    {
        // TODO: load real Rewards
        let rewards = Rewards()
        rewards.daysLeft = 15

        setupView(rewards)
    }

    func setupView(rewards: Rewards)
    {
        daysLeftLbl.text = "\(rewards.daysLeft) DAYS TO COMPLETE CURRENT CHALLENGES" // TODO: rewards_days_left

        // TODO: points bar, days bar, reward list
        totalPointsLbl.text = "10 POINTS = 2€"
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
